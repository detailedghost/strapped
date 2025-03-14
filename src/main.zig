const std = @import("std");
const str = @import("./strUtils.zig");
const heap = std.heap;
const print = std.debug.print;

fn help() void {
    print(
        \\Strapped - don't do databases without the best tools.
        \\
        \\Commands: 
        \\  -h / --help = show help menu
        \\
    , .{});
    std.process.exit(0);
}

const CliOptions = struct { help: bool = false };
const CliErrOptions = error{ NoArgs, SysIssue };

fn processArgs(allocator: std.mem.Allocator) CliErrOptions!CliOptions {
    var opts: CliOptions = .{};

    const args = std.process.argsAlloc(allocator) catch {
        return error.SysIssue;
    };

    defer std.process.argsFree(allocator, args);

    for (args[1..]) |item| {
        if (str.eq(item, "-h") or str.eq(item, "--help")) {
            opts.help = true;
            break;
        }
    }

    return opts;
}

pub fn main() !void {
    var gpa = heap.DebugAllocator(.{}).init;
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();
    const opts = processArgs(allocator) catch |err| switch (err) {
        CliErrOptions.NoArgs => {
            print("No arguments provided!", .{});
            return std.process.exit(1);
        },
        CliErrOptions.SysIssue => {
            print("Parsing issue", .{});
            return std.process.exit(1);
        },
    };

    if (opts.help) help();
}
