import 'dart:io';
import 'dart:math';

const directions = [
  Point(-1, 0),
  Point(1, 0),
  Point(0, 1),
  Point(0, -1),
];

final map = <List<int>>[];

void main(List<String> args) {
  final input = File('real_input');
  final lines = input.readAsLinesSync();

  for (final line in lines) {
    map.add(line.split('').map(int.parse).toList());
  }

  int score = 0;
  for (int i = 0; i < map.length; i++) {
    for (int j = 0; j < map.length; j++) {
      if (map[i][j] == 0) score += findDestinations(Point(i, j)).length;
    }
  }
  print(score);
}

Set<Point> findDestinations(Point<int> start) {
  if (map[start.x][start.y] == 9) return {start};

  Set<Point> nines = {};
  for (final d in directions) {
    final x = start.x + d.x;
    final y = start.y + d.y;

    if (x >= 0 &&
        x < map.length &&
        y >= 0 &&
        y < map.first.length &&
        map[x][y] == map[start.x][start.y] + 1) {
      nines.addAll(findDestinations(Point(x, y)));
    }
  }
  return nines;
}
