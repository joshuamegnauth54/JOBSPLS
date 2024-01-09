//! LeetCode #394
//! https://leetcode.com/problems/decode-string/

const std = @import("std");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const isAlphabetic = std.ascii.isAlphabetic;
const isDigit = std.ascii.isDigit;
const parseInt = std.fmt.parseInt;

const expectEqualStrings = std.testing.expectEqualStrings;

pub fn decode_string_repeat(allocator: Allocator, encoded: []const u8) ![]const u8 {}

fn decode_string(allocator: Allocator, encoded: []const u8) !DecodeStrRes {
    // Final repeated and concatenated string
    var buffer = ArrayList(u8).init(allocator);
    errdefer buffer.deinit();

    // Intermediary buf for parsing
    var temp = ArrayList(u8).init(allocator);
    defer temp.deinit();

    // Parser's current state
    var state = .NewStr;
    // Start index of the value being parsed
    var start: usize = 0;
    // Amount of times to repeat buffer
    var repeat: usize = 1;

    var i: usize = 0;
    while (i < encoded.len) : (i += 1) {
        switch (state) {
            .NewStr => {
                start = i;

                const ch = encoded[i];
                if (isAlphabetic(ch)) {
                    state = .Text;
                } else if (isDigit(ch)) {
                    state = .Number;
                } else {
                    return .ExpectedAlphanumeric;
                }
            },
            .Number => {
                const ch = encoded[i];

                if (ch == '[') {
                    // Open bracket signifies end of num and beginning of text
                    // Parse the repeat value and switch to the text state
                    repeat = try parseInt(u32, encoded[start..i]);

                    state = .Text;
                    start = i + 1;
                } else if (!isDigit(ch)) {
                    return .InvalidNumber;
                }
            },
            .Text => {
                const ch = encoded[i];
                // If the current char is a digit, recurse to parse the nested str
                // The nested string is attached to this depth's buffer
                // in order to repeat the whole buf
                if (isDigit(ch)) {
                    const nested = try decode_string(allocator, encoded[i..]);
                    defer nested.value.deinit();
                    try temp.appendSlice(nested.value);
                    i += nested.index;
                }

                if (encoded[i] == ']') {
                    // Repeat the string slice

                    // Return owned string and index past the closing bracket
                    try buffer.ensureUnusedCapacity(temp.len * repeat);
                    var j = 0;
                    while (j < repeat) : (j += 1) {
                        buffer.appendSliceAssumeCapacity(temp.items);
                    }

                    return DecodeStrRes {
                        .value= buffer,
                        .index= i + 1,
                    };

                }
            },
        }
    }
}

const DecodeState = enum { NewStr, Number, Text };

const DecodeStrRes = struct {
    value: ArrayList(u8),
    index: usize,
};

fn test_main(input: []const u8, expected: []const u8) !void {
    const actual = try decode_string_repeat(std.testing.allocator, input);
    defer std.testing.destroy(actual.ptr);
    try expectEqualStrings(expected, actual);
}

test "LeetCode 394 example 1 basic" {
    const input = "3[a]2[bc]";
    const expected = "aaabcbc";

    try test_main(input, expected);
}

test "LeetCode 394 example 2 nested" {
    const input = "3[a2[c]]";
    const expected = "accaccacc";

    try test_main(input, expected);
}

test "LeetCode 394 example 3 no repeat" {
    const input = "2[abc]3[cd]ef";
    const expected = "abcabccdcdcdef";

    try test_main(input, expected);
}
