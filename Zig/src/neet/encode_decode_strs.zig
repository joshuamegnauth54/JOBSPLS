const std = @import("std");
const fmt = std.fmt;
const Allocator = std.mem.Allocator;
const expectEqualStrings = std.testing.expectEqualStrings;

/// Serialize a slice of strings into a single, flat string.
///
/// I'm essentially using a variation of Bencoding.
pub fn serialize_slice_str(allocator: Allocator, strings: []const []const u8) ![]const u8 {
    // Cumulative length of each prefix + string (total length of each serialized string)
    var strs_offsets = try allocator.alloc(u64, strings.len);
    defer allocator.destroy(strs_offsets.ptr);

    // Length of entire buffer to serialize
    var total_len: usize = 0;

    // Calculate required lengths of each string
    var i: usize = 0;
    while (i < strings.len) : (i += 1) {
        const slen = serialized_str_len(strings[i]);

        // Offset should be the cumulative sum of string lengths up to but precluding i
        // So the offset at i = 0 is 0
        // Offset at i = 1 is the length of string #0
        // Offset at i = 2 is len string #0 + len string #1...
        strs_offsets[i] = total_len;
        total_len += slen;
    }

    // Allocate buffer for entire serialized string
    var ser_buf = try allocator.alloc(u8, total_len);
    errdefer allocator.destroy(ser_buf.ptr);

    i = 0;
    while (i < strings.len) : (i += 1) {
        const offset = strs_offsets[i];
        const s = strings[i];
        try serialize_str_buf(ser_buf[offset..], s);
    }

    return ser_buf;
}

pub fn deserialize_slice_str(s: []const u8) !IResult([]const u8) {
    // Parse the length of the string
    const result = try take_until(s, ":");
    const len = try fmt.parseUnsigned(usize, result.parsed, 10);

    // Take `len` bytes then validate as unicode
    const str_res = try take_n(result.remainder, len);
    if (!std.unicode.utf8ValidateSlice(str_res.parsed)) {
        return ParseError.InvalidUnicode;
    }

    return IResult([]const u8).new(str_res.parsed, str_res.remainder);
}

// Format string to serialize strings
// length:string
const ser_str_fmt = "{d}:{s}";

// Number of bytes required to serialize string.
fn serialized_str_len(s: []const u8) u64 {
    return fmt.count(ser_str_fmt, .{ s.len, s });
}

// Serialize a single string.
fn serialize_str(allocator: Allocator, s: []const u8) ![]const u8 {
    return try fmt.allocPrint(allocator, ser_str_fmt, .{ s.len, s });
}

// Serialize a string into a preallocated buffer.
fn serialize_str_buf(buf: []u8, s: []const u8) !void {
    _ = try fmt.bufPrint(buf, ser_str_fmt, .{ s.len, s });
}

const ParseError = error{ DelimiterNotFound, InvalidLength, InvalidUnicode };

const ParseResult =
    struct { parsed: []const u8, remainder: []const u8 };

fn IResult(comptime T: type) type {
    return struct {
        /// Parsed value
        value: T,
        /// Remaining unparsed bytes
        remainder: []const u8,

        fn new(value: T, remainder: []const u8) @This() {
            return @This(){ .value = value, .remainder = remainder };
        }
    };
}

// Take bytes from `s` until delimiter is reached.
//
// Returns an error if delimiter isn't found.
fn take_until(s: []const u8, delimiter: []const u8) ParseError!ParseResult {
    if (delimiter.len == 0) {
        return ParseResult{ .parsed = s, .remainder = comptime &[0]u8{} };
    }

    // Accumulate everything before the delimiter.
    var i: usize = 0;
    while (i < s.len) : (i += 1) {
        // Check if delimiter has been reached
        var j: usize = 0;
        while (j < delimiter.len and i + j < s.len) : (j += 1) {
            if (s[i] != delimiter[j]) {
                break;
            }
        }
        // Delimiter found if the loop traversed the length of delimiter
        if (j == delimiter.len) {
            return ParseResult{ .parsed = s[0..i], .remainder = s[i + j .. s.len] };
        }
    }

    return ParseError.DelimiterNotFound;
}

fn take_n(bytes: []const u8, amount: usize) !ParseResult {
    if (amount > bytes.len) {
        return ParseError.InvalidLength;
    }

    return ParseResult{ .parsed = bytes[0..amount], .remainder = bytes[amount..] };
}

test "serialize strings simple" {
    const strings = [3][]const u8{ "Frieren", " is ", "awesome." };
    const expected = "7:Frieren4: is 8:awesome.";

    const actual = try serialize_slice_str(std.testing.allocator, &strings);
    defer std.testing.allocator.destroy(actual.ptr);

    try expectEqualStrings(expected, actual);
}

test "serialize strings empty" {
    const strings = [1][]const u8{""};
    const expected = "0:";

    const actual = try serialize_slice_str(std.testing.allocator, &strings);
    defer std.testing.allocator.destroy(actual.ptr);

    try expectEqualStrings(expected, actual);
}

test "deserialize string slice" {
    const expected = "All tomorrow's parties";
    const s = fmt.comptimePrint("{}:{s}", .{ expected.len, expected });

    const actual = try deserialize_slice_str(s);
    try expectEqualStrings(expected, actual.value);
}
