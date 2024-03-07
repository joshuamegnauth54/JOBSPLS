const std = @import("std");
const Allocator = std.mem.Allocator;

/// Sort `nums` by even/odd parity.
///
/// Caller owns allocated memory which is always the size of `nums`.
///
/// From:
/// https://leetcode.com/problems/sort-array-by-parity
pub fn sort_array_parity(
    comptime T: type,
    allocator: Allocator,
    nums: []const T,
) ![]T {
    comptime switch (@typeInfo(T)) {
        .ComptimeInt => {},
        .Int => {},
        .ComptimeFloat => {},
        .Float => {},
        else => @compileError("`sort_array_parity` requires numbers"),
    };

    var sorted = try allocator.alloc(T, nums.len);
    errdefer sorted.deinit();

    // Even is pushed in front of the array
    var front: usize = 0;
    // Odds are placed from the back to the front
    var end: usize = nums.len - 1;

    for (nums) |num| {
        if (num % 2 == 0) {
            sorted[front] = num;
            front += 1;
        } else {
            sorted[end] = num;
            const checked = @subWithOverflow(end, 1);
            if (checked[1] != 0) {
                break;
            }
            end = checked[0];
        }
    }

    return sorted;
}

fn parity_test(comptime T: type, actual: []const T) !void {
    var odd = false;

    for (actual) |num| {
        // State: On even but switch to odd
        if (num % 2 != 0 and !odd) {
            odd = true;
        }
        // State: On odd but unexpected even
        else if (num % 2 == 0 and odd) {
            return ParityTestError.UnexpectedEven;
        }
    }
}

const ParityTestError = error{UnexpectedEven};

test "LeetCode example 1" {
    const input = [_]u8{ 3, 1, 2, 4 };
    const actual = try sort_array_parity(u8, std.testing.allocator, &input);
    defer std.testing.allocator.free(actual);

    try parity_test(u8, actual);
}

test "LeetCode example 2" {
    const input = [_]u8{0};
    const actual = try sort_array_parity(u8, std.testing.allocator, &input);
    defer std.testing.allocator.free(actual);

    try parity_test(u8, actual);
}

test "all odds" {
    const input = [_]u8{ 7, 5, 3, 9 };
    const actual = try sort_array_parity(u8, std.testing.allocator, &input);
    defer std.testing.allocator.free(actual);

    try parity_test(u8, actual);
}

test "all evens" {
    const input = [_]u8{ 4, 6, 8, 10 };
    const actual = try sort_array_parity(u8, std.testing.allocator, &input);
    defer std.testing.allocator.free(actual);

    try parity_test(u8, actual);
}
