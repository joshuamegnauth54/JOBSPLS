const std = @import("std");
const Allocator = std.mem.Allocator;
const PriorityQueue = std.PriorityQueue;
const Order = std.math.Order;

pub fn k_largest(comptime T: type, allocator: Allocator, haystack: []const T, k: usize, comptime compfunc: ?fn (void, T, T) Order) !T {
    if (k >= haystack.len) {
        return null;
    }

    var queue = PriorityQueue(T, {}, compfunc).init(allocator, void);
    defer queue.deinit();
    try queue.ensureTotalCapacity(haystack.len);
    try queue.addSlice(haystack);

    var i: usize = 0;
    while (i < k) : (i += 1) {
        // Short circuit
        if (queue.removeOrNull() == null) {
            return null;
        }
    }

    return queue.removeOrNull();
}
