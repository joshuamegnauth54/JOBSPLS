const std = @import("std");
const mem = std.mem;

const Allocator = mem.Allocator;
const expectEqual = std.testing.expectEqual;

/// Wagner-Fischer
pub fn levenshtein(allocator: Allocator, src: []const u8, dst: []const u8) !usize {
    const slen = src.len;
    const dlen = dst.len;

    // Edge case: empty strings
    if (slen == 0) {
        return dlen;
    }
    if (dlen == 0) {
        return slen;
    }

    // Edit distance matrix length.
    const slen_mat = slen + 1;
    const dlen_mat = dlen + 1;

    // Matrix of all prefix distances (edits) of `src` and `dst`.
    // The size is the string length + 1 to account for the zero cost empty position
    // var dist = try allocator.alloc(usize, slen * dlen);
    // TODO: Make a small ndarray.
    // Allocating a slice to hold pointers to allocated slices seems naughty.
    var dist = try allocator.alloc([]usize, slen_mat);
    for (dist) |*row| {
        row.* = try allocator.alloc(usize, dlen_mat);
    }
    defer allocator.free(dist);
    defer for (dist) |row| allocator.free(row);

    // An empty string can be changed into `src` by inserting each missing char
    for (0..slen_mat) |i| {
        dist[i][0] = i;
    }

    // The string on the column can be transformed into an empty string by deleting chars
    for (0..dlen_mat) |i| {
        dist[0][i] = i;
    }

    // Calculate Levenshtein distance for each pair of substrings
    // Results are cached at each step
    for (1..dlen_mat, 0..) |j, j_str| {
        for (1..slen_mat, 0..) |i, i_str| {
            const diagonal = dist[i - 1][j - 1];
            // Substitution or no change cost (diagonal)
            const substitution = if (src[i_str] == dst[j_str]) diagonal else diagonal + 1;
            // Columns represent the cost of deletion + previous transformations to get to char
            const deletion = dist[i - 1][j] + 1;
            // Row movement = cost of inserting characters
            const insertion = dist[i][j - 1] + 1;

            const costs = [3]usize{ substitution, deletion, insertion };

            // Minimum cost of converting the substring src[i] to dst[j]
            dist[i][j] = mem.min(
                usize,
                &costs,
            );
        }
    }

    // Bottommost element of the main diagonal is the cost of transforming `src` to `dst`
    return dist[slen - 1][dlen - 1];
}

/// Wagner-Fischer but memory optimized.
pub fn levenshtein_opt(allocator: Allocator, src: []const u8, dst: []const u8) !usize {
    const slen = src.len;
    const dlen = dst.len;

    if (slen == 0) {
        return dlen;
    }
    if (dlen == 0) {
        return slen;
    }

    var memo = [2][]usize{ undefined, undefined };
    memo[0] = try allocator.alloc(usize, dlen + 1);
    defer allocator.free(memo[0]);
    memo[1] = try allocator.alloc(usize, dlen + 1);
    defer allocator.free(memo[1]);

    // Fill out first row (empty string to destination).
    for (0..dlen + 1) |i| {
        memo[0][i] = i;
    }

    // Current read/write position, 0 or 1.
    // This works similarly to double buffering except I'm not swapping pointers.
    var read: u1 = 1;
    var write: u1 = 0;

    for (0..slen) |i| {
        read = read ^ 1;
        write = write ^ 1;
        memo[write][0] = i;
        for (0..dlen, 1..) |j, j_memo| {
            const diagonal = memo[read][j_memo - 1];
            const substitution = if (src[i] == dst[j]) diagonal else diagonal + 1;
            const deletion = memo[read][j_memo] + 1;
            const insertion = memo[write][j_memo - 1] + 1;

            const costs = [3]usize{ substitution, deletion, insertion };
            memo[write][j_memo] = mem.min(usize, &costs);
        }
    }

    // Write is the most current position
    return memo[write][dlen];
}

pub const Costs = struct {
    deletion: u32,
    insertion: u32,
    substitution: u32,

    fn default() @This() {
        return Costs{ .deletion = 1, .insertion = 1, .substitution = 1 };
    }
};

test "sitting kitten (normal)" {
    const expected: usize = 3;
    const actual = try levenshtein(std.testing.allocator, "sitting", "kitten");

    try expectEqual(expected, actual);
}

test "sitting kitten (optimized)" {
    const expected: usize = 3;
    const actual = try levenshtein_opt(std.testing.allocator, "sitting", "kitten");

    try expectEqual(expected, actual);
}

test "empty kitten" {
    const expected: usize = 6;
    const actual = try levenshtein(std.testing.allocator, "", "kitten");

    try expectEqual(expected, actual);
}

test "kitten empty" {
    const expected: usize = 6;
    const actual = try levenshtein(std.testing.allocator, "kitten", "");

    try expectEqual(expected, actual);
}
