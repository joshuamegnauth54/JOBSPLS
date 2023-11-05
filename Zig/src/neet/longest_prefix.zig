const std = @import("std");
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;
const expectEqualStrings = std.testing.expectEqualStrings;
const expectEqual = std.testing.expectEqual;

/// Longest, case sensitive prefix of all strings in `words`.
pub fn longest_prefix(allocator: Allocator, words: []const []const u8) !?[]const u8 {
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
    var sorted = try ArrayList([]const u8).initCapacity(allocator, words.len);
    defer sorted.deinit();
    sorted.appendSliceAssumeCapacity(words);
    std.sort.sort([]const u8, sorted.items, {}, desc_str);

    // Shortest and longest words
    // The actual lengths don't matter
    const left = sorted.items[0];
    const right = sorted.items[sorted.items.len - 1];

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

        return prefix.toOwnedSlice();
    }

    return null;
}

fn desc_str(_: void, a: []const u8, b: []const u8) bool {
    var i: usize = 0;
    while (a[i] < b[i] and i < a.len and i < b.len) : (i += 1) {}
    // Traversing all of `a` means a < b
    return i == a.len;
}

test "longest prefix found" {
    const words = [_][]const u8{ "good", "goofy", "goober", "gopher", "going", "gone" };
    var result = try longest_prefix(std.testing.allocator, &words);

    if (result) |actual| {
        defer std.testing.allocator.destroy(actual.ptr);
        try expectEqualStrings("go", actual);
    } else {
        @panic("Common prefix `go` should be found");
    }
}

test "longest prefix none" {
    const empty = [0][]const u8{};
    var result = try longest_prefix(std.testing.allocator, &empty);
    const expected: @TypeOf(result) = null;
    try expectEqual(expected, result);
}

test "longest prefix example 1" {
    const words = [_][]const u8{ "flower", "flow", "flight" };
    var result = try longest_prefix(std.testing.allocator, &words);

    if (result) |actual| {
        defer std.testing.allocator.destroy(actual.ptr);
        try expectEqualStrings("fl", actual);
    } else {
        @panic("Common prefix `fl` should be found");
    }
}

test "longest prefix example 2" {
    const words = [_][]const u8{ "dog", "racecar", "car" };
    var result = try longest_prefix(std.testing.allocator, &words);
    const expected: @TypeOf(result) = null;
    try expectEqual(expected, result);
}
