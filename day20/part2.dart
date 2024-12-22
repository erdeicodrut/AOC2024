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

const bool test = true;

const distance = (test ? 50 : 100);

final map = <List<int>>[];
Point<int> startLocation = Point(0, 0);

int maxSteps = -1;
int total = 0;

const cheatLength = 20;

List<(Point<int>, Point<int>, int)> cheats = [];

void main(List<String> args) {
  readInput();
  printMap();

  findPath();

  findCheats();
  // for (var a in cheats.entries) {
  //   Future.delayed(Duration(milliseconds: a.key))
  //       .then((_) => print('${a.key}: ${a.value.length}'));
  // }
  print(total);

  print(cheats.length);

  cheats.sort((e, x) => x.$3 - e.$3);

  for (var i = 0; i < cheats.length; i++) {
    for (var j = i + 1; j < cheats.length; j++) {
      if (cheats[j].$1 == cheats[i].$1 && cheats[j].$2 == cheats[i].$2) {
        cheats.removeAt(j);
        j--;
      }
    }
  }

  total = 0;
  final gr = groupBy(cheats, (e) => e.$3);
  for (final a in gr.entries) {
    print('${a.key}: ${a.value.length}');
    total += a.value.length;
  }
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
      // on path
      if (map[i][j] < 0) continue;

      for (int x = -cheatLength; x <= cheatLength; x++) {
        for (int y = -cheatLength; y <= cheatLength; y++) {
          if (!(i + x >= 0 &&
              i + x < map.length &&
              j + y >= 0 &&
              j + y < map.first.length)) continue;

          final start = Point(i, j);
          final end = Point(i + x, j + y);

          if (map[end.x][end.y] == WALL) continue;

          for (var di in directions) {
            final endWall = end + di;
            if (map[endWall.x][endWall.y] != WALL) continue;
            for (final d in directions) {
              final startWall = start + d;

              if (map[startWall.x][startWall.y] != WALL) continue;
// make end -> endWall
              // final jump = manhattenDistance(end, startWall) + 1;

              final jump = manhattenDistance(endWall, startWall) + 2;
              if (jump <= cheatLength) {
                final saving = map[end.x][end.y] - map[i][j] - jump;

                if (saving >= distance) {
                  // if (cheats
                  //     .where((e) => e.$1 == start && e.$2 == end)
                  //     .isNotEmpty) continue;
                  cheats.add((start, end, saving));
                  total++;
                }
              }
            }
          }
        }
      }
    }
  }
}

int manhattenDistance(Point<int> a, Point<int> b) =>
    (a.x - b.x).abs() + (a.y - b.y).abs();

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
