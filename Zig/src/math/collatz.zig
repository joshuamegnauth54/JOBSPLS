const std = @import("std");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;

pub fn collatz(allocator: Allocator, start: u64) !ArrayList(u64) {
    var hailstone = ArrayList(u64).init(allocator);
    errdefer hailstone.deinit();
    var current = start;
    try hailstone.append(current);

    while (current != 1) {
        current = if (current % 2 == 0) current / 2 else current * 3 + 1;
        try hailstone.append(current);
    }

    return hailstone;
}
