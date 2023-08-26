pub const BinaryRes = union(enum) { found: usize, not_found: usize };

pub fn binary(comptime T: type, haystack: []T, lower: usize, upper: usize, needle: T) BinaryRes {
    const index: usize = @divFloor(lower + upper, 2);
    const item: T = haystack[index];

    if (lower >= upper) {
        return BinaryRes{ .not_found = index };
    }

    if (item < needle) {
        return binary(T, haystack, index + 1, upper, needle);
    } else if (item > needle) {
        return binary(T, haystack, lower, index - 1, needle);
    } else {
        return BinaryRes{ .found = index };
    }
}
