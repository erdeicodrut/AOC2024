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
      if (map[i][j] == 0) score += findPaths(Point(i, j));
    }
  }
  print(score);
}

// returns score for x, y
int findPaths(Point<int> start) {
  if (map[start.x][start.y] == 9) return 1;

  int score = 0;
  for (final d in directions) {
    final x = start.x + d.x;
    final y = start.y + d.y;

    if (x >= 0 &&
        x < map.length &&
        y >= 0 &&
        y < map.first.length &&
        map[x][y] == map[start.x][start.y] + 1) {
      score += findPaths(Point(x, y));
    }
  }
  return score;
}
