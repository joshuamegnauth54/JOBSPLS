const std = @import("std");
const AutoHashMap = std.AutoHashMap;
const Allocator = std.mem.Allocator;
const expect = std.testing.expect;

// Fill a map with counts of each character.
fn char_counts(map: *AutoHashMap(u8, usize), s: []const u8) !void {
    for (s) |ch| {
        var entry = try map.getOrPutValue(ch, 0);
        entry.value_ptr.* += 1;
    }
}

/// Check if `s1` and `s2` are anagrams.
///
/// WARNING: This isn't fully robust.
/// * Only supports ASCII. I'm not sure how anagrams work in other languages.
/// * Technically any ASCII strings work as anagrams because I don't check for symbols.
/// * Should empty strings cause `anagram` to return true? IDK
pub fn anagram(allocator: Allocator, s1: []const u8, s2: []const u8) !bool {
    var s1_map = AutoHashMap(u8, usize).init(allocator);
    try s1_map.ensureTotalCapacity(@intCast(u32, s1.len));
    var s2_map = AutoHashMap(u8, usize).init(allocator);
    try s2_map.ensureTotalCapacity(@intCast(u32, s2.len));

    defer s1_map.deinit();
    defer s2_map.deinit();

    try char_counts(&s1_map, s1);
    try char_counts(&s2_map, s2);

    // Both maps should have the same amount of letters (keys)
    if (s1_map.count() != s2_map.count()) {
        return false;
    }

    // The two maps should have equal counts if the strings are anagrams
    var iter = s1_map.iterator();
    while (iter.next()) |s1_entry| {
        if (s2_map.get(s1_entry.key_ptr.*)) |s2_count| {
            if (!(s2_count == s1_entry.value_ptr.*)) {
                return false;
            }
        } else {
            return false;
        }
    }

    return true;
}

test "anagram success" {
    const success = try anagram(std.testing.allocator, "level", "lleev");
    try expect(success);
}

test "anagram failure" {
    const result = try anagram(std.testing.allocator, "cat", "dog");
    try expect(!result);
}
