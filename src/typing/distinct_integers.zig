//! When designing systems in Zig that take indices, it's important to
//! ensure indices are not accidentally mixed up. For example, if I have
//! a list `A` of length 10 and a list `B` of length 20, it is safe to
//! access `A` with any number representing an index into `A`, and `B`
//! with any number representing an index into `B`, but if we were to,
//! for example, access `A` with a number representing an index into `B`,
//! we could access garbage information or cause an out of bounds accesss.
//! 
//! A real world example I've run into while working on ZLS is accidentally
//! swapping `TokenIndex`s and `Ast.Node.Index`s, which are both `= u32`.
//! 
//! ```zig
//! pub fn accessANodeNotDistinct(node_index: u32) void {
//!     // ...
//! }
//! 
//! const token_index_not_a_node: u32 = 10;
//! accessANodeNotDistinct(token_index_not_a_node);
//! 
//! // kabloom!
//! ```
//! 
//! How can we avoid this? Distinct integers!

const std = @import("std");

pub const TokenIndex = enum(u32) {_};
pub const NodeIndex = enum(u32) {_};

pub fn lastToken() TokenIndex {
    return @enumFromInt(0);
}

pub fn lastNode() NodeIndex {
    return @enumFromInt(0);
}

pub fn accessANodeDistinct(node_index: NodeIndex) void {
    // do node things
    _ = node_index;
}

test {
    accessANodeDistinct(lastNode());
    // uncomment the line below this one and the program won't compile:
    // accessANodeDistinct(lastToken());
}
