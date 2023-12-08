//! When to use:
//! - When you don't want runtime overhead
//! - When you want reasonably strong type correctness guarantees
//!   - this avoids most runtime errors potentially found in other techniques
//!
//! When not to use:
//! - If you want extensibility! This solution is not extensible in any way, i.e.
//!   a user would have to modify the structure directly.

const std = @import("std");

pub const Player = union(enum) {
    pub const Crewmate = struct {
        pub fn speak(crewmate: Crewmate) void {
            _ = crewmate;

            std.debug.print("Red is sus!\n", .{});
        }

        pub fn doTask(crewmate: Crewmate) !void {
            _ = crewmate;

            std.debug.print("Crewmate did task!\n", .{});
        }

        pub fn doMurder(crewmate: Crewmate) !void {
            _ = crewmate;

            return error.IllegalAction;
        }
    };

    pub const Impostor = struct {
        pub fn speak(impostor: Impostor) void {
            _ = impostor;

            std.debug.print("Green is sus!\n", .{});
        }

        pub fn doTask(impostor: Impostor) !void {
            _ = impostor;

            return error.IllegalAction;
        }

        pub fn doMurder(impostor: Impostor) !void {
            _ = impostor;

            std.debug.print("Impostor did murder!\n", .{});
        }
    };

    crewmate: Crewmate,
    impostor: Impostor,

    pub fn speak(player: Player) void {
        switch (player) {
            inline else => |p| p.speak(),
        }
    }

    pub fn doTask(player: Player) !void {
        return switch (player) {
            inline else => |p| p.doTask(),
        };
    }

    pub fn doMurder(player: Player) !void {
        return switch (player) {
            inline else => |p| p.doMurder(),
        };
    }
};

test {
    const crewmate = Player{ .crewmate = .{} };
    const impostor = Player{ .impostor = .{} };

    crewmate.speak();
    impostor.speak();

    try std.testing.expectError(error.IllegalAction, crewmate.doMurder());
    try impostor.doMurder();

    try crewmate.doTask();
    try std.testing.expectError(error.IllegalAction, impostor.doTask());
}
