const std = @import("std");
const Allocator = std.mem.Allocator;
const AutoHashMap = std.AutoHashMap;
const ArrayList = std.ArrayList;
const sort = std.sort.sort;
const asc = std.sort.asc;
const expect = std.testing.expect;
const expectEqualSlices = std.testing.expectEqualSlices;
const expectEqual = std.testing.expectEqual;

/// Check if an index other than `i` or `j` exists in `indices`.
///
/// The haystack may have duplicates, but numbers can't be used more than once.
/// However, a third copy of the number is fine.
fn not_self(i: usize, j: usize, indices: []const usize) ?usize {
    if (i == j) {
        return null;
    }

    for (indices) |index| {
        if (i != index and j != index) {
            return index;
        }
    }
    return null;
}

// Deallocates heap data stored in the number: vec of indices map
fn clean_map(comptime T: type, map: *AutoHashMap(T, ArrayList(usize))) void {
    defer map.*.deinit();
    // Values may have allocated on the heap
    var iter = map.*.valueIterator();
    while (iter.next()) |vec| {
        vec.deinit();
    }
}

pub fn three_sum_set(comptime T: type, allocator: Allocator, haystack: []const T, target: T) !?[][3]T {
    comptime if (@typeInfo(T) != .Int and @typeInfo(T) != .ComptimeInt) {
        @compileError("T must be an integer");
    };

    if (haystack.len < 3) {
        return null;
    }

    // Sort haystack
    var haysort = try ArrayList(T).initCapacity(allocator, haystack.len);
    haysort.appendSliceAssumeCapacity(haystack);
    defer haysort.deinit();
    std.sort.sort(T, haysort.items, {}, std.sort.asc(T));

    // Key: Number in haystack
    // Value: vector of indices for that number
    var all_nums = AutoHashMap(T, ArrayList(usize)).init(allocator);
    // Preallocating the map's memory is potentially wasteful due to dupes
    // try all_nums.ensureTotalCapacity(haystack.len);
    defer clean_map(T, &all_nums);

    // Fill the hash map with num: index pairs
    // NOTE: I'm using haysort instead of the unsorted slice for consistency
    // I may or may not have had a derpy bug from indexing into two different slices
    var i: usize = 0;
    while (i < haysort.items.len) : (i += 1) {
        var entry = try all_nums.getOrPut(haysort.items[i]);
        if (!entry.found_existing) {
            entry.value_ptr.* = ArrayList(usize).init(allocator);
        }

        // Append the current index
        try entry.value_ptr.*.append(i);
    }

    // Hash set of found indices
    var sums = AutoHashMap([3]T, void).init(allocator);
    defer sums.deinit();

    // Crawl through haystack to find each triplet.
    // Essentially, the problem is turned into two sum w.r.t. each value
    i = 0;
    while (i < haysort.items.len) : (i += 1) {
        // Values before `i` may be skipped because they were checked already
        var j = i;
        while (j < haysort.items.len) : (j += 1) {
            const sum = haysort.items[i] + haysort.items[j];
            var diff: T = undefined;
            // If T is unsigned, sub may overflow
            if (!@subWithOverflow(T, target, sum, &diff)) {
                // std.debug.print("sum: {}, diff: {}\n", .{ sum, diff });
                // Check for the third number
                if (all_nums.getPtr(diff)) |diff_idxs| {
                    // Ensure diff_idxs is not i or j
                    if (not_self(i, j, diff_idxs.*.items)) |k| {
                        var triplet = [3]T{ haysort.items[i], haysort.items[j], haysort.items[k] };
                        // Sort for stable hashes
                        sort(T, &triplet, {}, asc(T));
                        std.debug.print("Sum: {} Diff: {} Triplet: {} {} {} and indices: {} {} {}\n", .{ sum, diff, haysort.items[i], haysort.items[j], haysort.items[k], i, j, k });
                        try sums.put(triplet, {});
                    }
                }
            }
        }
    }

    var iter = sums.keyIterator();
    var sums_out = try ArrayList([3]T).initCapacity(allocator, sums.count());
    while (iter.next()) |sum| {
        sums_out.appendAssumeCapacity(sum.*);
    }
    return sums_out.toOwnedSlice();
}

const ThreeSumError = error{OutOfMemory};

// Convenience function to test 3sum
fn test_three_sum(comptime T: type, haystack: []const T, target: T, expected: []const [3]T, comptime three_sum: fn (comptime T: type, allocator: Allocator, haystack: []const T, target: T) ThreeSumError!?[][3]T) !void {
    const res = try three_sum(T, std.testing.allocator, haystack, target);
    if (res) |sums| {
        errdefer std.testing.allocator.destroy(sums.ptr);
        try expectEqual(expected.len, sums.len);

        var i: usize = 0;
        while (i < expected.len) : (i += 1) {
            try expectEqualSlices(T, &expected[i], &sums[i]);
        }

        if (sums.len > 0) {
            std.testing.allocator.destroy(sums.ptr);
        }
    } else {
        @panic("Should find three numbers that sum to the target");
    }
}

test "3sum set example 1" {
    const haystack = [_]i8{ -1, 0, 1, 2, -1, -4 };
    const target = 0;
    const expected = [_][3]i8{ [3]i8{ -1, -1, 2 }, [3]i8{ -1, 0, 1 } };

    try test_three_sum(i8, &haystack, target, &expected, three_sum_set);
}
