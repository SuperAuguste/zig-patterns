//! Let's say that we want to store a list of `struct {a: u8, b: u16}`s.
//!
//! We could use a normal ArrayList; we'd call this an Array of Structs (AoS) design,
//! though in Zig "Slice of Structs" would be a more correct name, because we'd be
//! storing a list where each entry in the list stores the whole struct contiguously.
//!
//! Alternatively, we could use MultiArrayList, where the list is split into
//! `Struct.fields.len` segments, each storing all the values of a certain field
//! contiguously. We'd call this a Struct of Arrays (SoA) design, which is
//! also a misnomer when applied to Zig. :^)
//!
//! This is a little odd to wrap one's head around at first, so here's a diagram
//! of how each design looks in memory with the example struct mentioned above:
//!
//! ArrayList (AoS):      { {aaaaaaaabbbbbbbbbbbbbbbb} {aaaaaaaabbbbbbbbbbbbbbbb} {aaaaaaaabbbbbbbbbbbbbbbb} }
//! MultiArrayList (SoA): { {aaaaaaaa} {aaaaaaaa} {aaaaaaaa} {bbbbbbbbbbbbbbbb} {bbbbbbbbbbbbbbbb} {bbbbbbbbbbbbbbbb} }
//!
//! Both example lists show three entries and each letter represents a bit of memory for
//! that field. Note that this diagram is simplified, and that we do not represent
//! any padding that may be introduced by the compiler.
//!
//! When to use:
//! - You only access certain fields most of the time, and loading
//!   the entire struct would be a waste
//! - You want to help the compiler autovectorize / perform some
//!   manual vectorization using Zig's SIMD features
//!
//! When not to use:
//! - If you're always accessing every field in your list entries,
//!   then you won't find much use in MultiArrayLists

const std = @import("std");

pub const Player = struct {
    name: []const u8,
    health: u16,
};

const PlayerList = std.MultiArrayList(Player);

test {
    const allocator = std.testing.allocator;

    var players = PlayerList{};
    defer players.deinit(allocator);

    try players.append(allocator, .{ .name = "Auguste", .health = 100 });
    try players.append(allocator, .{ .name = "Techatrix", .health = 125 });
    try players.append(allocator, .{ .name = "ZLS Premium User", .health = 50_000 });

    // We're about to call `.items(...)` a bunch,
    // so we can save some performance by
    // calling `.slice()` and calling `.items(...)`
    // on that instead.
    var slice = players.slice();

    // I just want to increase every player's health!
    // This pattern allows LLVM to easily autovectorize
    // this modification code; I challenge you to look
    // at this in Compiler Explorer! :)
    for (slice.items(.health)) |*health| {
        health.* += 10;
    }

    // Let's access both fields and see where our players'
    // health is at now!
    for (slice.items(.name), slice.items(.health)) |name, health| {
        std.debug.print("{s} has {d} health!\n", .{ name, health });
    }
}
