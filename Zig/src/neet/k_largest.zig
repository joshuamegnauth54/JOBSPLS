const std = @import("std");
const Allocator = std.mem.Allocator;
const PriorityQueue = std.PriorityQueue;
const Order = std.math.Order;
const expectEqual = std.testing.expectEqual;

pub fn k_largest(comptime T: type, allocator: Allocator, haystack: []const T, k: usize, comptime compfunc: ?fn (void, T, T) Order) !?T {
    const compfunc_def = comptime switch (@typeInfo(T)) {
        .Int, .ComptimeInt, .Float, .ComptimeFloat => opcomp: {
            if (compfunc) |f| {
                break :opcomp f;
            } else {
                break :opcomp int_cmp(T);
            }
        },
        else => needcomp: {
            if (compfunc) |f| {
                break :needcomp f;
            } else {
                @compileError("Types other than ints or floats need a compfunc\n");
            }
        },
    };

    // Can't return the kth largest if k > len
    if (k >= haystack.len) {
        return null;
    }

    // Logic here is to shunt all of the items into a priority queue which is ordered
    // Next, just pop the largest k values till I reach the required item
    var queue = PriorityQueue(T, void, compfunc_def).init(allocator, {});
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

    // Pop the kth if it exists
    return queue.removeOrNull();
}

// Wrapper to compare two integers of the same type
fn int_cmp(comptime T: type) fn (void, T, T) Order {
    return struct {
        fn inner(_: void, a: T, b: T) Order {
            return std.math.order(a, b);
        }
    }.inner;
}

test "kth value exists" {
    const haystack = [_]u8{ 28, 42, 24, 14, 64, 7 };
    const res = try k_largest(u8, std.testing.allocator, &haystack, 3, null);
    if (res) |target| {
        try expectEqual(target, 28);
    } else {
        @panic("The kth value exists and should be found");
    }
}

test "kth > len short circuits" {
    const haystack = [0]u8{};
    const res = try k_largest(u8, std.testing.allocator, &haystack, 10, null);
    try expectEqual(res, null);
}
