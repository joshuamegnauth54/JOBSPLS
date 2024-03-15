const std = @import("std");
const Allocator = std.mem.Allocator;
const expectError = std.testing.expectError;
const expectEqualSlices = std.testing.expectEqualSlices;

pub fn sort_array_parity_2(
    comptime T: type,
    allocator: Allocator,
    nums: []const T,
) ![]T {
    comptime switch (@typeInfo(T)) {
        .Int, .ComptimeInt => {},
        else => @compileError("`sort_array_parity_2` only supports integers"),
    };

    if (nums.len < 2) {
        return ArrayParityError.InputTooSmall;
    }

    var sorted = try allocator.alloc(T, nums.len);
    errdefer allocator.free(sorted);

    // Next indices
    var even: usize = 0;
    var odd: usize = 1;

    for (nums) |num| {
        if (num % 2 == 0) {
            // Too many evens
            if (even >= nums.len) {
                return ArrayParityError.NotEnoughOdds;
            }

            sorted[even] = num;
            even += 2;
        } else {
            // Too many odds
            if (odd >= nums.len) {
                return ArrayParityError.NotEnoughEvens;
            }

            sorted[odd] = num;
            odd += 2;
        }
    }

    return sorted;
}

const ArrayParityError = error{
    InputTooSmall,
    NotEnoughOdds,
    NotEnoughEvens,
};

test "LeetCode example 1" {
    const input = [_]u8{ 4, 2, 5, 7 };
    const expected = [_]u8{ 4, 5, 2, 7 };

    const actual = try sort_array_parity_2(u8, std.testing.allocator, &input);
    defer std.testing.allocator.free(actual);

    try expectEqualSlices(u8, &expected, actual);
}

test "LeetCode example 2" {
    const input = [_]u8{ 2, 3 };
    const expected = [_]u8{ 2, 3 };

    const actual = try sort_array_parity_2(u8, std.testing.allocator, &input);
    defer std.testing.allocator.free(actual);

    try expectEqualSlices(u8, &expected, actual);
}

test "unbalanced parity (even) fails" {
    const input = [_]u8{ 4, 6, 8, 10 };
    const expected = ArrayParityError.NotEnoughOdds;

    const actual = sort_array_parity_2(u8, std.testing.allocator, &input);
    errdefer std.testing.allocator.free(actual catch unreachable);

    try expectError(expected, actual);
}

test "unbalanced parity (odd) fails" {
    const input = [_]u8{ 3, 5, 7, 9 };
    const expected = ArrayParityError.NotEnoughEvens;

    const actual = sort_array_parity_2(u8, std.testing.allocator, &input);
    errdefer std.testing.allocator.free(actual catch unreachable);

    try expectError(expected, actual);
}
