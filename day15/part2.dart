import 'dart:io';
import 'dart:math';

const test = false;

final map = <List<int>>[];
Point<int> robot = Point(0, 0);

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
const BOX1 = 2;
const BOX2 = 3;
const ROBOT = 4;

void main(List<String> args) {
  final input =
      File(test ? 'teste' : 'real_input').readAsStringSync().split('\n\n');
  final mapLines = input.first.split('\n');

  for (final line in mapLines) {
    map.add(line
        .split('')
        .map((e) => switch (e) {
              '#' => <int>[WALL, WALL],
              'O' => <int>[BOX1, BOX2],
              '@' => <int>[ROBOT, EMPTY],
              _ => <int>[EMPTY, EMPTY],
            })
        .fold<List<int>>([], (list, e) => list..addAll(e)).toList());
  }

  for (int i = 0; i < map.length; i++) {
    for (int j = 0; j < map.first.length; j++) {
      if (map[i][j] == ROBOT) {
        robot = Point(i, j);
        map[i][j] = EMPTY;
        break;
      }
    }
    if (robot.x != 0) break;
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
      if (map[i][j] == BOX1) {
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
    pos = pos + movement;
  } while (map[pos.x][pos.y] == BOX1 || map[pos.x][pos.y] == BOX2);

  if (map[pos.x][pos.y] == WALL) return;

  if (movement == UP || movement == DOWN) {
    bool canMove = true;
    if (map[nextPosition.x][nextPosition.y] == BOX1)
      canMove = canMoveVertical(nextPosition, movement);
    else if (map[nextPosition.x][nextPosition.y] == BOX2)
      canMove = canMoveVertical(nextPosition + LEFT, movement);
    if (!canMove) {
      return;
    }
    if (map[nextPosition.x][nextPosition.y] == BOX1)
      moveVertical(nextPosition, movement);
    else if (map[nextPosition.x][nextPosition.y] == BOX2)
      moveVertical(nextPosition + LEFT, movement);
  } else if (movement == RIGHT) {
    for (int i = pos.y; i > nextPosition.y; i--) {
      map[nextPosition.x][i] = map[nextPosition.x][i - 1];
    }
  } else if (movement == LEFT) {
    for (int i = pos.y; i < nextPosition.y; i++) {
      map[nextPosition.x][i] = map[nextPosition.x][i + 1];
    }
  }

  map[nextPosition.x][nextPosition.y] = EMPTY;
  robot = nextPosition;
}

bool canMoveVertical(Point<int> leftBox, Point<int> direction) {
  if (map[leftBox.x][leftBox.y] == EMPTY) return true;
  if (map[leftBox.x][leftBox.y] == WALL) return false;

  final nextPositionL = leftBox + direction;
  final nextPositionR = leftBox + RIGHT + direction;

  if (map[nextPositionL.x][nextPositionL.y] == EMPTY &&
      map[nextPositionR.x][nextPositionR.y] == EMPTY) return true;

  if (map[nextPositionL.x][nextPositionL.y] == WALL ||
      map[nextPositionR.x][nextPositionR.y] == WALL) return false;

  if (map[nextPositionL.x][nextPositionL.y] == BOX2)
    return canMoveVertical(nextPositionL + LEFT, direction) &&
        canMoveVertical(nextPositionR, direction);

  if (map[nextPositionL.x][nextPositionL.y] == BOX1)
    return canMoveVertical(nextPositionL, direction);

  return canMoveVertical(nextPositionR, direction);
}

void moveVertical(Point<int> leftBox, Point<int> direction) {
  final nextPositionL = leftBox + direction;
  final nextPositionR = leftBox + RIGHT + direction;

  if (map[nextPositionL.x][nextPositionL.y] != EMPTY) {
    if (map[nextPositionL.x][nextPositionL.y] == BOX1)
      moveVertical(nextPositionL, direction);
    else
      moveVertical(nextPositionL + LEFT, direction);
  }

  if (map[nextPositionR.x][nextPositionR.y] != EMPTY) {
    moveVertical(nextPositionR, direction);
  }

  map[nextPositionL.x][nextPositionL.y] = map[leftBox.x][leftBox.y];
  map[nextPositionR.x][nextPositionR.y] =
      map[leftBox.x + RIGHT.x][leftBox.y + RIGHT.y];

  map[leftBox.x][leftBox.y] = EMPTY;
  map[leftBox.x + RIGHT.x][leftBox.y + RIGHT.y] = EMPTY;
}
