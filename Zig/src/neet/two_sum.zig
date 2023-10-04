const std = @import("std");
const Allocator = std.mem.Allocator;
const AutoHashMap = std.AutoHashMap;
const expect = std.testing.expect;
const expectEqual = std.testing.expectEqual;

/// Indices of values that sum to the target
pub const ResTwoSum = struct { i: usize, j: usize };

/// Find the indices of two numbers that sum to `target`
pub fn two_sum(comptime N: type, allocator: Allocator, target: N, haystack: []const N) !?ResTwoSum {
    // Numbers only
    comptime if (@typeInfo(N) != .Int and @typeInfo(N) != .ComptimeInt) {
        @compileError("N must be an int of any precision");
    };

    // Map of required number => index of num that sums to target
    // For example, if the target is 42 with a haystack consisting of
    // [14, 28] among others, the number 14 will create an entry for 28
    // in the map where the value is in the index for 14
    var sums = AutoHashMap(N, usize).init(allocator);
    try sums.ensureTotalCapacity(@intCast(u32, haystack.len));
    defer sums.deinit();

    for (haystack, 0..) |num, i| {
        // Complement of num exists; return indices
        if (sums.get(num)) |j| {
            return ResTwoSum{ .i = i, .j = j };
        }

        var complement: N = undefined;
        // Skip if N is unsigned and num > target
        if (@subWithOverflow(N, target, num, &complement)) {
            continue;
        }

        sums.putAssumeCapacity(complement, i);
    }

    return null;
}

test "two sum found" {
    const haystack = [_]u8{ 100, 9, 4, 7, 6, 14, 11, 12, 19, 32, 3, 28 };
    const target: u8 = 42;
    const res = try two_sum(u8, std.testing.allocator, target, &haystack);

    if (res) |found| {
        try expectEqual(ResTwoSum{ .i = 11, .j = 5 }, found);
        try expectEqual(target, haystack[found.i] + haystack[found.j]);
    } else {
        @panic("Target should be found");
    }
}

test "two sum not found" {
    const haystack = [_]u8{ 28, 42 };
    const target: u8 = 100;
    const res = try two_sum(u8, std.testing.allocator, target, &haystack);

    try expect(res == null);
}

test "two sum empty" {
    const haystack = [0]u8{};
    const target: u8 = 24;
    const res = try two_sum(u8, std.testing.allocator, target, &haystack);

    try expect(res == null);
}

test "two sum duplicates" {
    const haystack = [_]u8{ 24, 42, 24 };
    const target: u8 = 48;
    const res = try two_sum(u8, std.testing.allocator, target, &haystack);

    if (res) |found| {
        try expectEqual(ResTwoSum{ .i = 2, .j = 0 }, found);
        try expectEqual(target, haystack[found.i] + haystack[found.j]);
    } else {
        @panic("Target should be found");
    }
}
