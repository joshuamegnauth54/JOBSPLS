//! Type ordering for algorithms

pub const Ordering = enum { Less, Equal, Greater };

/// Return a type that orders `Lhs` in terms of `Rhs`
pub fn PartialOrd(comptime Lhs: type, comptime Rhs: type, cmp: fn (self: *const Lhs, rhs: *const Rhs) Ordering) type {
    return struct {
        /// Compare the ordering of `lhs` and `rhs`.
        cmp: fn (lhs: *const Lhs, rhs: *const Rhs) Ordering = cmp,

        /// LHS < RHS
        pub fn lt(self: *@This(), lhs: *const Lhs, rhs: *const Rhs) bool {
            return self.cmp(lhs, rhs) == Ordering.Less;
        }
    };
}
