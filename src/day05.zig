const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;
const Str = []const u8;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("../data/day05.txt");

const Coordinates = struct {
    x: isize,
    y: isize,
};

const Line = struct {
    a: Coordinates,
    b: Coordinates,
};

const VentMap = struct {
    array: [1000][1000]usize = std.mem.zeroes([1000][1000]usize),
    count: usize = 0,

    pub fn mark(self: *VentMap, x: usize, y: usize) !void {
        self.array[x][y] += 1;
        if (self.array[x][y] == 2) self.count += 1;
    }
};

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(gpa);
    const allocator = arena.allocator();

    var lines = blk: {
        var arraylist = std.ArrayList(Line).init(allocator);
        errdefer arraylist.deinit();

        var lines_iter = tokenize(u8, data, "\n");
        while (lines_iter.next()) |line_str| {
            var coords_iter = tokenize(u8, line_str, " ->,");
            try arraylist.append(Line{
                .a = .{ .x = try parseInt(isize, coords_iter.next().?, 10), .y = try parseInt(isize, coords_iter.next().?, 10) },
                .b = .{ .x = try parseInt(isize, coords_iter.next().?, 10), .y = try parseInt(isize, coords_iter.next().?, 10) },
            });
        }

        break :blk arraylist.toOwnedSlice();
    };
    defer allocator.free(lines);

    var map = VentMap{};

    for (lines) |line| {
        if (line.a.y == line.b.y) {
            var x = line.a.x;
            var end = line.b.x;
            var i: i2 = if (x < end) 1 else -1;
            while (x - i != end) : (x += i) {
                try map.mark(@intCast(usize, x), @intCast(usize, line.a.y));
            }
        } else if (line.a.x == line.b.x) {
            var y = line.a.y;
            var end = line.b.y;
            var i: i2 = if (y < end) 1 else -1;
            while (y - i != end) : (y += i) {
                try map.mark(@intCast(usize, line.a.x), @intCast(usize, y));
            }
        }
    }

    print("Part 1: {d}\n", .{map.count});

    for (lines) |line| {
        if (line.a.x != line.b.x and line.a.y != line.b.y) {
            var x = line.a.x;
            var end_x = line.b.x;
            var x_i: i2 = if (x < end_x) 1 else -1;
            var y = line.a.y;
            var end_y = line.b.y;
            var y_i: i2 = if (y < end_y) 1 else -1;
            while (x - x_i != end_x) : ({
                x += x_i;
                y += y_i;
            }) {
                try map.mark(@intCast(usize, x), @intCast(usize, y));
            }
        }
    }

    print("Part 2: {d}\n", .{map.count});
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
