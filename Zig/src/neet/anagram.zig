const std = @import("std");
const AutoHashMap = std.AutoHashMap;
const ArrayList = std.ArrayList;
const Allocator = std.mem.Allocator;
const expect = std.testing.expect;
const CityHash64 = std.hash.CityHash64;

// Fill a map with counts of each character.
fn char_counts(map: *AutoHashMap(u8, usize), s: []const u8) void {
    for (s) |ch| {
        // NOTE: Won't panic because the capacity is ensured earlier
        var entry = map.getOrPutAssumeCapacity(ch);
        if (!entry.found_existing) {
            entry.value_ptr.* = 0;
        }
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

    char_counts(&s1_map, s1);
    char_counts(&s2_map, s2);

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

fn sort_lowercase_string(allocator: Allocator, s: []const u8) ![]const u8 {
    var sorted = try std.ascii.allocLowerString(allocator, s);
    // var sorted = try ArrayList(u8).initCapacity(allocator, s.len);
    // sorted.appendSliceAssumeCapacity(lowercase);
    std.sort.sort(u8, sorted, {}, std.sort.desc(u8));
    return sorted;
}

pub fn anagram_hash(allocator: Allocator, s1: []const u8, s2: []const u8) !bool {
    if (s1.len != s2.len) {
        return false;
    }

    // Sort both strings so they return the same  hash
    const s1_sorted = try sort_lowercase_string(allocator, s1);
    defer allocator.destroy(s1_sorted.ptr);
    const s2_sorted = try sort_lowercase_string(allocator, s2);
    defer allocator.destroy(s2_sorted.ptr);

    return CityHash64.hash(s1_sorted) == CityHash64.hash(s2_sorted);
}

test "anagram success" {
    const success = try anagram(std.testing.allocator, "level", "lleev");
    try expect(success);
}

test "anagram failure" {
    const result = try anagram(std.testing.allocator, "cat", "dog");
    try expect(!result);
}

test "anagram_hash success" {
    const success = try anagram_hash(std.testing.allocator, "level", "lleev");
    try expect(success);
}

test "anagram_hash failure" {
    const result = try anagram_hash(std.testing.allocator, "cat", "dog");
    try expect(!result);
}
