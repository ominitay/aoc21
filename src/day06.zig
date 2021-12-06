const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;
const Str = []const u8;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("../data/day06.txt");

const Fish = struct {
    count: [9]usize = std.mem.zeroes([9]usize),
    offset: u8 = 0,

    pub fn next(self: Fish, days: usize) Fish {
        var new = self;
        var i = days;
        while (i > 0) : (i -= 1) {
            new.count[(new.offset + 7) % 9] += new.count[new.offset];
            new.offset += 1;
            new.offset %= 9;
        }
        return new;
    }

    pub fn total(self: Fish) usize {
        var num: usize = 0;
        for (self.count) |fish| {
            num += fish;
        }
        return num;
    }
};

pub fn main() !void {
    var fish = Fish{};
    var iter = tokenize(u8, data, ",\n");
    while (iter.next()) |slice| {
        const timer = try parseInt(u8, slice, 10);
        fish.count[timer] += 1;
    }

    print("Part 1: {d}\n", .{fish.next(80).total()});
    print("Part 2: {d}\n", .{fish.next(256).total()});
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
