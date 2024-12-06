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

  final map = <List<int>>[];
  var guardPosition = [0, 0];
  var guardDirection = 0;

  int i = -1;
  for (final line in lines) {
    i++;
    int j = -1;
    map.add(line.split('').map((e) {
      j++;
      switch (e) {
        case '#':
          return 1;
        case '^':
          guardPosition = [i, j];
          return 2;
        default:
          return 0;
      }
    }).toList());
  }

  int total = 1;

  while (guardPosition[0] >= 0 &&
      guardPosition[0] < map.length &&
      guardPosition[1] >= 0 &&
      guardPosition[1] < map[0].length) {
    if (map[guardPosition[0]][guardPosition[1]] == 0) {
      total++;
      map[guardPosition[0]][guardPosition[1]] = 2;
    }
    var newPosition = [
      guardPosition[0] + directions[guardDirection][0],
      guardPosition[1] + directions[guardDirection][1],
    ];

    while (newPosition[0] >= 0 &&
        newPosition[0] < map.length &&
        newPosition[1] >= 0 &&
        newPosition[1] < map[0].length &&
        map[newPosition[0]][newPosition[1]] == 1) {
      guardDirection = (guardDirection + 1) % 4;
      newPosition = [
        guardPosition[0] + directions[guardDirection][0],
        guardPosition[1] + directions[guardDirection][1],
      ];
    }
    guardPosition = newPosition;
  }

  print(total);
}
