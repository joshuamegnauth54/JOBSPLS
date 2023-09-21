const std = @import("std");
const time = std.time;
const rand = std.rand;
const expectEqual = std.testing.expectEqual;

/// Generate `size` random numbers of type `T`.
pub fn random_nums(comptime T: type, comptime size: comptime_int) [size]T {
    // https://nofmal.github.io/zig-with-example/rng/
    const seed = @intCast(u64, time.milliTimestamp());
    var prng = rand.DefaultPrng.init(seed);
    const random = prng.random();

    var numbers: [size]T = undefined;

    switch (@typeInfo(T)) {
        .Int, .ComptimeInt => {
            for (numbers) |*n| {
                n.* = random.int(T);
            }
        },
        .Float, .ComptimeFloat => {
            for (numbers) |*n| {
                n.* = random.float(T);
            }
        },
        else => @compileError("`random_nums` is only valid for ints and floats"),
    }

    return numbers;
}

test "random i32" {
    const nums = random_nums(i32, 32);
    try expectEqual(nums.len, 32);
}

test "random f64" {
    const nums = random_nums(f64, 32);
    try expectEqual(nums.len, 32);
}
