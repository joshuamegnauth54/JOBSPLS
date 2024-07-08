const std = @import("std");
const expectEqual = std.testing.expectEqual;

fn search_rotated_slice(
    comptime T: type,
    haystack: []const T,
    needle: T,
) usize {
    // TODO: Check types
    if (haystack.len == 0) {
        return 0;
    }

    // var lower = 0;
    // var upper = haystack.len;
    var search = which_end(T, haystack, needle);
    var mid: usize = 0;

    while (search.lower <= search.upper) {
        mid = @divFloor(search.lower + search.upper, 2);

        if (mid == search.lower and search.lower == search.upper) {
            return mid;
        } else if (haystack[mid] > needle) {
            search.upper = mid;
        } else if (haystack[mid] < needle) {
            search.lower = mid;
        } else {
            return mid;
        }
    }

    return mid;
}

fn which_end(comptime T: type, haystack: []const T, needle: T) SearchEnd {
    const mid = @divFloor(0 + haystack.len, 2);
    const mid_val = haystack[mid];
    const low_val = haystack[0];
    const upp_val = haystack[haystack.len - 1];

    // Determine which half to search
    // A straightforward binary search can't be used because (mid + 1) < (mid - 1)
    // is possible due to the rotation
    // Beyond that, the zeroth value may be larger than mid - 1 and
    // (mid + 1) > (length - 1) is possible as well
    if (needle > low_val and low_val < mid_val and needle < mid_val) {
        return SearchEnd{
            .lower = 0,
            .upper = mid,
        };
    } else if (needle > mid_val and mid_val < upp_val and needle < upp_val) {
        return SearchEnd{
            .lower = mid,
            .upper = haystack.len,
        };
    } else if (needle > low_val and low_val > mid_val and needle > mid_val) {
        return SearchEnd{
            .lower = 0,
            .upper = mid,
        };
    } else if (needle > mid_val and mid_val > upp_val and needle > upp_val) {
        return SearchEnd{
            .lower = mid,
            .upper = haystack.len,
        };
    } else if (needle == mid_val) {
        return SearchEnd{
            .lower = mid,
            .upper = mid,
        };
    } else if (needle > upp_val and needle < low_val) {
        // Edge case where a value is missing and beyond the range
        return SearchEnd{
            .lower = haystack.len,
            .upper = haystack.len,
        };
    } else {
        return SearchEnd{
            .lower = 0,
            .upper = 0,
        };
    }
}

const SearchEnd = struct {
    lower: usize,
    upper: usize,
};

test "leetcode example 1" {
    const haystack = [_]u8{ 4, 5, 6, 7, 0, 1, 2, 3 };
    const expected: usize = 4;
    const actual = search_rotated_slice(u8, &haystack, 0);

    try expectEqual(expected, actual);
}

test "leetcode example 2" {
    const haystack = [_]u8{ 4, 5, 6, 7, 0, 1, 2 };
    const expected: usize = 7;
    const actual = search_rotated_slice(u8, &haystack, 3);

    try expectEqual(expected, actual);
}

test "leetcode example 3" {
    const haystack = [_]u8{4};
    const expected: usize = 0;
    const actual = search_rotated_slice(u8, &haystack, 0);

    try expectEqual(expected, actual);
}
