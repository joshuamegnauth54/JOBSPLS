const std = @import("std");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const expectEqualDeep = std.testing.expectEqualDeep;

fn max_sub_array(comptime I: type, haystack: []const I) MaxSubArray {
    comptime switch (@typeInfo(I)) {
        .Int, .ComptimeInt => {},
        else => @compileError("Only valid for integers"),
    };

    if (haystack.len == 0) {
        return MaxSubArray{
            .left = 0,
            .right = 0,
            .sum = 0,
        };
    }

    var left: usize = 0;
    var right: usize = 0;
    var sum: i64 = 0;
    var max_array = MaxSubArray{
        .left = left,
        .right = right,
        .sum = sum,
    };

    for (haystack, 0..) |val, i| {
        sum += val;
        if (sum > max_array.sum) {
            max_array.left = left;
            max_array.right = i;
            max_array.sum = sum;
        }

        // Reset
        if (sum <= 0) {
            left = i + 1;
            right = i + 1;
            sum = 0;
        }
    }

    return max_array;
}

const MaxSubArray = struct {
    left: usize,
    right: usize,
    sum: i64,
};

test "empty array" {
    const haystack = [0]i8{};
    const actual = max_sub_array(i8, &haystack);
    const expected = MaxSubArray{
        .left = 0,
        .right = 0,
        .sum = 0,
    };

    try expectEqualDeep(expected, actual);
}

test "leetcode example 1 basic array" {
    const haystack = [_]i8{ -2, 1, -3, 4, -1, 2, 1, -5, 4 };
    const actual = max_sub_array(i8, &haystack);
    const expected = MaxSubArray{
        .left = 3,
        .right = 6,
        .sum = 6,
    };

    try expectEqualDeep(expected, actual);
}

test "leetcode example 2 single element" {
    const haystack = [1]i8{24};
    const actual = max_sub_array(i8, &haystack);
    const expected = MaxSubArray{
        .left = 0,
        .right = 0,
        .sum = 24,
    };

    try expectEqualDeep(expected, actual);
}

test "leetcode example 3 full slice answer" {
    const haystack = [_]i8{ 5, 4, -1, 7, 8 };
    const actual = max_sub_array(i8, &haystack);
    const expected = MaxSubArray{
        .left = 0,
        .right = haystack.len - 1,
        .sum = 23,
    };

    try expectEqualDeep(&expected, &actual);
}
