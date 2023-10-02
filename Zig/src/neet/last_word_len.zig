const std = @import("std");
const trimRight = std.mem.trimRight;
const splitBackwards = std.mem.splitBackwards;
const whitespace = std.ascii.whitespace;
const expectEqual = std.testing.expectEqual;

/// Calculate length of the last ASCII sequence in a string.
///
/// The last "word" includes punctuation but not whitespace.
pub fn last_word_len(s: []const u8) usize {
    // Trim whitespace from the end only
    const trimmed = trimRight(u8, s, &whitespace);

    // Split on spaces and select the last word, if any
    var iter = splitBackwards(u8, trimmed, " ");
    const last = iter.next();
    if (last) |word| {
        return word.len;
    }
    return 0;
}

test "last word len for a basic string" {
    const s = "Meow is a four letter word";
    const expected: usize = 4;
    try expectEqual(expected, last_word_len(s));
}

test "last word for a string with spaces" {
    const s = "   t hi s sTRING HAS     A LOT OF SPACES  Why       ";
    const expected: usize = 3;
    try expectEqual(expected, last_word_len(s));
}
