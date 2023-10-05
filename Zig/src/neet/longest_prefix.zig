const std = @import("std");
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;
const expectEqualStrings = std.testing.expectEqualStrings;

pub fn longest_prefix(allocator: Allocator, words: [][]const u8) !?ArrayList(u8) {
    if (words.len == 0) {
        return null;
    }

    // Lexicographically sort the slice
    // This is the main way this algorithm saves runtime.
    // Sorting the slice allows skipping checking every word for the common prefix
    // The "largest" word's prefix will either match up with every previous word
    // lest the prefix is Lexicographically larger in which case the common prefix of
    // the middle words don't matter
    // Ex: ["goober", "good", "goofy", "gopher"]
    // ^ Only the smallest and largest words need to be checked
    var sorted = words;
    std.sort.sort([]const u8, sorted, {}, std.sort.desc([]const u8));

    // Shortest and longest words
    // The actual lengths don't matter
    const left = sorted[0];
    const right = sorted[sorted.len - 1];

    // Length of the shorter slice
    const short_len = @min(left.len, right.len);
    var prefix_len: usize = 0;
    while (prefix_len < short_len) : (prefix_len += 1) {
        if (left[prefix_len] != right[prefix_len]) {
            break;
        }
    }

    // Copy prefix slice
    if (prefix_len > 0) {
        var prefix = try ArrayList(u8).initCapacity(allocator, prefix_len);
        prefix.appendSliceAssumeCapacity(left[0..prefix_len]);

        return prefix;
    }

    return null;
}

test "longest prefix found" {
    const words = [_][]const u8{ "good", "goofy", "goober", "gopher", "going", "gone" };
    var result = try longest_prefix(std.testing.allocator, &words);

    if (result) |*prefix| {
        const actual = prefix.toOwnedSlice();
        try expectEqualStrings("go", actual);
    }
}
