const std = @import("std");
const expectEqual = std.testing.expectEqual;

const HappySuffixState = enum { Search, Accumulate };

pub const HappyPrefix = struct {
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

test "longest happy prefix example 1" {
    const domain = "level";
    const result = happy_prefix(domain);

    if (result) |happy| {
        try expectEqual(@intCast(usize, 0), happy.prefix_end);
        try expectEqual(domain.len - 1, happy.suffix_start);
    } else {
        @panic("Longest happy prefix for `level` should be found");
    }
}
