const std = @import("std");
const expectEqual = std.testing.expectEqual;

fn min_rotated_slice(comptime T: type, slice: []const T) usize {
    comptime switch (@typeInfo(T)) {
        .Int, .ComptimeInt, .Float => {},
        else => @compileError("I'm too lazy to support this for types beyond numbers"),
    };

    if (slice.len == 0) {
        return 0;
    }

    const range = which_end(T, slice);
    return range.lower;
}

fn which_end(comptime T: type, slice: []const T) SearchEnd {
    const lower = 0;
    const upper = slice.len - 1;
    const mid = @divFloor((lower + upper), 2);

    const lres = @subWithOverflow(mid, 1);
    var lindex: usize = undefined;
    var left: T = undefined;
    if (lres[1] == 0) {
        lindex = lres[0];
        left = slice[lindex];
    } else {
        // Only reached if slice's length is 0 or 1
        return .{
            .lower = lower,
            .upper = upper,
        };
    }

    const rres = @addWithOverflow(mid, 1);
    var rindex: usize = undefined;
    var right: T = undefined;
    if (rres[1] == 0) {
        rindex = rres[0];
        right = slice[rindex];
    } else {
        // Only reached if slice's length is 0 or 1
        return .{
            .lower = lower,
            .upper = upper,
        };
    }

    // Determine which half contains smaller numbers
    const val = slice[mid];
    if (right < val and right < left) {
        return .{
            .lower = rindex,
            .upper = upper,
        };
    } else if (left < val and left < right) {
        return .{
            .lower = lower,
            .upper = lindex,
        };
    } else {
        // Unordered or equal?
        return .{
            .lower = lower,
            .upper = upper,
        };
    }
}

const SearchEnd = struct {
    lower: usize,
    upper: usize,
};

test "leetcode example 1" {
    const haystack = [_]u8{ 3, 4, 5, 1, 2 };
    const actual = min_rotated_slice(u8, &haystack);
    const expected: usize = 3;
    try expectEqual(expected, actual);
}

test "leetcode example 2" {
    const haystack = [_]u8{ 4, 5, 6, 7, 0, 1, 2 };
    const actual = min_rotated_slice(u8, &haystack);
    const expected: usize = 4;
    try expectEqual(expected, actual);
}

test "leetcode example 3" {
    const haystack = [_]u8{ 11, 13, 15, 17 };
    const actual = min_rotated_slice(u8, &haystack);
    const expected: usize = 0;
    try expectEqual(expected, actual);
}

test "unrotated" {
    const haystack = [_]u8{ 0, 1, 2, 3, 4, 5, 6, 7 };
    const actual = min_rotated_slice(u8, &haystack);
    const expected: usize = 0;
    try expectEqual(expected, actual);
}
