const std = @import("std");
const expectEqualDeep = std.testing.expectEqualDeep;

fn buy_sell_stock(prices: []const u32) MaxProfit {
    if (prices.len < 2) {
        return MaxProfit{
            .buy = 0,
            .sell = 0,
            .roi = 0,
        };
    }

    var buy: usize = 0;
    var sell: usize = 1;
    var roi = @as(isize, prices[sell]) - prices[buy];
    var profit = MaxProfit{
        .buy = buy,
        .sell = sell,
        .roi = roi,
    };

    for (prices[1..], 1..) |price, i| {
        if (price < prices[buy]) {
            roi = @as(isize, prices[sell]) - prices[buy];
            if (roi > profit.roi) {
                profit.buy = buy;
                profit.sell = sell;
                profit.roi = roi;
            }

            // Can't sell before buying
            sell = i;
            buy = i;
        } else if (price > prices[sell]) {
            sell = i;
        }
    }

    roi = @as(isize, prices[sell]) - prices[buy];
    if (roi > profit.roi) {
        profit.buy = buy;
        profit.sell = sell;
        profit.roi = roi;
    }

    return profit;
}

const MaxProfit = struct {
    buy: usize,
    sell: usize,
    roi: i64,
};

test "leetcode example 1" {
    const actual = buy_sell_stock(&[_]u32{ 7, 1, 5, 3, 6, 4 });
    const expected = MaxProfit{
        .buy = 1,
        .sell = 4,
        .roi = 5,
    };
    try expectEqualDeep(expected, actual);
}

test "leetcode example 2" {
    const actual = buy_sell_stock(&[_]u32{ 7, 6, 4, 3, 1 });
    const expected = MaxProfit{
        .buy = 1,
        .sell = 1,
        .roi = 0,
    };
    try expectEqualDeep(expected, actual);
}
