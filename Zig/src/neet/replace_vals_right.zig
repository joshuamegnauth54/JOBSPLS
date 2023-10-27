const std = @import("std");
const Allocator = std.mem.Allocator;
const expectEqual = std.testing.expectEqual;
const expect = std.testing.expect;

/// Copy `nums` with each value replaced with that of the maximum value to its right.
///
/// Caller owns the memory if the length isn't zero.
pub fn replace_values_right(comptime T: type, allocator: Allocator, nums: []const T) ![]T {
    // T may be any signed int
    comptime switch (@typeInfo(T)) {
        .Int => |int| {
            if (int.signedness == .unsigned) {
                @compileError("T must be a signed integer");
            }
        },
        .ComptimeInt => {},
        else => @compileError("T must be a signed integer"),
    };

    // Edge cases
    if (nums.len == 0) {
        return &[0]T{};
    }
    // This may seem wasteful, but it's easier for the caller because they can
    // free the owned slice if len == 0
    if (nums.len == 1) {
        var single = try allocator.alloc(T, 1);
        single[0] = -1;
        return single;
    }

    // Owned slice of T set to -1
    var replaced = try allocator.alloc(T, nums.len);
    std.mem.set(T, replaced, -1);

    // Current maximum w.r.t. `num`
    var current = nums[nums.len - 1];
    // Index of `nums`
    var num = @intCast(isize, nums.len - 1);
    // Index of `replaced`
    var rep = @intCast(isize, nums.len - 2);
    while (num >= 0 and rep >= 0) {
        current = @max(current, nums[@intCast(usize, num)]);
        replaced[@intCast(usize, rep)] = current;

        num -= 1;
        rep -= 1;
    }

    return replaced;
}

test "replace values right example 1" {
    const values = [_]i8{ 17, 18, 5, 4, 6, 1 };
    const out = try replace_values_right(i8, std.testing.allocator, &values);
    defer std.testing.allocator.destroy(out.ptr);
    const expected = [_]i8{ 18, 6, 6, 6, 1, -1 };

    var i: usize = 0;
    while (i < out.len) : (i += 1) {
        try expectEqual(expected[i], out[i]);
    }
}

test "replace values right example 2" {
    const values = [_]i16{400};
    const out = try replace_values_right(i16, std.testing.allocator, &values);
    defer std.testing.allocator.destroy(out.ptr);
    const expected = [1]i16{-1};

    try expect(std.mem.eql(i16, &expected, out));
}
