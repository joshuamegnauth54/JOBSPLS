const std = @import("std");

comptime {
    _ = @import("tests/binary.zig");
}

test {
    std.testing.refAllDecls(@This());
}
