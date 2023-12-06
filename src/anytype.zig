const std = @import("std");

pub fn Contribution(
    comptime Context: type,
    comptime Error: type,
    comptime summarizeFn: fn (context: Context, file: std.fs.File) Error!void,
) type {
    return struct {
        context: Context,

        pub fn summarize(contribution: @This()) Error!void {
            return summarizeFn(contribution.context, std.io.getStdErr());
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

    pub fn contribution(pull_request: PullRequest) Contribution(PullRequest, Error, summarize) {
        return .{ .context = pull_request };
    }
};

test {
    var issue = Issue{ .is_proposal = true };
    const issue_contrib = issue.contribution();

    var pull_request = PullRequest{ .add_count = 25, .delete_count = 50 };
    const pull_request_contrib = pull_request.contribution();

    try issue_contrib.summarize();
    try pull_request_contrib.summarize();
}
