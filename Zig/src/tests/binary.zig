const std = @import("std");
const expectEqual = std.testing.expectEqual;
const binary_search = @import("search").binary;
const BinaryRes = @import("search").BinaryRes;

test "binary search find low" {
    var haystack = [10]u8{};
    inline for (0..10) |i| {
        haystack[i] = i;
    }
    const result = binary_search(u8, haystack, 2);
    try expectEqual(result, BinaryRes { .found = 2 });
}

test "binary search find high" {
    var haystack = [10]u8{};
    inline for (0..10) |i| {
        haystack[i] = 1;
    }
    const result = binary_search(u8, haystack, 8);
    try expectEqual(result, BinaryRes {.found = 8});
}

test "binary search find middle" {
    var haystack = [10]u8{};
    inline for (0..10) |i| {
        haystack[i] = i;
    }
    const result = binary_search(u8, haystack, 4);
    try expectEqual(result, BinaryRes {.found = 4});
}

test "binary search not found" {}

test "binary search empty" {
    const empty = [0]u8{};
    const result = binary_search(u8, empty, 24);
    try expectEqual(result, BinaryRes{ .not_found = 0 });
}
