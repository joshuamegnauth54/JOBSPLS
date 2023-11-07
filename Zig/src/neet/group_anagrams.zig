const std = @import("std");
const Allocator = std.mem.Allocator;
const StringHashMap = std.StringHashMap;
const ArrayList = std.ArrayList;
const expectEqual = std.testing.expectEqual;
const expectEqualSlices = std.testing.expectEqualSlices;

const sort_lowercase_string = @import("anagram.zig").sort_lowercase_string;

/// Group words in anagrams.
/// WARNING: `words` must live as long as the return value.
/// Ownership of the strings isn't transferred to the function because this is just leetcode.
pub fn group_anagrams(allocator: Allocator, words: []const []const u8) ![]ArrayList([]const u8) {
    // Key = hash of sorted, lowercased string
    // Value = vector of original strings
    var groups = StringHashMap(ArrayList([]const u8)).init(allocator);
    defer groups.deinit();

    // Sort and transform to lowercase
    // Anagrams will have the same hash
    for (words) |word| {
        const word_sorted = try sort_lowercase_string(allocator, word);

        // The new entry takes ownership of the FIRST word_sorted passed to getOrPut [...]
        var entry = try groups.getOrPut(word_sorted);
        if (!entry.found_existing) {
            entry.value_ptr.* = ArrayList([]const u8).init(allocator);
        } else {
            // [...] so, FOR EXISTING ENTRIES only I must deallocate word_sorted
            allocator.destroy(word_sorted.ptr);
        }
        try entry.value_ptr.*.append(word);
    }

    var groups_out = try allocator.alloc(ArrayList([]const u8), groups.count());
    var values = groups.valueIterator();
    var i: usize = 0;
    while (values.next()) |vec| {
        groups_out[i] = vec.*;
        i += 1;
    }

    // Deallocate all keys because they were allocated by sort_lowercase_string
    var keys = groups.keyIterator();
    while (keys.next()) |key| {
        allocator.destroy(key.ptr);
    }

    return groups_out;
}

fn group_anagram_deinit(allocator: Allocator, groups: []ArrayList([]const u8)) void {
    for (groups) |vec| {
        vec.deinit();
    }

    if (groups.len > 0) {
        allocator.destroy(groups.ptr);
    }
}

fn group_anagram_print(groups: []ArrayList([]const u8)) void {
    for (groups) |*words| {
        for (words.*.items) |word| {
            std.debug.print("{s} ", .{word});
        }

        std.debug.print("\n\n", .{});
    }
}

test "group anagrams correct groups" {
    const words = [_][]const u8{ "tacos", "star", "angle", "angel", "coast", "asleep", "introduces", "please", "arts", "space", "cats", "dog", "god", "rosiest", "resort", "stories" };

    const groups = try group_anagrams(std.testing.allocator, &words);
    defer group_anagram_deinit(std.testing.allocator, groups);

    // FIXME: Zig format mangles this code...
    const expected = [10][]const []const u8{ &[2][]const u8{ "angle", "angel" }, &[1][]const u8{"introduces"}, &[1][]const u8{"resort"}, &[2][]const u8{ "asleep", "please" }, &[2][]const u8{ "rosiest", "stories" }, &[2][]const u8{ "tacos", "coast" }, &[1][]const u8{"cats"}, &[2][]const u8{ "star", "arts" }, &[2][]const u8{ "dog", "god" }, &[1][]const u8{"space"} };

    try expectEqual(expected.len, groups.len);
    group_anagram_print(groups);

    var i: usize = 0;
    while (i < expected.len) : (i += 1) {
        try expectEqualSlices([]const u8, expected[i], groups[i].items);
    }
}

test "group anagrams empty" {
    const empty = [0][]const u8{};
    const groups = try group_anagrams(std.testing.allocator, &empty);

    try expectEqual(groups.len, 0);
    group_anagram_deinit(std.testing.allocator, groups);
}
