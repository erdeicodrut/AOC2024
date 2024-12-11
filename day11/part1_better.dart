import 'dart:io';
import 'dart:math';

const steps = 75;
final results = <int, Map<int, int>>{};

void main(List<String> args) {
  final input = File('real_input')
      .readAsLinesSync()
      .first
      .split(' ')
      .map(int.parse)
      .toList();

  int total = 0;

  for (int i = 0; i < input.length; i++) {
    total += getLengthForNumber(input[i], steps);
    print(i);
  }

  print(total);
}

int tensPow(int b) {
  int zeros = 0;

  int num = b ~/ 1;

  while (num > 0) {
    zeros++;
    num ~/= 10;
  }
  return zeros;
}

int getLengthForNumber(int value, int stepsRemaining) {
  if (results.containsKey(value) && results[value]!.containsKey(stepsRemaining))
    return results[value]![stepsRemaining]!;

  final l = [value];
  final len = l.length;
  for (int i = 0; i < len; i++) {
    final digitNumber = tensPow(l[i]);

    if (l[i] == 0) {
      l[i] = 1;
    } else if (digitNumber % 2 == 0) {
      final left = l[i] ~/ pow(10, digitNumber ~/ 2);
      final right = (l[i] % pow(10, digitNumber ~/ 2)).toInt();

      l.add(right);
      l[i] = left;
    } else {
      l[i] *= 2024;
    }
  }
  if (stepsRemaining == 1) {
    if (!results.containsKey(value)) results[value] = {};
    results[value]![stepsRemaining] = l.length;
    return l.length;
  }

  final length = l
      .map((e) => getLengthForNumber(e, stepsRemaining - 1))
      .reduce((acc, e) => acc + e);
  if (!results.containsKey(value)) results[value] = {};
  results[value]![stepsRemaining] = length;

  return length;
}
