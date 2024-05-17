const std = @import("std");
const Allocator = std.mem.Allocator;
const expectEqual = std.testing.expectEqual;

fn LinkedList() type {
    return struct {
        const Self = @This();
        allocator: Allocator,
        head: ?*ListNode(),

        pub fn new(allocator: Allocator) !Self {
            return Self{
                .allocator = allocator,
                .head = null,
            };
        }

        pub fn insert_head(self: *Self, value: u8) !void {
            var next = try self.*.allocator.create(ListNode());
            next.*.value = value;
            next.*.next = null;
            next.*.prev = null;

            if (self.*.head) |head| {
                // Attach the current head to the new node so we don't lose
                // the current data
                next.*.next = head;
            }
            self.*.head = next;
        }

        pub fn insert_tail(self: *Self, value: u8) !void {
            var node = try self.*.allocator.create(ListNode());
            node.*.value = value;
            node.*.next = null;
            node.*.prev = null;

            var maybe_cur = self.*.head;
            while (maybe_cur) |current| {
                if (current.next) |next| {
                    maybe_cur = next;
                } else {

                    // Current is now the tail node.
                    current.*.next = node;
                    node.*.prev = current;
                    break;
                }
            } else {
                self.head = node;
            }
        }

        pub fn insert_head_slice(self: *Self, values: []const u8) !void {
            for (values) |value| {
                try self.insert_head(value);
            }
        }

        pub fn add(self: *const Self, rhs: *const Self) !Self {
            var lhs = self.iterator();
            var rhsi = rhs.iterator();
            var result = try LinkedList().new(self.allocator);
            errdefer result.deinit();
            var overflow: u8 = 0;

            while (lhs.next()) |left| {
                if (rhsi.next()) |right| {
                    var sum = left + right + overflow;
                    // New overflow is whatever spilled over to the next position
                    overflow = @divFloor(sum, 10);
                    sum = sum % 10;

                    try result.insert_head(sum);
                } else {
                    // No more right nodes. Append all of left's values
                    var sum = left + overflow;
                    overflow = @divFloor(sum, 10);
                    sum = sum % 10;

                    try result.insert_head(sum);
                }
            }

            // All of left has been exhausted. Traverse rhs in case lhs ended early.
            while (rhsi.next()) |right| {
                var sum = right + overflow;
                overflow = @divFloor(sum, 10);
                sum = sum % 10;

                try result.insert_head(sum);
            }

            // Overflow may have leftover values
            if (overflow > 0) {
                try result.insert_head(overflow);
            }

            return result;
        }

        pub fn remove(self: *Self, node: *ListNode()) bool {
            var current = self.head;
            while (current != null and current.*.next != node) {
                current = current.*.next;
            }

            if (current) |*cur| {
                const to_delete = cur.*.next;
                cur.*.next = to_delete.*.next;
                self.allocator.destroy(to_delete);
                return true;
            }

            // Not found
            return false;
        }

        pub fn iterator(self: *const Self) Iterator {
            return Iterator{ .node = self.head };
        }

        pub fn deinit(self: *Self) void {
            while (self.*.head) |head| {
                const next = head.next;
                self.allocator.destroy(head);
                self.*.head = next;
            }
        }
    };
}

fn ListNode() type {
    return struct {
        const Self = @This();
        value: u8,
        next: ?*Self,
        prev: ?*Self,
    };
}

const Iterator = struct {
    const Self = @This();
    node: ?*ListNode(),

    fn next(self: *Self) ?u8 {
        if (self.*.node) |node| {
            const value = node.value;
            self.*.node = node.next;
            return value;
        }
        return null;
    }
};

test "sanity check" {
    var list = try LinkedList().new(std.testing.allocator);
    defer list.deinit();

    for (0..10) |i| {
        const j: u8 = @intCast(i);
        try list.insert_head(j);
        try list.insert_tail(j);
    }
}

test "sanity check iterator" {
    var list = try LinkedList().new(std.testing.allocator);
    defer list.deinit();

    const nums = [_]u8{ 8, 7, 6, 5 };
    try list.insert_head_slice(&nums);

    var list_iter = list.iterator();
    var nums_iter = std.mem.reverseIterator(&nums);
    while (list_iter.next()) |actual| {
        const expected = nums_iter.next() orelse unreachable;
        try expectEqual(expected, actual);
    }
}

test "simple add works" {
    var lhs = try LinkedList().new(std.testing.allocator);
    defer lhs.deinit();
    var rhs = try LinkedList().new(std.testing.allocator);
    defer rhs.deinit();

    try lhs.insert_head(3);
    try rhs.insert_head(4);

    var out = try lhs.add(&rhs);
    defer out.deinit();

    const expected: u8 = 7;
    var iter = out.iterator();
    if (iter.next()) |actual| {
        try expectEqual(expected, actual);
    } else {
        std.debug.panic("Expected {} but got no values.", .{expected});
    }

    if (iter.next()) |invalid| {
        std.debug.panic("Unexpected extra value: {}", .{invalid});
    }
}

test "leetcode example 1" {
    var lhs = try LinkedList().new(std.testing.allocator);
    defer lhs.deinit();
    var rhs = try LinkedList().new(std.testing.allocator);
    defer rhs.deinit();

    try lhs.insert_head_slice(&[_]u8{ 3, 4, 2 });
    try rhs.insert_head_slice(&[_]u8{ 4, 6, 5 });

    var out = try lhs.add(&rhs);
    defer out.deinit();

    // 807
    // const expected = [_]u8{ 7, 0, 8 };
    const expected = [_]u8{ 8, 0, 7 };
    var iter = out.iterator();
    for (expected) |num| {
        if (iter.next()) |actual| {
            try expectEqual(num, actual);
        } else {
            std.debug.panic("Expected {} but iterator is exhausted.", .{num});
        }
    }
}

test "leetcode example 2" {
    var lhs = try LinkedList().new(std.testing.allocator);
    defer lhs.deinit();
    var rhs = try LinkedList().new(std.testing.allocator);
    defer rhs.deinit();

    try lhs.insert_head_slice(&[_]u8{ 9, 9, 9, 9, 9, 9, 9 });
    try rhs.insert_head_slice(&[_]u8{ 9, 9, 9, 9 });

    var out = try lhs.add(&rhs);
    defer out.deinit();

    // const expected = [_]u8{ 8, 9, 9, 9, 0, 0, 0, 1 };
    const expected = [_]u8{ 1, 0, 0, 0, 9, 9, 9, 8 };
    var iter = out.iterator();
    for (expected) |num| {
        if (iter.next()) |actual| {
            try expectEqual(num, actual);
        } else {
            std.debug.panic("Expected {} but iterator is exhausted.", .{num});
        }
    }
}

test "leetcode example 3" {
    var lhs = try LinkedList().new(std.testing.allocator);
    defer lhs.deinit();
    var rhs = try LinkedList().new(std.testing.allocator);
    defer rhs.deinit();

    try lhs.insert_head(0);
    try rhs.insert_head(0);

    var out = try lhs.add(&rhs);
    defer out.deinit();

    const expected: u8 = 0;
    var iter = out.iterator();
    if (iter.next()) |actual| {
        try expectEqual(expected, actual);
    } else {
        std.debug.panic("Expected {} but iterator is exhausted.", .{expected});
    }

    if (iter.next()) |invalid| {
        std.debug.panic("Unexpected extra value: {}", .{invalid});
    }
}
