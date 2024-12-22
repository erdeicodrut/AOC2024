import 'dart:io';
import 'dart:math';

const test = false;
const iterations = 2000;

final Map<(int, int, int, int), List<int>> seq = {};

void main(List<String> args) {
  final monkeys = File(test ? 'test_input' : 'real_input')
      .readAsLinesSync()
      .map(int.parse)
      .toList();

  for (var (index, seed) in monkeys.indexed) {
    final seller = getNext(seed).take(iterations).toList();

    for (int i = 3; i < iterations; i++) {
      final history = (
        seller[i - 3].$2,
        seller[i - 2].$2,
        seller[i - 1].$2,
        seller[i].$2,
      );
      if (seq.containsKey(history) && seq[history]![index] != 0) continue;
      if (!seq.containsKey(history))
        seq[history] = List.filled(monkeys.length, 0);
      seq[history]![index] = seller[i].$1;
    }
  }

  int bananas = 0;
  for (final entry in seq.entries) {
    final sum = entry.value.reduce((acc, e) => acc + e);

    bananas = max(sum, bananas);
  }

  print(bananas);
}

Iterable<(int, int)> getNext(int seed) sync* {
  int s = seed;
  while (true) {
    final s1 = s * 64;
    final s2 = s ^ s1;
    final s3 = s2 % 16777216;
    final s4 = s3 ~/ 32;
    final s5 = s3 ^ s4;
    final s6 = s5 % 16777216;
    final s7 = s6 * 2048;
    final s8 = s6 ^ s7;
    final s9 = s8 % 16777216;
    yield (s9 % 10, s9 % 10 - s % 10);
    s = s9;
  }
}
