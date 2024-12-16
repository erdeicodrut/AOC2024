import 'dart:io';

import 'dart:math';
import 'package:collection/collection.dart';

final bool test = false;

final map = <List<int>>[];
Point<int> startLocation = Point(0, 0);

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

Point<int> getComplementaryDirection(Point<int> dir) => switch (dir) {
      UP => DOWN,
      DOWN => UP,
      LEFT => RIGHT,
      RIGHT => LEFT,
      _ => LEFT
    };

const EMPTY = 0;
const WALL = 1;
const START = 3;
const END = 4;

final nextPositions =
    PriorityQueue<(int, Point<int>, Point<int>, List<Point<int>>)>(
        (a, b) => a.$1 - b.$1);

final visited = <(int, Point<int>, Point<int>)>[];

void main(List<String> args) {
  readInput();

  visited.add((0, startLocation, RIGHT));

  for (final dir in directions) {
    final np = startLocation + dir;
    if (map[np.x][np.y] != WALL) {
      nextPositions.add((dir == RIGHT ? 1 : 1001, np, dir, [np]));
      visited.add((dir == RIGHT ? 1 : 1001, np, dir));
    }
  }

  print(getLowestCost());
}

(int, List<Point<int>>) getLowestCost() {
  while (nextPositions.isNotEmpty) {
    final s = nextPositions.removeFirst();
    // print('$s \t\t${nextPositions.length}');
    if (map[s.$2.x][s.$2.y] == END) {
      printMap(s.$4);
      return (s.$1, s.$4);
    }
    for (final dir in directions) {
      if (dir == getComplementaryDirection(s.$3)) continue;
      final np = s.$2 + dir;
      if (visited
          .where((e) => e.$2 == np && e.$1 < s.$1 && dir == e.$3)
          .isNotEmpty) continue;

      if (map[np.x][np.y] != WALL) {
        nextPositions
            .add((s.$1 + (dir == s.$3 ? 1 : 1001), np, dir, [...s.$4, np]));
        visited.add((s.$1 + (dir == s.$3 ? 1 : 1001), np, dir));
      }
    }
  }

  return (-1, []);
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

void printMap(List<Point<int>> points) {
  String mapstring = '';
  for (int i = 0; i < map.length; i++) {
    for (int j = 0; j < map.length; j++) {
      if (points.where((e) => e.x == i && e.y == j).isNotEmpty)
        mapstring += '🔴';
      else
        mapstring += map[i][j] == 0 ? '🟨' : '🟫';
    }
    mapstring += '\n';
  }
  print('$mapstring\n\n\n');
}
