const std = @import("std");
const Allocator = std.mem.Allocator;
const List = std.ArrayList;
const Map = std.AutoHashMap;
const StrMap = std.StringHashMap;
const BitSet = std.DynamicBitSet;
const Str = []const u8;

const util = @import("util.zig");
const gpa = util.gpa;

const data = @embedFile("../data/day03.txt");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(gpa);
    defer arena.deinit();
    const allocator = &arena.allocator;

    var input = try getInput(allocator);
    defer allocator.free(input);
    const length = input[0].len;
    assert(length != 0);

    { // Part 1
        const counts = try allocator.alloc(isize, length);
        defer allocator.free(counts);
        for (counts) |*digit| digit.* = 0;
        for (input) |line| {
            if (line.len != length) @panic("Inconsistent length");
            for (line) |digit, i| {
                switch (digit) {
                    '1' => counts[i] += 1,
                    '0' => counts[i] -= 1,
                    else => @panic("Invalid digit"),
                }
            }
        }

        var gamma_string = try allocator.alloc(u8, length);
        for (counts) |count, i| {
            if (count > 0) {
                gamma_string[i] = '1';
            } else {
                gamma_string[i] = '0';
            }
        }

        const gamma = try parseInt(usize, gamma_string, 2);
        const epsilon = gamma ^ (std.math.pow(usize, 2, length) - 1);

        const power = gamma * epsilon;

        print("Part 1: {d}\n", .{power});
    }

    { // Part 2
        const o2_generator = try getRating(allocator, input, 1);
        const co2_scrubber = try getRating(allocator, input, 0);

        print("Part 2: {d}\n", .{o2_generator * co2_scrubber});
    }
}

fn getInput(allocator: *Allocator) ![]const []const u8 {
    var input = std.ArrayList([]const u8).init(allocator);
    errdefer input.deinit();
    {
        var iter = split(u8, data, "\n");
        while (iter.next()) |line| {
            if (line.len == 0) break;
            try input.append(line);
        }
    }

    return input.toOwnedSlice();
}

fn getRating(allocator: *Allocator, input: []const []const u8, priority_bit: u1) !usize {
    const length = input[0].len;
    const keep = try allocator.alloc(bool, input.len);
    for (keep) |*b| b.* = true;
    defer allocator.free(keep);
    var keep_count = input.len;

    var i: usize = 0;
    while (i < length and keep_count > 1) : (i += 1) {
        var count: isize = 0;
        for (input) |line, j| {
            if (keep[j] == false) continue;
            switch (line[i]) {
                '1' => count += 1,
                '0' => count -= 1,
                else => @panic("Invalid digit"),
            }
        }

        var j: usize = 0;
        while (j < input.len) : (j += 1) {
            if (keep[j] == false) continue;
            var required_bit: u8 = undefined;
            if (count < 0) {
                if (priority_bit == 1) {
                    required_bit = '0';
                } else {
                    required_bit = '1';
                }
            } else {
                if (priority_bit == 1) {
                    required_bit = '1';
                } else {
                    required_bit = '0';
                }
            }

            if (input[j][i] != required_bit) {
                keep[j] = false;
                keep_count -= 1;
            }
        }
    }

    for (keep) |b, j| {
        if (b) {
            return try parseInt(usize, input[j], 2);
        }
    }

    unreachable;
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
