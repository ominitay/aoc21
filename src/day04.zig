const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;
const Str = []const u8;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("../data/day04.txt");

const Board = struct {
    grid: [25]u8,
    matches: [25]bool = [1]bool{ false } ** 25,

    pub fn create(input: []const u8) !Board {
        var grid = std.mem.zeroes([25]u8);
        var lines = tokenize(u8, input, "\n");
        var i: u8 = 0;
        while (lines.next()) |line| {
            var iter = tokenize(u8, line, " ");
            while (iter.next()) |num| : (i += 1) {
                grid[i] = try parseInt(u8, num, 10);
            }
        }

        return Board{
            .grid = grid,
        };
    }

    pub fn mark(self: *Board, pick: u8) void {
        for (self.grid) |n, i| {
            if (n == pick) {
                self.matches[i] = true;
            }
        }
    }

    pub fn bingo(self: Board) bool {
        { // Check rows
            var i: u8 = 0;
            while (i < 5) : (i += 1) {
                var j: u8 = 0;
                while (j < 5) : (j += 1) {
                    if (!self.matches[i * 5 + j])
                        break;

                    if (j == 4)
                        return true;
                }
            }
        }

        { // Check columns
            var i: u8 = 0;
            while (i < 5) : (i += 1) {
                var j: u8 = 0;
                while (j < 5) : (j += 1) {
                    if (!self.matches[j * 5 + i])
                        break;

                    if (j == 4)
                        return true;
                }
            }
        }
        return false;
    }

    pub fn score(self: Board, pick: u8) usize {
        var sum: usize = 0;
        for (self.grid) |n, i| {
            if (self.matches[i]) continue;
            sum += n;
        }

        return sum * pick;
    }
};

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(gpa);
    defer arena.deinit();
    const allocator = arena.allocator();

    var input = split(u8, data, "\n\n");
    var picks = split(u8, input.next().?, ",");

    const boards = blk: {
        var arraylist = std.ArrayList(?Board).init(allocator);
        errdefer arraylist.deinit();

        while (input.next()) |rawboard|
            try arraylist.append(try Board.create(rawboard));

        break :blk arraylist.toOwnedSlice();
    };
    defer allocator.free(boards);

    var first: ?usize = null;
    var last: usize = undefined;
    while (picks.next()) |pick_str| {
        const pick = try parseInt(u8, pick_str, 10);
        for (boards) |*board| {
            if (board.* != null) {
                board.*.?.mark(pick);

                if (board.*.?.bingo()) {
                    last = board.*.?.score(pick);
                    if (first == null) first = last;
                    board.* = null;
                }
            }
        }
    }

    print("Part 1: {d}\n", .{first});
    print("Part 2: {d}\n", .{last});
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
