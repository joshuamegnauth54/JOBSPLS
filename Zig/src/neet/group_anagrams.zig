const std = @import("std");
const Allocator = std.mem.Allocator;
const StringHashMap = std.StringHashMap;
const ArrayList = std.ArrayList;
const expectEqual = std.testing.expectEqual;

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

//FIXME:make test suck less
test "group anagrams correct groups" {
    const words = [_][]const u8{ "tacos", "star", "angle", "angel", "coast", "asleep", "introduces", "please", "arts", "space", "cats", "dog", "god", "rosiest", "resort", "stories" };

    const groups = try group_anagrams(std.testing.allocator, &words);

    for (groups) |vec| {
        // std.debug.print("Anagram group: {}\n", .{vec});
        vec.deinit();
    }

    if (groups.len > 0) {
        std.testing.allocator.destroy(groups.ptr);
    }
}

test "group anagrams empty" {
    const empty = [0][]const u8{};
    const groups = try group_anagrams(std.testing.allocator, &empty);

    try expectEqual(groups.len, 0);
    if (groups.len > 0) {
        std.testing.allocator.destroy(groups.ptr);
    }
}
