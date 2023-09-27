const std = @import("std");

comptime {
    _ = @import("tests/binary.zig");
    _ = @import("neet.zig");
}

test {
    std.testing.refAllDecls(@This());
}
