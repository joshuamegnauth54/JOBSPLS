const std = @import("std");
const testing = std.testing;
const expectEqualSlices = testing.expectEqualSlices;

/// Linear congruential generator
///
/// # Parameters
///
/// * I: Unsigned int
/// * seed: 0 <= seed < mod
/// * multiplier: 0 < multiplier < mod
/// * increment: 0 <= increment < mod
/// * mod: mod > 0
/// *
pub fn LCG(
    comptime I: type,
) type {
    comptime switch (@typeInfo(I)) {
        .ComptimeInt => {},
        .Int => {},
        else => @compileError("LCG only works with unsigned ints"),
    };

    return struct {
        const Self = @This();
        seed: I,
        multiplier: I,
        increment: I,
        mod: I,

        /// Initialize LCG.
        fn new(seed: I, multiplier: I, increment: I, mod: I) LcgError!Self {
            // Validate LCG's parameters
            if (mod < 0) {
                return LcgError.InvalidMod;
            }
            if (seed < 0 or seed > mod) {
                return LcgError.InvalidSeed;
            }
            if (multiplier < 0 or multiplier > mod) {
                return LcgError.InvalidMult;
            }
            if (increment < 0 or increment > mod) {
                return LcgError.InvalidIncr;
            }

            return Self{ .seed = seed, .multiplier = multiplier, .increment = increment, .mod = mod };
        }

        /// Next random int
        fn int(self: *Self) I {
            const a = self.*.multiplier;
            const X_n = self.*.seed;
            const c = self.*.increment;
            const m = self.*.mod;

            // Xn+1
            const X_n1 = (a * X_n + c) % m;
            self.*.seed = X_n1;

            return X_n1;
        }
    };
}

pub const LcgError = error{ InvalidSeed, InvalidMult, InvalidIncr, InvalidMod };

test "lcg prng generates expected values" {
    const expected = [_]u16{ 6, 1, 20, 31, 2, 29, 16, 27, 30, 25, 12, 23, 26, 21, 8, 19, 22, 17, 4, 15, 18, 13, 0, 11, 14, 9, 28, 7, 10, 5, 24, 3 };

    // Hull-Dobell
    // 11 and 32 are relatively prime
    // 9 - 1 is divisible by the prime factors if 32
    var lcg = try LCG(u16).new(3, 9, 11, 32);
    var actual = try testing.allocator.alloc(u16, expected.len);
    defer testing.allocator.free(actual);

    var i: usize = 0;
    while (i < expected.len) : (i += 1) {
        actual[i] = lcg.int();
    }

    try expectEqualSlices(u16, &expected, actual);
}
