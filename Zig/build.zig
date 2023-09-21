const std = @import("std");
const Build = std.Build;

pub fn build(b: *Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Modules
    const traits = b.addModule("traits", .{ .source_file = .{ .path = "src/traits/traits.zig" } });

    const search = b.addModule("search", .{ .source_file = .{ .path = "src/search/search.zig" }, .dependencies = &.{.{ .name = "traits", .module = traits }} });

    // Tests
    const tests_exe = b.addTest("src/tests.zig", .{ .target = target, .optimize = optimize });
    tests_exe.setMainPkgPath("src");
    tests_exe.addModule(traits);
    tests_exe.addModule(search);

    // Steps
    const test_step = b.step("test", "Run all tests");
    test_step.dependOn(&tests_exe.step);
}
