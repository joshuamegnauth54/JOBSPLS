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

        /// LHS <= RHS
        pub fn le(self: *@This(), lhs: *const Lhs, rhs: *const Rhs) bool {
            return switch (self.cmp(lhs, rhs)) {
                .Less, .Equal => true,
                else => false,
            };
        }

        /// LHS > RHS
        pub fn gt(self: *@This(), lhs: *const Lhs, rhs: *const Rhs) bool {
            return self.cmp(lhs, rhs) == Ordering.Greater;
        }

        /// LHS >= RHS
        pub fn ge(self: *@This(), lhs: *const Lhs, rhs: *const Rhs) bool {
            return switch (self.cmp(lhs, rhs)) {
                .Greater, .Equal => true,
                else => false,
            };
        }
    };
}
