const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;
const Str = []const u8;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("../data/day07.txt");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(gpa);
    const allocator = arena.allocator();

    var crabs = blk: {
        var iter = tokenize(u8, data, ",\n");
        var arraylist = List(isize).init(allocator);
        while (iter.next()) |crab| {
            try arraylist.append(try parseInt(isize, crab, 10));
        }
        break :blk arraylist.toOwnedSlice();
    };
    sort(isize, crabs, {}, comptime asc(isize));

    print("Part 1: {d}\n", .{getFuel1(crabs[crabs.len / 2], crabs)});
    print("Part 2: {d}\n", .{getFuel2(mean(crabs), crabs)});
}

fn mean(slice: []const isize) isize {
    var count: isize = 0;
    for (slice) |item| count += item;
    return @divFloor(count, @intCast(isize, slice.len));
}

fn getFuel1(position: isize, start: []const isize) isize {
    var count: isize = 0;
    for (start) |crab| {
        count += std.math.absInt(position - crab) catch unreachable;
    }
    return count;
}

fn getFuel2(position: isize, start: []const isize) isize {
    var count: isize = 0;
    for (start) |crab| {
        const n = std.math.absInt(position - crab) catch unreachable;
        count += @divFloor(n * (n + 1), 2); // Triangular numbers
    }
    return count;
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
