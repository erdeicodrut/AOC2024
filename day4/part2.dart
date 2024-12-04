import 'dart:io';

void main(List<String> args) {
  final input = File('real_input');

  final lines = input.readAsLinesSync();

  final arr = <String>[];

  for (final line in lines) {
    arr.add(line);
  }
  int total = 0;

  for (int i = 1; i < arr.length - 1; i++) {
    for (int j = 1; j < arr[i].length - 1; j++) {
      if (arr[i][j] != 'A') {
        continue;
      }
      if (arr[i - 1][j - 1] == 'M' &&
          arr[i + 1][j + 1] == 'S' &&
          arr[i - 1][j + 1] == 'M' &&
          arr[i + 1][j - 1] == 'S') {
        total += 1;
      } else if (arr[i - 1][j - 1] == 'M' &&
          arr[i + 1][j + 1] == 'S' &&
          arr[i - 1][j + 1] == 'S' &&
          arr[i + 1][j - 1] == 'M') {
        total += 1;
      } else if (arr[i - 1][j - 1] == 'S' &&
          arr[i + 1][j + 1] == 'M' &&
          arr[i - 1][j + 1] == 'S' &&
          arr[i + 1][j - 1] == 'M') {
        total += 1;
      } else if (arr[i - 1][j - 1] == 'S' &&
          arr[i + 1][j + 1] == 'M' &&
          arr[i - 1][j + 1] == 'M' &&
          arr[i + 1][j - 1] == 'S') {
        total += 1;
      }
    }
  }

  print(total);
}
