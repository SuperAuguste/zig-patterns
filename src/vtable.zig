//! When to use:
//! - When you want to call multiple functions over a single, unified interface
//!   with very few / no common fields.
//!
//! When not to use:
//! - If you have a lot of common fields, you could use `@fieldParentPtr`
//! - If you have only one common function, you could replace the vtable pointer
//!   with a function pointer (I'd call this a "type erased")

const std = @import("std");

pub const Extension = struct {
    ctx: *anyopaque,
    vtable: *const VTable,

    pub const VTable = struct {
        activate: *const fn (ctx: *anyopaque) anyerror!void,
        deactivate: *const fn (ctx: *anyopaque) anyerror!void,
        run: *const fn (ctx: *anyopaque, n: usize) anyerror!void,
    };

    pub fn activate(extension: Extension) anyerror!void {
        return extension.vtable.activate(extension.ctx);
    }

    pub fn deactivate(extension: Extension) anyerror!void {
        return extension.vtable.deactivate(extension.ctx);
    }

    pub fn run(extension: Extension, n: usize) anyerror!void {
        return extension.vtable.run(extension.ctx, n);
    }
};

pub const HelloWorldSayer = struct {
    activated: bool = false,
    file: std.fs.File,

    fn activate(ctx: *anyopaque) anyerror!void {
        const hws: *HelloWorldSayer = @alignCast(@ptrCast(ctx));
        hws.activated = true;
    }

    fn deactivate(ctx: *anyopaque) anyerror!void {
        const hws: *HelloWorldSayer = @alignCast(@ptrCast(ctx));
        hws.activated = false;
    }

    fn run(ctx: *anyopaque, n: usize) anyerror!void {
        const hws: *HelloWorldSayer = @alignCast(@ptrCast(ctx));

        if (!hws.activated)
            return;

        for (0..n) |_| {
            std.debug.print("Hello world!\n", .{});
        }
    }

    const vtable = Extension.VTable{
        .activate = &activate,
        .deactivate = &deactivate,
        .run = &run,
    };

    pub fn extension(hws: *HelloWorldSayer) Extension {
        return .{
            .ctx = @ptrCast(hws),
            .vtable = &vtable,
        };
    }
};

pub const BruhSayer = struct {
    activated: bool = false,
    file: std.fs.File,

    fn activate(ctx: *anyopaque) anyerror!void {
        const bs: *BruhSayer = @alignCast(@ptrCast(ctx));
        bs.activated = true;
    }

    fn deactivate(ctx: *anyopaque) anyerror!void {
        const bs: *BruhSayer = @alignCast(@ptrCast(ctx));
        bs.activated = false;
    }

    fn run(ctx: *anyopaque, n: usize) anyerror!void {
        const bs: *BruhSayer = @alignCast(@ptrCast(ctx));

        if (!bs.activated)
            return;

        for (0..n) |_| {
            std.debug.print("bruh\n", .{});
        }
    }

    const vtable = Extension.VTable{
        .activate = &activate,
        .deactivate = &deactivate,
        .run = &run,
    };

    pub fn extension(bs: *BruhSayer) Extension {
        return .{
            .ctx = @ptrCast(bs),
            .vtable = &vtable,
        };
    }
};

test {
    var hws = HelloWorldSayer{ .file = std.io.getStdOut() };
    const hello_world_extension = hws.extension();

    var bs = BruhSayer{ .file = std.io.getStdOut() };
    const bruh_extension = bs.extension();

    const extensions = &[_]Extension{ hello_world_extension, bruh_extension };

    for (extensions) |extension| {
        try extension.activate();
        try extension.run(3);
        try extension.deactivate();
        try extension.run(3);
    }
}
