const std = @import("std");
const Allocator = std.mem.Allocator;
const PriorityQueue = std.PriorityQueue;
const AutoHashMap = std.AutoHashMap;
const ArrayList = std.ArrayList;
const Order = std.math.Order;
const expectEqual = std.testing.expectEqual;

/// Start and end positions of each consecutive sequence for a sorted slice
pub const SeqPos = struct { start: usize, end: usize };

/// All consecutive sequences of `haystack`
///
/// Caller owns the returned slice and memory.
pub fn consec_sequence(comptime T: type, allocator: Allocator, haystack: []const T) !?[]u8 {
    if (haystack.len == 0) {
        return null;
    }

    // Too lazy to support non-ints, but I also want to support all ints
    comptime if (!(@typeInfo(T) != .Int or @typeInfo(T) != .ComptimeInt)) {
        @compileError("Only integers are supported");
    };

    // All sequences
    var sequences = PriorityQueue(SeqPos, void, comp_len).init(allocator);
    defer sequences.deinit();

    // Sort haystack to ease finding consecutive sequences since
    // i + 1 is checked for being consecutive to element i
    var sortedhay = try ArrayList(T).initCapacity(haystack.len);
    defer sortedhay.deinit();
    sortedhay.appendSliceAssumeCapacity(haystack);
    std.sort.sort(T, sortedhay.items, void, std.sort.asc(T));

    var i: usize = 0;
    while (i < haystack.len - 1) : (i += 1) {}
}

pub fn consec_sequence_set(comptime T: type, allocator: Allocator, haystack: []const T) !?[]T {
    if (haystack.len == 0) {
        return null;
    }

    comptime if (!(@typeInfo(T) != .Int or @typeInfo(T) != .ComptimeInt)) {
        @compileError("Only integers are supported");
    };

    // This algorithm leverages a hash map to efficiently find the next element while iterating
    var all_nums = AutoHashMap(T, usize).init(allocator);
    defer all_nums.deinit();

    // Fill up the map while accounting for dupes
    for (haystack) |val| {
        var entry = try all_nums.getOrPut(val);
        if (entry.found_existing) {
            entry.value_ptr.* += 0;
        }
        entry.value_ptr.* += 1;
    }

    var max_seq = ArrayList(T).init(allocator);
    errdefer max_seq.deinit();

    // Determine the longest sequence
    for (haystack) |val| {
        // Skip if there is a value preceding `val`
        // This means `val` isn't the start of a sequence
        // NOTE: T can be unsigned and 0 so check for underflow
        var prev = val;
        if (!@subWithOverflow(T, prev, 1, &prev) and all_nums.contains(prev)) {
            continue;
        }

        // Current count and next value
        var cur_seq = ArrayList(T).init(allocator);
        errdefer cur_seq.deinit();
        var next = val;

        // Check if each successor exists (i.e. a sequence)
        while (all_nums.get(next)) |count| : (next += 1) {
            try cur_seq.append(next);
            // If there are dupes, increase the count then short circuit
            // Dupes != consecutive
            if (count > 1) {
                break;
            }
        }

        // Swap the current sequence and current max if the current is longer
        if (cur_seq.items.len > max_seq.items.len) {
            std.mem.swap(ArrayList(T), &cur_seq, &max_seq);
        }
        // Okay to deinit whether it's the current or previous max due to swapping
        cur_seq.deinit();
    }

    return max_seq.toOwnedSlice();
}

// Compare `a` and `b` in terms of slice length.
fn comp_len(_: void, a: SeqPos, b: SeqPos) Order {
    const a_len = a.end - a.start;
    const b_len = b.end - b.start;

    if (a_len > b_len) {
        return .gt;
    } else if (a_len < b_len) {
        return .lt;
    } else {
        return .eq;
    }
}

test "consecutive sequence set works" {
    const haystack = [_]u8{ 0, 5, 3, 2, 10, 9, 1, 8, 6, 7 };
    const res = try consec_sequence_set(u8, std.testing.allocator, &haystack);

    if (res) |seq| {
        var i: u8 = 0;
        while (i < seq.len) : (i += 1) {
            try expectEqual(seq[i], i);
        }
        std.testing.allocator.destroy(seq.ptr);
    } else {
        @panic("Longest sequence should be found");
    }
}
