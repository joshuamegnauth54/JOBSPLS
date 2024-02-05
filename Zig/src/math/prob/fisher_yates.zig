const std = @import("std");
const rand = std.rand;

const Allocator = std.mem.Allocator;
const swap = std.mem.swap;

/// Shuffle slice in place with Fisher-Yates/Knuth.
pub fn shuffle_in_place(comptime T: type, slice: []T, seed: u64) void {
    var prng = rand.DefaultPrng.init(seed);
    const random = prng.random();

    var i: usize = undefined;
    if (@subWithOverflow(usize, slice.len, 1, &i)) {
        // Empty slice. Nothing to shuffle.
        i = 0;
    }

    // https://en.wikipedia.org/wiki/Fisher%E2%80%93Yates_shuffle#The_modern_algorithm
    while (i > 0) {
        const j = random.uintAtMost(usize, i);
        swap(T, &slice[i], &slice[j]);

        i -= 1;
    }
}

pub fn shuffle_copy(
    comptime T: type,
    allocator: Allocator,
    slice: []T,
    seed: u64,
) ![]T {
    // Copy slice to new memory to avoid mutating the original
    var shuffled = try allocator.alloc(T, slice.len);
    std.mem.copy(T, shuffled, slice);

    shuffle_in_place(T, shuffled, seed);

    return shuffled;
}
