const std = @import("std");
const time = std.time;
const rand = std.rand;

pub fn random_nums(comptime T: type, comptime size: comptime_int) [size]T {
    // https://nofmal.github.io/zig-with-example/rng/
    const seed = @intCast(u64, time.milliTimestamp());
    var prng = rand.DefaultPrng.init(seed);

    var numbers: [size]T = undefined;

    switch (@typeInfo(T)) {
        .ComptimeInt => {
            _ = prng.random().int(T);
        },
        else => @compileError("`random_nums` is only valid for ints and floats"),
    }

    return numbers;
}

test "blorp" {
    _ = random_nums(i32, 32);
}
