const std = @import("std");

pub const examples = .{
    .{ "anytype", "src/anytype.zig" },
    .{ "field_parent_ptr", "src/field_parent_ptr.zig" },
    .{ "vtable", "src/vtable.zig" },
};

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Not really useful, moreso for CI
    const run_all = b.step("all", "Run all unit tests");

    inline for (examples) |example| {
        const step_name, const source_file = example;

        const @"test" = b.addTest(.{
            .root_source_file = .{ .path = source_file },
            .target = target,
            .optimize = optimize,
        });

        const run_test = b.addRunArtifact(@"test");
        run_test.has_side_effects = true;

        const test_step = b.step(step_name, "Run unit tests for " ++ step_name);
        test_step.dependOn(&run_test.step);
        run_all.dependOn(&run_test.step);
    }
}
