const std = @import("std");
const Allocator = std.mem.Allocator;
const expectEqualSlices = std.testing.expectEqualSlices;

pub fn prod_sans_self(comptime T: type, allocator: Allocator, values: []const T) ![]T {
    comptime switch (@typeInfo(T)) {
        .Int, .ComptimeInt, .Float, .ComptimeFloat => {},
        else => @compileError("T must be an integer or float"),
    };

    var product = try allocator.alloc(T, values.len);
    // @memset(product.ptr, 1, product.len);
    std.mem.set(T, product, 1);

    // First pass. Skips the 0th value in products so that the product
    // is shifted over by one. This skips self.
    // I wrote detailed comments for my Rust implementation. Check for details
    var left: T = 1;
    var i: isize = 0;
    while (i < product.len) : (i += 1) {
        const iu = @intCast(usize, i);
        product[iu] = left;
        left *= values[iu];
    }

    // Reverse pass. Skips the last element in a manner similar to the left pass.
    var right: T = 1;
    i -= 1;
    while (i >= 0) : (i -= 1) {
        const iu = @intCast(usize, i);
        product[iu] *= right;
        right *= values[iu];
    }

    return product;
}

test "product of array sans self ex 1" {
    const values = [4]u8{ 1, 2, 3, 4 };
    const expected = [4]u8{ 24, 12, 8, 6 };
    const actual = try prod_sans_self(u8, std.testing.allocator, &values);

    defer std.testing.allocator.destroy(actual.ptr);
    try expectEqualSlices(u8, &expected, actual);
}

test "product of array sans self ex 2" {
    const values = [_]i8{ -1, 1, 0, -3, 3 };
    const expected = [_]i8{ 0, 0, 9, 0, 0 };
    const actual = try prod_sans_self(i8, std.testing.allocator, &values);

    defer std.testing.allocator.destroy(actual.ptr);
    try expectEqualSlices(i8, &expected, actual);
}
