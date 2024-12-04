import 'dart:io';

void main(List<String> args) {
  final input = File('real_input');

  final lines = input.readAsLinesSync();

  final arr = <String>[];

  for (final line in lines) {
    arr.add(line);
  }
  const xmas = 'XMAS';
  const directions = [
    [-1, -1],
    [-1, 1],
    [1, -1],
    [1, 1],
    [-1, 0],
    [1, 0],
    [0, 1],
    [0, -1],
  ];

  int total = 0;

  for (int i = 0; i < arr.length; i++) {
    for (int j = 0; j < arr[i].length; j++) {
      if (arr[i][j] != xmas[0]) {
        continue;
      }
      final found = <bool>[true, true, true, true, true, true, true, true];
      for (int k = 0; k < directions.length; k++) {
        for (int l = 1; l < xmas.length; l++) {
          final newI = i + l * directions[k][0];
          final newJ = j + l * directions[k][1];

          if (newI < 0 ||
              newI >= arr.length ||
              newJ < 0 ||
              newJ >= arr[newI].length) {
            found[k] = false;
            break;
          }
          if (arr[newI][newJ] != xmas[l]) {
            found[k] = false;
            break;
          }
        }
      }

      total += found.map((e) => e ? 1 : 0).reduce((v, e) => v += e);
    }
  }

  print(total);
}
