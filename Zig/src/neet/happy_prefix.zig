const std = @import("std");
const expectEqualDeep = std.testing.expectEqualDeep;
const expectEqualStrings = std.testing.expectEqualStrings;
const panic = std.debug.panic;

const HappySuffixState = enum { Search, Accumulate };

/// Indices for the happy prefix and suffix.
pub const HappyPrefix = struct {
    /// End of the prefix slice; [0, prefix_end] which ends on the last char
    /// NOTE: Take care when slicing to slice to prefix_end + 1
    prefix_end: usize,
    suffix_start: usize,
};

// Find the longest happy prefix in `domain` if it exists.
//
// Complexity: O(n)
// Memory use: O(1)
pub fn happy_prefix(domain: []const u8) ?HappyPrefix {
    if (domain.len <= 1) {
        return null;
    }

    var state = HappySuffixState.Search;
    var prefix: usize = 0;
    var suffix: usize = 0;

    var i: usize = 1;
    while (i < domain.len) : (i += 1) {
        switch (state) {
            .Search => {
                // Check if the current ASCII char is equal to the start of the prefix
                // If it is, then the current sequence from i is a potential suffix
                if (domain[i] == domain[prefix]) {
                    suffix = i;
                    state = .Accumulate;
                }
            },
            .Accumulate => {
                // Current char (suffix) == current prefix char
                // The algorithm walks through the beginning of the string (the prefix)
                // while iterating through the string (potential suffix)
                // We don't need to exhaustively check every suffix.
                // We only need to check suffixes that are equal to the beginning of the string
                // The longest happy prefix is the longest terminating suffix
                prefix += 1;
                if (domain[i] != domain[prefix]) {
                    // Reset
                    prefix = 0;
                    suffix = 0;
                    state = .Search;
                }
            },
        }
    }

    // Suffixes must terminate at the end of the string
    // If `suffix` isn't 0 then the algorithm found a sequence that spans [suffix, domain.len)
    // that equals the chars within [0, prefix]
    if (suffix != 0) {
        return HappyPrefix{ .prefix_end = prefix, .suffix_start = suffix };
    }

    return null;
}

// Panic string for tests
const not_found = "Longest happy prefix for `{s}` should be found.";

test "longest happy prefix example 1" {
    const domain = "level";
    const expected = "l";
    const expected_idx = HappyPrefix{ .prefix_end = 0, .suffix_start = domain.len - 1 };
    const result = happy_prefix(domain);

    if (result) |happy| {
        try expectEqualDeep(expected_idx, happy);

        const prefix = domain[0 .. happy.prefix_end + 1];
        const suffix = domain[happy.suffix_start..domain.len];
        try expectEqualStrings(prefix, suffix);
        try expectEqualStrings(expected, prefix);
    } else {
        panic(not_found, .{domain});
    }
}

test "longest happy prefix example 2" {
    const domain = "ababab";
    const expected = "abab";
    const expected_idx = HappyPrefix{ .prefix_end = 3, .suffix_start = 2 };
    const result = happy_prefix(domain);

    if (result) |happy| {
        try expectEqualDeep(expected_idx, happy);

        const prefix = domain[0 .. happy.prefix_end + 1];
        const suffix = domain[happy.suffix_start..domain.len];
        try expectEqualStrings(prefix, suffix);
        try expectEqualStrings(expected, prefix);
    } else {
        panic(not_found, .{domain});
    }
}

test "longest happy prefix example 3" {
    const domain = "meowemilinyameow";
    const expected = "meow";
    const expected_idx = HappyPrefix{ .prefix_end = 3, .suffix_start = 12 };
    const result = happy_prefix(domain);

    if (result) |happy| {
        try expectEqualDeep(expected_idx, happy);

        const prefix = domain[0 .. happy.prefix_end + 1];
        const suffix = domain[happy.suffix_start..domain.len];
        try expectEqualStrings(prefix, suffix);
        try expectEqualStrings(expected, prefix);
    } else {
        panic(not_found, .{domain});
    }
}

test "longest happy prefix example 4" {
    const domain = "";
    const result = happy_prefix(domain);

    if (result) |_| {
        @panic("Shouldn't find a happy suffix for an empty string.");
    }
}
