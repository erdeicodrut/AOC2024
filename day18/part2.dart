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

const bool test = false;

final int size = (test ? 6 : 70) + 1;
final List<List<bool>> map = [];

final PriorityQueue<(Point<int>, int, List<Point<int>>)> toVisit =
    PriorityQueue((a, b) => a.$2 - b.$2);

void main(List<String> args) {
  for (var i = 0; i < size; i++) {
    map.add(List.filled(size, true));
  }

  int i = 0;
  for (final byte in addByte()) {
    if (!findPath()) {
      print(byte);
      break;
    }
    print(i++);
    // if (i == (test ? 12 : 1024)) break;
  }
}

Iterable<String> addByte() sync* {
  final input = File(test ? 'test_input' : 'real_input').readAsLinesSync();
  for (final line in input) {
    final coords = line.split(',').map(int.parse).toList();

    map[coords[1]][coords[0]] = false;
    yield line;
  }
}

bool findPath() {
  final List<Point<int>> visited = [];
  toVisit.clear();

  toVisit.add((Point(0, 0), 0, [Point(0, 0)]));

  while (toVisit.isNotEmpty) {
    final current = toVisit.removeFirst();
    if (current.$1.x == size - 1 && current.$1.y == size - 1) {
      print('${current.$2}');
      printMap(current.$3);
      return true;
    }

    for (final d in directions) {
      final next = current.$1 + d;
      if (next.x >= 0 &&
          next.x < size &&
          next.y >= 0 &&
          next.y < size &&
          !visited.contains(next) &&
          map[next.x][next.y]) {
        toVisit.add((next, current.$2 + 1, [...current.$3, next]));
        visited.add(next);
      }
    }
  }
  return false;
}

void printMap([List<Point<int>>? path]) {
  String mapS = '';
  for (var i = 0; i < size; i++) {
    for (var j = 0; j < size; j++) {
      if (path != null && path.contains(Point(i, j)))
        mapS += 'O';
      else
        mapS += map[i][j] ? '.' : "#";
    }
    mapS += '\n';
  }
  mapS += '\n';
  print(mapS);
}
