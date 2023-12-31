const std = @import("std");
const toLower = std.ascii.toLower;
const expect = std.testing.expect;

/// Check if `s` is an ASCII palindrome.
///
/// WARN: ASCII only.
pub fn valid_palindrome(s: []const u8) bool {
    if (s.len < 2) {
        return false;
    }

    var front: usize = 0;
    var end: usize = s.len - 1;
    while (front < end) {
        if (toLower(s[front]) != toLower(s[end])) {
            return false;
        }

        // Traverse string from both ends
        front += 1;
        end -= 1;
    }

    return true;
}

test "valid palindromes should succeed" {
    const palindromes = [_][]const u8{
        "level",
        "repaper",
        "peeweep",
        "tattarrattat",
    };

    for (palindromes) |palindrome| {
        try expect(valid_palindrome(palindrome));
    }
}

test "invalid palindromes should fail" {
    const not_palins = [_][]const u8{ "", "j" };

    for (not_palins) |s| {
        try expect(!valid_palindrome(s));
    }
}

test "words that aren't palindromes should fail" {
    const not_palins = [_][]const u8{
        "fat",
        "cat",
        "on a",
        "mat",
    };

    for (not_palins) |s| {
        try expect(!valid_palindrome(s));
    }
}
