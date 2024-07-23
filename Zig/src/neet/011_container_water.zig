const std = @import("std");
const expectEqual = std.testing.expectEqual;

fn most_water(heights: []const u32) Container {
    const right: usize = heights.len - 1;
    var sum: u64 = 0;

    var container = Container{
        .left = 0,
        .right = 0,
        .sum = 0,
    };

    for (heights, 0..) |left_height, left| {
        const height = @min(left_height, heights[right]);

        // height = length; (right - left) = width
        sum = height * (right - left);

        // Cache current largest sum
        if (sum >= container.sum) {
            container.left = left;
            container.right = right;
            container.sum = sum;
        }
    }

    return container;
}

const Container = struct {
    left: usize,
    right: usize,
    sum: u64,
};

test "example 1" {
    const heights = [_]u32{ 1, 8, 6, 2, 5, 4, 8, 3, 7 };
    const expected = Container{
        .left = 1,
        .right = 8,
        .sum = 49,
    };
    const actual = most_water(&heights);

    try expectEqual(expected, actual);
}

test "example 2" {
    const heights = [_]u32{ 1, 1 };
    const expected = Container{
        .left = 0,
        .right = 1,
        .sum = 1,
    };
    const actual = most_water(&heights);

    try expectEqual(expected, actual);
}
