//! Binary search for integral types

const PartialOrd = @import("../traits/partialord.zig").PartialOrd;
const Ordering = @import("../traits/partialord.zig").Ordering;
const TypeInfo = @import("std").builtin.TypeInfo;

/// Binary search result.
///
/// This reports the index of the value if found OR where it should be.
pub const BinaryRes = union(enum) {
    /// Index of the value if found
    found: usize,
    /// Expected location of the value if not found
    not_found: usize,
};

// TODO
pub fn binary(comptime T: type, haystack: []T, lower: usize, upper: usize, needle: T, comptime cmp: ?PartialOrd) BinaryRes {
    switch (@typeInfo(T)) {
        // Built-in types have operators defined so `cmp` isn't needed
        .Int, .ComptimeInt, .Float, .ComptimeFloat, .Bool => return binary_builtin(T, haystack, lower, upper, needle),
        // Otherwise `cmp` is needed
        else => {
            comptime if (cmp) |cmp_chk| {
                // PartialOrd must compare type T
                if (!(T == cmp_chk.Lhs and T == cmp_chk.Rhs)) {
                    @compileError("Binary search and PartialOrd must use the same type T");
                }
                return binary_any(T, haystack, lower, upper, needle, cmp_chk);
            } else {
                @compileError("Non-builtin types require a PartialOrd implementation.");
            };
        },
    }
}

// Binary search for built in types with predefined operators
fn binary_builtin(comptime T: type, haystack: []T, lower: usize, upper: usize, needle: T) BinaryRes {
    const index: usize = @divTrunc(lower + upper, 2);
    const item: T = haystack[index];

    if (lower >= upper) {
        return BinaryRes{ .not_found = index };
    }

    if (item < needle) {
        // If item is smaller than needle, index is a lower bound
        return binary_builtin(T, haystack, index + 1, upper, needle);
    } else if (item > needle) {
        // item > needle means index is an upper bound
        return binary_builtin(T, haystack, lower, index - 1, needle);
    } else {
        return BinaryRes{ .found = index };
    }
}

// Binary search for any type with a `PartialOrd` comparator
fn binary_any(comptime T: type, haystack: []T, lower: usize, upper: usize, needle: T, cmp: PartialOrd) BinaryRes {
    const index = @divTrunc(lower + upper, 2);
    const item = haystack[index];

    if (lower >= upper) {
        return BinaryRes{ .not_found = index };
    }

    switch (cmp.cmp(item, needle)) {
        .Less => binary_any(T, haystack, index + 1, upper, needle, cmp),
        .Greater => binary_any(T, haystack, lower, index - 1, needle, cmp),
        .Equal => BinaryRes{ .found = index },
    }
}
