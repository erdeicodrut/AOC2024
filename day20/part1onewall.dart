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

final map = <List<int>>[];
Point<int> startLocation = Point(0, 0);

int maxSteps = -1;
int total = 0;
List<Point<int>> cheats = [];

void main(List<String> args) {
  readInput();
  printMap();

  findPath();

  findCheats();
  print(total);
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
      print('${current.$2}');
      printMap(current.$3);
      maxSteps = current.$2;
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
      if (map[i][j] != WALL) continue;
      if (map[i + UP.x][j + UP.y] != WALL &&
          map[i + DOWN.x][j + DOWN.y] != WALL) {
        final saving =
            (map[i + UP.x][j + UP.y] - map[i + DOWN.x][j + DOWN.y]).abs() - 2;

        if (saving >= (test ? 0 : 100)) {
          total++;
        }
      }
      if (map[i + LEFT.x][j + LEFT.y] != WALL &&
          map[i + RIGHT.x][j + RIGHT.y] != WALL) {
        final saving =
            (map[i + LEFT.x][j + LEFT.y] - map[i + RIGHT.x][j + RIGHT.y])
                    .abs() -
                2;

        if (saving >= (test ? 0 : 100)) {
          total++;
        }
      }
    }
  }
}

void printMap([List<Point<int>>? path, Point<int>? cheats]) {
  String mapS = '';
  for (var i = 0; i < map.length; i++) {
    for (var j = 0; j < map.first.length; j++) {
      if (cheats != null && cheats == Point(i, j))
        mapS += '🐮';
      else if (path != null && path.contains(Point(i, j)))
        mapS += '🔴';
      else
        mapS += map[i][j] != WALL ? '🟨' : '🟫';
    }
    mapS += '\n';
  }
  mapS += '\n';
  print(mapS);
}
