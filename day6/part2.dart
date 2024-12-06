import 'dart:io';

const directions = [
  [-1, 0],
  [0, 1],
  [1, 0],
  [0, -1]
];

void main(List<String> args) {
  final input = File('real_input');

  final lines = input.readAsLinesSync();

  final initialMap = <List<int>>[];

  var initialGuard = Guard(0, 0, 0);
  var guard = Guard(0, 0, 0);

  final guards = <Guard>[];

  int i = -1;
  for (final line in lines) {
    i++;
    int j = -1;
    initialMap.add(line.split('').map((e) {
      j++;
      switch (e) {
        case '#':
          return 1;
        case '^':
          initialGuard.x = i;
          initialGuard.y = j;
          guard.x = i;
          guard.y = j;
          return 2;
        default:
          return 0;
      }
    }).toList());
  }
  final map = initialMap.map((e) => e.map((e) => e).toList()).toList();
  int total = 0;

  while (guard.x >= 0 &&
      guard.x < map.length &&
      guard.y >= 0 &&
      guard.y < map[0].length) {
    guards.add(guard);
    var newPosition = [
      guard.x + directions[guard.direction][0],
      guard.y + directions[guard.direction][1],
    ];
    while (newPosition[0] >= 0 &&
        newPosition[0] < map.length &&
        newPosition[1] >= 0 &&
        newPosition[1] < map[0].length &&
        map[newPosition[0]][newPosition[1]] == 1) {
      guard.direction = (guard.direction + 1) % 4;
      newPosition = [
        guard.x + directions[guard.direction][0],
        guard.y + directions[guard.direction][1],
      ];
    }
    guard = Guard(newPosition[0], newPosition[1], guard.direction);
  }

  // The inefficientinator.
  final positions = <Guard>[];
  for (final guard in guards.skip(1)) {
    final newMap = initialMap.map((e) => e.map((e) => e).toList()).toList();
    newMap[guard.x][guard.y] = 1;
    final loop = checkLoop(
      initialGuard,
      newMap,
    );
    if (loop && !positions.contains(Guard(guard.x, guard.y, 0)))
      positions.add(Guard(guard.x, guard.y, 0));
  }
  print(positions.length);
}

class Guard {
  int x, y, direction;

  Guard(this.x, this.y, this.direction);

  @override
  String toString() => '$x $y $direction';

  @override
  bool operator ==(Object other) {
    if (other is! Guard) return false;
    if (x != other.x) return false;
    if (y != other.y) return false;
    if (direction != other.direction) return false;
    return true;
  }
}

bool checkLoop(Guard guard_, List<List<int>> map) {
  final guards = <Guard>[];
  Guard guard = Guard(guard_.x, guard_.y, guard_.direction);

  while (guard.x >= 0 &&
      guard.x < map.length &&
      guard.y >= 0 &&
      guard.y < map[0].length) {
    final isLoop = guards.contains(guard);
    if (isLoop) {
      return true;
    }

    guards.add(guard);
    var newPosition = [
      guard.x + directions[guard.direction][0],
      guard.y + directions[guard.direction][1],
    ];
    while (newPosition[0] >= 0 &&
        newPosition[0] < map.length &&
        newPosition[1] >= 0 &&
        newPosition[1] < map[0].length &&
        map[newPosition[0]][newPosition[1]] == 1) {
      guard.direction = (guard.direction + 1) % 4;
      newPosition = [
        guard.x + directions[guard.direction][0],
        guard.y + directions[guard.direction][1],
      ];
    }
    guard = Guard(newPosition[0], newPosition[1], guard.direction);
  }

  return false;
}
