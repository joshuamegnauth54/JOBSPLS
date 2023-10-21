const std = @import("std");

const ResTwoSum = @import("two_sum.zig").ResTwoSum;

pub fn two_sum_sorted_search(comptime T: type, haystack: []T, target: T) ?ResTwoSum {
    comptime if (@typeInfo(T) != .Int and @typeInfo(T) != .ComptimeInt) {
        @compileError("T must be an integer of any precision");
    };

    if (haystack.len < 2) {
        return null;
    }

    var i: usize = 0;
    while (i < haystack.len) : (i += 1) {
        const val = haystack[i];
        var diff = 0;
        if (@subWithOverflow(T, target, val, &diff)) {
            continue;
        }

        // Binary search. The vals < i were checked earlier so they can be skipped
        var lower: usize = i;
        var upper: usize = haystack.len;
        while (lower <= upper) {
            var mid: usize = @divFloor(lower + upper, 2);
            switch (std.math.order(haystack[mid], diff)) {
                .gt => {
                    upper = mid - 1;
                },
                .lt => {
                    lower = mid + 1;
                },
                .eq => {
                    return ResTwoSum{ .i = i, .j = mid };
                },
            }
        }
    }

    return null;
}

pub fn two_sum_sorted_pointer(comptime T: type, haystack: []T, target: T) ?ResTwoSum {
    comptime if (@typeInfo(T) != .Int and @typeInfo(T) != .ComptimeInt) {
        @compileError("T must be an integer of any precision");
    };

    if (haystack.len < 2) {
        return null;
    }

    // Two ends of the slice
    var left: usize = 0;
    var right: usize = 0;

    // Similar to a binary search except in O(n) time
    while (left <= right) {
        // Shouldn't overflow since haystack is sorted
        var result = haystack[right] - haystack[left];

        if (result > target) {
            right -= 1;
        } else if (result < target) {
            left -= 1;
        } else {
            return ResTwoSum{ .i = left, .j = right };
        }
    }

    // Pair doesn't exist if loop ends
    return null;
}
