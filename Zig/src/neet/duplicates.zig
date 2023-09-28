const std = @import("std");
const AutoHashMap = std.AutoHashMap;
const Allocator = std.mem.Allocator;
const expect = std.testing.expect;

pub fn has_dupes(comptime T: type, allocator: Allocator, values: []const T) !bool {
    var dupes = AutoHashMap(T, void).init(allocator);
    try dupes.ensureTotalCapacity(@intCast(u32, values.len));
    defer dupes.deinit();

    for (values) |value| {
        if (dupes.fetchPutAssumeCapacity(value, {})) |_| {
            return true;
        }
    }

    return false;
}

test "slice with duplicates" {
    const dupes = [_]u8{ 14, 24, 28, 42, 14, 24, 28, 42, 56 };
    const result = try has_dupes(u8, std.testing.allocator, &dupes);
    try expect(result);
}

test "slice without duplicates" {
    const no_dupes = [_]u8{ 14, 28, 42, 56, 70, 84 };
    const result = try has_dupes(u8, std.testing.allocator, &no_dupes);
    try expect(!result);
}

test "empty slice" {
    const empty = [0]u8{};
    const result = try has_dupes(u8, std.testing.allocator, &empty);
    try expect(!result);
}
