const std = @import("std");

pub fn eq(first: []const u8, second: []const u8) bool {
    return std.mem.eql(u8, first, second);
}
