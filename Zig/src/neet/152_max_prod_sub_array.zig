const std = @import("std");
const expectEqualDeep = std.testing.expectEqualDeep;

fn max_prod_sub_array(comptime I: type, haystack: []const I) MaxProdSubArray {
    if (haystack.len == 0) {
        return MaxProdSubArray{
            .left = 0,
            .right = 0,
            .prod = 0,
        };
    }

    var left: usize = 0;
    var right: usize = 0;
    var prod: i64 = haystack[0];
    var max = MaxProdSubArray{
        .left = left,
        .right = right,
        .prod = prod,
    };

    for (haystack[1..], 1..) |val, i| {
        prod *= val;
        right = i;

        if (prod < val) {
            left = i;
            prod = val;
        }
        if (prod > max.prod) {
            max.left = left;
            max.right = right;
            max.prod = prod;
        }
    }

    return max;
}

const MaxProdSubArray = struct {
    left: usize,
    right: usize,
    prod: i64,
};

test "leetcode example 1" {
    const actual = max_prod_sub_array(i32, &[_]i32{ 2, 3, -2, 4 });
    const expected = MaxProdSubArray{
        .left = 0,
        .right = 1,
        .prod = 6,
    };

    try expectEqualDeep(expected, actual);
}

test "leetcode example 2" {
    const actual = max_prod_sub_array(i32, &[_]i32{ -2, 0, -1 });
    const expected = MaxProdSubArray{
        .left = 0,
        .right = 1,
        .prod = 0,
    };

    try expectEqualDeep(expected, actual);
}
