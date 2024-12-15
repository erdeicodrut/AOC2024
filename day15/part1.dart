import 'dart:io';
import 'dart:math';

const test = false;

final map = <List<int>>[];
Point<int> robot = Point(0, 0);

const List<Point<int>> directions = [
  Point(-1, 0),
  Point(1, 0),
  Point(0, 1),
  Point(0, -1),
];

const EMPTY = 0;
const WALL = 1;
const BOX = 2;

void main(List<String> args) {
  final input =
      File(test ? 'test_input' : 'real_input').readAsStringSync().split('\n\n');
  final mapLines = input.first.split('\n');

  for (final line in mapLines) {
    map.add(line.split('').map((e) {
      switch (e) {
        case '#':
          return WALL;
        case 'O':
          return BOX;
        case '@':
          robot = Point(mapLines.indexOf(line), line.indexOf('@'));
          return EMPTY;
        default:
          return EMPTY;
      }
    }).toList());
  }

  final movements =
      input.last.replaceAll('\n', '').split('').map((e) => switch (e) {
            '^' => directions[0],
            'v' => directions[1],
            '>' => directions[2],
            _ => directions[3],
          });

  for (final movement in movements) {
    move(movement);
  }

  int total = 0;
  for (int i = 0; i < map.length; i++) {
    for (int j = 0; j < map.first.length; j++) {
      if (map[i][j] == BOX) {
        total += i * 100 + j;
      }
    }
  }
  print(total);
}

void move(Point<int> movement) {
  final nextPosition = robot + movement;

  if (map[nextPosition.x][nextPosition.y] == EMPTY) {
    robot = nextPosition;
    return;
  }

  if (map[nextPosition.x][nextPosition.y] == WALL) {
    return;
  }

  // we got box
  Point<int> pos = nextPosition;
  do {
    if (map[pos.x][pos.y] != BOX) break;

    pos = pos + movement;
  } while (map[pos.x][pos.y] != WALL);

  if (map[pos.x][pos.y] == WALL) return;

  map[nextPosition.x][nextPosition.y] = EMPTY;
  robot = nextPosition;
  map[pos.x][pos.y] = BOX;
}
