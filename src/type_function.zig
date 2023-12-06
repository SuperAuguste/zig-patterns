//! In Zig, types are first class values, which means you can
//! manipulate types like any other value at compile time.
//!
//! This fact is commonly used in Zig to create type functions (or as I like
//! to call them, typefuncs), which are functions that take in compile
//! time values and return a type.
//!
//! Here, we create an an all-encompassing type function, Contribution,
//! that given a summarize function and associated types will call that
//! function with additional logic.
//!
//! Each call to Contribution with unique parameters returns
//! a unique type.

const std = @import("std");

pub fn Contribution(
    comptime Context: type,
    comptime Error: type,
    comptime summarizeFn: fn (context: Context, file: std.fs.File) Error!void,
) type {
    return struct {
        context: Context,

        pub fn summarize(contribution: @This()) Error!void {
            const file = std.io.getStdErr();
            try file.writer().writeAll("Contribution: ");
            return summarizeFn(contribution.context, file);
        }
    };
}

pub const Issue = struct {
    is_proposal: bool,

    const Error = std.fs.File.WriteError;
    pub fn summarize(issue: Issue, file: std.fs.File) Error!void {
        if (issue.is_proposal) {
            try file.writer().writeAll("We don't accept proposals!!!\n");
        } else {
            try file.writer().writeAll("Oh cool, an issue :)\n");
        }
    }

    const C = Contribution(Issue, Error, summarize);
    pub fn contribution(issue: Issue) Contribution(Issue, Error, summarize) {
        return .{ .context = issue };
    }
};

pub const PullRequest = struct {
    add_count: usize,
    delete_count: usize,

    const Error = std.fs.File.WriteError;
    pub fn summarize(pull_request: PullRequest, file: std.fs.File) Error!void {
        try file.writer().print("This PR adds {d} and deletes {d}\n", .{
            pull_request.add_count,
            pull_request.delete_count,
        });
    }

    const C = Contribution(PullRequest, Error, summarize);
    pub fn contribution(pull_request: PullRequest) C {
        return .{ .context = pull_request };
    }
};

/// To accept any value of a type created by Contribution, we cannot
/// simply specify a single type due to Contribution returning unique
/// types for unique inputs.
///
/// Zig's solution to this is `anytype`, which allows you
/// to ducktype. As Contribution(X, Y, Z) returns a type
/// with a "summarize" function regardless of the inputs,
/// so we can simply call summarize on our `contrib` parameter.
///
/// As we call summarizeContrib with both a value of type `Issue.C`
/// and `PullRequest.C`, Zig will create two instances of `summarizeContrib`:
/// `summarizeContrib_Issue_C(contrib: Issue.C) Issue.Error!void` and
/// `summarizeContrib_PullRequest_C(contrib: PullRequest.C) PullRequest.Error!void`
///
/// This adds binary size overhead, especially if you have a lot of `summarizeContrib`
/// calls with different input types, but it removes all runtime overhead relating
/// to virtual calls, which many of the polymorphic examples in this repo use,
/// as Zig will simply replace the `summarizeContrib` call with the correct typed call
/// at compile time.
pub fn summarizeContrib(contrib: anytype) !void {
    try contrib.summarize();
}

test {
    var issue = Issue{ .is_proposal = true };
    const issue_contrib = issue.contribution();

    var pull_request = PullRequest{ .add_count = 25, .delete_count = 50 };
    const pull_request_contrib = pull_request.contribution();

    try summarizeContrib(issue_contrib);
    try summarizeContrib(pull_request_contrib);
}
