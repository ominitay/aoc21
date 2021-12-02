const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;
const Str = []const u8;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("../data/day02.txt");

const Direction = enum {
    forward,
    down,
    up,
};

pub fn main() !void {
    var input = tokenize(u8, data, "\n");
    var distance: usize = 0;
    var depth: usize = 0;
    var depth2: usize = 0;
    while (input.next()) |line| {
        if (line.len == 0) break;
        const space_index = indexOf(u8, line, ' ').?;
        const direction = std.meta.stringToEnum(Direction, line[0..space_index]).?;
        const value = try parseInt(usize, line[space_index + 1 .. line.len], 10);
        switch (direction) {
            .up => depth -= value,
            .down => depth += value,
            .forward => {
                distance += value;
                depth2 += value * depth;
            },
        }
    }
    print("Part 1: {d}\n", .{distance * depth});
    print("Part 2: {d}\n", .{distance * depth2});
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
