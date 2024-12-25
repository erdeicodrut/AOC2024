import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';

const UP = Point(-1, 0);
const DOWN = Point(1, 0);
const RIGHT = Point(0, 1);
const LEFT = Point(0, -1);
const List<Point<int>> directions = [
  UP,
  DOWN,
  RIGHT,
  LEFT,
];
const EMPTY = -2;
const WALL = -1;
const START = -3;
const END = -4;

const bool test = false;

const distance = (test ? 50 : 100);

final map = <List<int>>[];
Point<int> startLocation = Point(0, 0);

int total = 0;

const cheatLength = 20;

List<(Point<int>, Point<int>, int)> cheats = [];

void main(List<String> args) {
  readInput();

  findPath();

  findCheats();

  print(cheats.length);
}

void readInput() {
  final lines = File(test ? 'test_input' : 'real_input').readAsLinesSync();

  for (final line in lines) {
    map.add(line
        .split('')
        .map((e) => switch (e) {
              '#' => WALL,
              'S' => START,
              'E' => END,
              _ => EMPTY,
            })
        .toList());
    final s = map.last.indexOf(START);
    startLocation = s == -1 ? startLocation : Point(map.length - 1, s);
  }
}

final PriorityQueue<(Point<int>, int, List<Point<int>>)> toVisit =
    PriorityQueue((a, b) => a.$2 - b.$2);

void findPath() {
  final List<Point<int>> visited = [];
  toVisit.clear();

  toVisit.add((startLocation, 0, [startLocation]));

  (Point<int>, int, List<Point<int>>) current = (startLocation, 0, []);

  while (toVisit.isNotEmpty) {
    current = toVisit.removeFirst();
    if (map[current.$1.x][current.$1.y] == END) {
      break;
    }

    for (final d in directions) {
      final next = current.$1 + d;
      if (next.x >= 0 &&
          next.x < map.length &&
          next.y >= 0 &&
          next.y < map.first.length &&
          !visited.contains(next) &&
          map[next.x][next.y] != WALL) {
        toVisit.add((next, current.$2 + 1, [...current.$3, next]));
        visited.add(next);
      }
    }
  }

  for (var i = 0; i < current.$3.length; i++) {
    map[current.$3[i].x][current.$3[i].y] = i;
  }
}

void findCheats() {
  for (int i = 1; i < map.length - 1; i++) {
    for (int j = 1; j < map.first.length - 1; j++) {
      if (map[i][j] < 0) continue;
      final start = Point(i, j);

      for (int x = -cheatLength; x <= cheatLength; x++) {
        for (int y = -cheatLength; y <= cheatLength; y++) {
          if (!(i + x >= 0 &&
              i + x < map.length &&
              j + y >= 0 &&
              j + y < map.first.length)) continue;

          final end = Point(i + x, j + y);

          if (map[end.x][end.y] < 0) continue;

          final jump = manhattenDistance(end, start);
          if (jump <= cheatLength) {
            final saving = map[end.x][end.y] - map[i][j] - jump;

            if (saving >= distance) {
              cheats.add((start, end, saving));
              total++;
            }
          }
        }
      }
    }
  }
}

int manhattenDistance(Point<int> a, Point<int> b) =>
    (a.x - b.x).abs() + (a.y - b.y).abs();
