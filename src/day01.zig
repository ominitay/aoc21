const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;
const Str = []const u8;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("../data/day01.txt");

pub fn main() !void {
    { // Part 1
        var input = split(u8, data, "\n");
        var previous: usize = (try nextInt(&input)).?;
        var count: usize = 0;
        while (try nextInt(&input)) |current| {
            if (current > previous) {
                count += 1;
            }
            previous = current;
        }

        print("Part 1: {d}\n", .{count});
    }

    { // Part 2
        var input = split(u8, data, "\n");
        var buf = [_]usize{
            (try nextInt(&input)).?,
            (try nextInt(&input)).?,
            (try nextInt(&input)).?,
        };
        var next: usize = 0;
        var sum: usize = undefined;
        var prev_sum: usize = buf[0] + buf[1] + buf[2];
        var count: usize = 0;
        while (try nextInt(&input)) |current| {
            buf[next] = current;
            next += 1;
            next %= buf.len;
            sum = buf[0] + buf[1] + buf[2];
            if (sum > prev_sum) {
                count += 1;
            }
            prev_sum = sum;
        }

        print("Part 2: {d}\n", .{count});
    }
}

fn nextInt(iter: *std.mem.SplitIterator(u8)) !?usize {
    if (iter.next()) |slice| blk: {
        if (slice.len == 0) break :blk;
        return try parseInt(usize, slice, 10);
    }

    return null;
}

// Useful stdlib functions
const tokenize = std.mem.tokenize;
const split = std.mem.split;
const indexOf = std.mem.indexOfScalar;
const indexOfAny = std.mem.indexOfAny;
const indexOfStr = std.mem.indexOfPosLinear;
const lastIndexOf = std.mem.lastIndexOfScalar;
const lastIndexOfAny = std.mem.lastIndexOfAny;
const lastIndexOfStr = std.mem.lastIndexOfLinear;
const trim = std.mem.trim;
const sliceMin = std.mem.min;
const sliceMax = std.mem.max;

const parseInt = std.fmt.parseInt;
const parseFloat = std.fmt.parseFloat;

const min = std.math.min;
const min3 = std.math.min3;
const max = std.math.max;
const max3 = std.math.max3;

const print = std.debug.print;
const assert = std.debug.assert;

const sort = std.sort.sort;
const asc = std.sort.asc;
const desc = std.sort.desc;
