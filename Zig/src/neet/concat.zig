const std = @import("std");
const Allocator = std.mem.Allocator;
const expect = std.testing.expectEqual;

const ConcatError = error{DestTooSmall};

/// Concat `src` into `dest` `amount` times.
pub fn repeat_slice(comptime T: type, src: []const T, dest: []T, amount: usize) ConcatError!void {
    if (dest.len < src.len * amount) {
        return ConcatError.DestTooSmall;
    }

    if (amount == 0) {
        return;
    }

    var offset: usize = 0;
    while (offset < amount) : (offset += 1) {
        var slice = dest[offset * src.len .. dest.len];
        // TODO: Update to nicer memcpy in 0.12
        const len = @sizeOf(T) * src.len;
        @memcpy(slice.ptr, src.ptr, len);
    }
}

/// Concat `src` into an allocated array `amount` times.
pub fn repeat_slice_auto(comptime T: type, allocator: Allocator, src: []const T, amount: usize) !*[]T {
    var dest = try allocator.alloc(T, src.len * amount);
    errdefer allocator.destroy(&dest);
    try repeat_slice(T, src, dest, amount);

    return &dest;
}

test "repeat slice three times" {
    var allocator = std.testing.allocator;
    const slice = [_]u8{ 14, 28, 42 };
    const repeated = try repeat_slice_auto(u8, allocator, &slice, 3);

    for (repeated.*, 0..) |value, i| {
        try expectEqual(value, slice[i % 3]);
    }

    allocator.destroy(repeated.ptr);
}
