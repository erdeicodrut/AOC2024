import 'dart:io';
import 'dart:math';

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
const EMPTY = 0;
const WALL = 1;
const START = 3;
const END = 4;

const bool test = true;

final map = <List<int>>[];
Point<int> startLocation = Point(0, 0);

int maxSteps = -1;
int total = -1;
List<List<Point<int>>> cheats = [];

void main(List<String> args) {
  readInput();
  printMap();
  // find normal path
  findPath(startLocation, [startLocation], 0, [startLocation]);
  print(maxSteps);

  total = 0;
  findPath(startLocation, [startLocation], 0);
  print(cheats);
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

void findPath(
  Point<int> pos,
  List<Point<int>> visited,
  int steps, [
  List<Point<int>> cheated = const [],
]) {
  if (map[pos.x][pos.y] == END) {
    if (maxSteps == -1) maxSteps = steps;
    if (steps < maxSteps && cheats.where((e) => equals(e, cheated)).isEmpty) {
      cheats.add(cheated);
      print(maxSteps - steps);
      printMap(visited, cheated);
    }
    return;
  }
  for (final d in directions) {
    final next = pos + d;
    if (visited.contains(next)) continue;
    if (!(next.x >= 0 &&
        next.y >= 0 &&
        next.x < map.length &&
        next.y < map.first.length)) continue;

    final List<Point<int>> v = [...visited, next];
    if (map[next.x][next.y] != WALL) {
      findPath(next, v, steps + 1, cheated);
    } else if (cheated.isEmpty) {
      for (final d in directions) {
        final n = next + d;
        if (v.contains(n)) continue;
        if (!(n.x >= 0 &&
            n.y >= 0 &&
            n.x < map.length &&
            n.y < map.first.length)) continue;

        findPath(n, [...v, n], steps + 2, [next, n]);
      }
    }
  }
}

bool equals(List<Point<int>> a, List<Point<int>> b) {
  return (a[0] == b[1] && a[1] == b[0]) || (a[0] == b[0] && a[1] == b[1]);
}

void printMap([List<Point<int>>? path, List<Point<int>> cheats = const []]) {
  String mapS = '';
  for (var i = 0; i < map.length; i++) {
    for (var j = 0; j < map.first.length; j++) {
      if (cheats.contains(Point(i, j)))
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
