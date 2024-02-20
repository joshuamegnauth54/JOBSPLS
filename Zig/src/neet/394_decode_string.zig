//! LeetCode #394
//! https://leetcode.com/problems/decode-string/

const std = @import("std");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const isAlphabetic = std.ascii.isAlphabetic;
const isDigit = std.ascii.isDigit;
const parseInt = std.fmt.parseInt;

const expectEqualStrings = std.testing.expectEqualStrings;

pub fn decode_string_repeat(allocator: Allocator, encoded: []const u8) ![]const u8 {
    // var decoded = try decode_string(allocator, encoded, 0);
    // return decoded.value.toOwnedSlice();
    var buffer = ArrayList(u8).init(allocator);
    errdefer buffer.deinit();

    var i: usize = 0;
    while (i < encoded.len) : (i += 1) {
        const temp = try decode_inner(allocator, encoded[i..encoded.len]);
        defer temp.value.deinit();
        try buffer.appendSlice(temp.value.items);
    }

    return buffer.toOwnedSlice();
}

fn decode_string(allocator: Allocator, encoded: []const u8, depth: u8) !DecodeStrRes {
    // Final repeated and concatenated string
    var buffer = ArrayList(u8).init(allocator);
    errdefer buffer.deinit();

    // Intermediary buf for parsing
    var temp = ArrayList(u8).init(allocator);
    defer temp.deinit();

    // Parser's current state
    var state: DecodeState = .NewStr;
    // Start index of the value being parsed
    var start: usize = 0;
    // Amount of times to repeat buffer
    var repeat: usize = 1;

    var i: usize = 0;
    while (i < encoded.len) : (i += 1) {
        switch (state) {
            .NewStr => {
                std.debug.print("NewStr: {s}\n", .{encoded});
                start = i;

                const ch = encoded[i];
                if (isAlphabetic(ch)) {
                    state = .Text;
                } else if (isDigit(ch)) {
                    state = .Number;
                } else {
                    return DecodeError.ExpectedAlphanumeric;
                }
            },
            .Number => {
                const ch = encoded[i];
                // std.debug.print("Number ch: {s}\n", .{[1]u8{ch}});

                if (ch == '[') {
                    // Open bracket signifies end of num and beginning of text
                    // Parse the repeat value and switch to the text state
                    repeat = try parseInt(u32, encoded[start..i], 10);

                    state = .Text;
                    start = i + 1;
                } else if (!isDigit(ch)) {
                    return DecodeError.InvalidNumber;
                }
            },
            .Text => {
                const ch = encoded[i];
                std.debug.print("Text ch: {s}\n", .{[1]u8{ch}});
                // If the current char is a digit, recurse to parse the nested str
                // The nested string is attached to this depth's buffer
                // in order to repeat the whole buf
                if (isDigit(ch)) {
                    const nested = try decode_string(allocator, encoded[i..], depth + 1);
                    defer nested.value.deinit();
                    try temp.appendSlice(nested.value.items);
                    i += nested.index;
                }

                if (encoded[i] == ']') {
                    // Copy string slice to temp buffer
                    // std.debug.print("Encoded copy: {s}\n", .{encoded[start .. i - 1]});
                    // try temp.appendSlice(encoded[start .. i - 1]);

                    // Repeat the string slice

                    // Return owned string and index past the closing bracket
                    try buffer.ensureUnusedCapacity(temp.items.len * repeat);
                    var j: usize = 0;
                    while (j < repeat) : (j += 1) {
                        buffer.appendSliceAssumeCapacity(temp.items);
                    }

                    // HACK: Keep track of the depth so parsing unnested strings works
                    // Otherwise, the algorithm doesn't parse the entire str at depth 0
                    if (depth > 0 or (depth == 0 and i == encoded.len - 1)) {
                        return DecodeStrRes{
                            .value = buffer,
                            .index = i + 1,
                        };
                    }

                    state = .NewStr;
                } else {
                    try temp.append(ch);
                }
            },
        }
    }

    // Numbers can't appear before bare text
    // Therefore, bare text always has a repeat of 1
    // If repeat != 1, then a bracket should've been found in the state machine
    if (repeat == 1) {
        try buffer.appendSlice(temp.items);
        return DecodeStrRes{
            .value = buffer,
            .index = i + 1,
        };
    }
    return DecodeError.ExpectedDelimiter;
}

// Decode a single, arbitrarily nested string sequence.
fn decode_inner(allocator: Allocator, encoded: []const u8) !DecodeStrRes {
    var buffer = ArrayList(u8).init(allocator);
    errdefer buffer.deinit();

    var state: DecodeState = .NewStr;
    var repeat: usize = 1;
    var start: usize = 0;

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
                    std.debug.print("{} => {s}\n", .{ i, encoded });
                    return DecodeError.ExpectedAlphanumeric;
                }
            },
            .Number => {
                const ch = encoded[i];

                if (ch == '[') {
                    // Open bracket signifies end of num and beginning of text
                    // Parse the repeat value and switch to the text state
                    repeat = try parseInt(u32, encoded[start..i], 10);

                    state = .Text;
                    // start = i + 1;
                } else if (!isDigit(ch)) {
                    return DecodeError.InvalidNumber;
                }
            },
            .Text => {
                const ch = encoded[i];

                // Recurse into a new parser if numeric
                // Nested text is appended to this buffer
                if (isDigit(ch)) {
                    const nested = try decode_inner(allocator, encoded[i..]);
                    defer nested.value.deinit();
                    try buffer.appendSlice(nested.value.items);
                    // This is the index after the closing bracket
                    i = nested.index;
                }

                // Return buffer if this block is fully parsed
                if (ch == ']') {
                    // Repeat buffer if required
                    try repeat_buffer(&buffer, repeat);

                    return DecodeStrRes{ .value = buffer, .index = i + 1 };
                }

                // Otherwise append the char to the string buffer
                try buffer.append(ch);
            },
        }
    }

    // String exhausted. Repeat and return.
    try repeat_buffer(&buffer, repeat);

    return DecodeStrRes{ .value = buffer, .index = i + 1 };
}

fn repeat_buffer(buffer: *ArrayList(u8), repeat: usize) !void {
    if (repeat > 1) {
        // Current length i.e. the complete string to repeat
        const len = buffer.items.len;
        try buffer.ensureTotalCapacity(len * repeat);

        // Unrepeated buffer
        const original = buffer.items[0..len];

        var i = repeat;
        while (i > 1) : (i -= 1) {
            // SAFETY: Doesn't allocate nor moves memory, so `original` is still valid
            buffer.appendSliceAssumeCapacity(original);
        }
    }
}

const DecodeState = enum { NewStr, Number, Text };

const DecodeStrRes = struct {
    value: ArrayList(u8),
    index: usize,
};

const DecodeError = error{
    InvalidNumber,
    ExpectedAlphanumeric,
    ExpectedDelimiter,
};

fn test_main(input: []const u8, expected: []const u8) !void {
    const actual = try decode_string_repeat(std.testing.allocator, input);
    defer if (actual.len > 0) {
        std.testing.allocator.destroy(actual.ptr);
    };
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
