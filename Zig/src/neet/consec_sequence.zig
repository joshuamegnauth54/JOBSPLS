const std = @import("std");
const Allocator = std.mem.Allocator;
const PriorityQueue = std.PriorityQueue;
const AutoHashMap = std.AutoHashMap;
const ArrayList = std.ArrayList;
const Order = std.math.Order;
const expectEqual = std.testing.expectEqual;

/// Start and end positions of each consecutive sequence for a sorted slice
/// As these are indices, 0 is the lowest value and `end` is exclusive
pub const SeqPos = struct { start: usize, end: usize };

/// All consecutive sequences of `haystack`
///
/// Caller owns the returned slice and memory.
pub fn consec_sequence_heap(comptime T: type, allocator: Allocator, haystack: []const T) !?[]SeqPos {
    if (haystack.len == 0) {
        return null;
    }

    // Too lazy to support non-ints, but I also want to support all ints
    comptime if (@typeInfo(T) != .Int and @typeInfo(T) != .ComptimeInt) {
        @compileError("Only integers are supported");
    };

    // All sequences
    var sequences = PriorityQueue(SeqPos, void, comp_len).init(allocator, {});
    defer sequences.deinit();

    // Sort haystack to ease finding consecutive sequences since
    // i + 1 is checked for being consecutive to element i
    var sortedhay = try ArrayList(T).initCapacity(allocator, haystack.len);
    defer sortedhay.deinit();
    sortedhay.appendSliceAssumeCapacity(haystack);
    std.sort.sort(T, sortedhay.items, {}, std.sort.asc(T));

    var i: usize = 0;
    var seq = SeqPos{ .start = i, .end = i };
    while (i < haystack.len - 1) : (i += 1) {
        const current = sortedhay.items[i];
        const expected = current + 1;
        const next = sortedhay.items[i + 1];

        // End of the sequence
        if (next != expected) {
            seq.end = i + 1;
            try sequences.add(seq);
            // Reset sequence to the next index
            seq.start = i + 1;
            seq.end = i + 1;
        }
    } else {
        seq.end = i + 1;
        try sequences.add(seq);
    }

    // Append the elements in order to a vector
    var seq_ordered = try ArrayList(SeqPos).initCapacity(allocator, sequences.count());
    while (sequences.removeOrNull()) |sequence| {
        seq_ordered.appendAssumeCapacity(sequence);
    }
    return seq_ordered.toOwnedSlice();
}

pub fn consec_sequence_set(comptime T: type, allocator: Allocator, haystack: []const T) !?[]T {
    if (haystack.len == 0) {
        return null;
    }

    comptime if (@typeInfo(T) != .Int and @typeInfo(T) != .ComptimeInt) {
        @compileError("Only integers are supported");
    };

    // This algorithm leverages a hash map to efficiently find the next element while iterating
    var all_nums = AutoHashMap(T, usize).init(allocator);
    defer all_nums.deinit();

    // Fill up the map while accounting for dupes
    for (haystack) |val| {
        var entry = try all_nums.getOrPut(val);
        if (!entry.found_existing) {
            entry.value_ptr.* = 0;
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
    const haystack = [_]u8{ 0, 5, 3, 2, 10, 9, 1, 8, 6, 7, 4 };
    const res = try consec_sequence_set(u8, std.testing.allocator, &haystack);

    if (res) |seq| {
        try expectEqual(haystack.len, seq.len);

        var i: u8 = 0;
        while (i < seq.len) : (i += 1) {
            try expectEqual(i, seq[i]);
        }
        std.testing.allocator.destroy(seq.ptr);
    } else {
        @panic("Longest sequence should be found");
    }
}

test "consecutive sequence set with multiple seqs" {
    const haystack = [_]u8{ 50, 60, 5, 3, 2, 16, 1, 4, 0, 15, 14 };
    const res = try consec_sequence_set(u8, std.testing.allocator, &haystack);

    if (res) |seq| {
        defer std.testing.allocator.destroy(seq.ptr);

        try expectEqual(@intCast(@TypeOf(seq.len), 6), seq.len);

        var expected: u8 = 0;
        for (seq) |num| {
            try expectEqual(expected, num);
            expected += 1;
        }
    } else {
        @panic("Longest sequence should be found");
    }
}

test "consecutive sequence set empty" {
    const haystack = [0]u8{};
    const res = try consec_sequence_set(u8, std.testing.allocator, &haystack);
    try expectEqual(res, null);
}

test "consecutive sequence set single item" {
    const target: u8 = 14;
    const haystack = [1]u8{target};
    const res = try consec_sequence_set(u8, std.testing.allocator, &haystack);

    if (res) |seq| {
        defer std.testing.allocator.destroy(seq.ptr);
        try expectEqual(@intCast(@TypeOf(seq.len), 1), seq.len);
        try expectEqual(target, seq[0]);
    } else {
        @panic("Single item sequence should be found");
    }
}

test "consecutive sequence queue works" {
    const haystack = [_]u8{ 0, 5, 3, 2, 10, 9, 1, 8, 6, 7, 4 };
    const res = try consec_sequence_heap(u8, std.testing.allocator, &haystack);

    if (res) |sequences| {
        defer std.testing.allocator.destroy(sequences.ptr);
        try expectEqual(sequences.len, 1);
        const seq = sequences[0];
        const len = seq.end - seq.start;
        try expectEqual(haystack.len, len);
    }
}
