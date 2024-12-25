import 'dart:io';

const test = true;
const iterations = 2000000000;

void main(List<String> args) {
  final seeds = File(test ? 'test_input' : 'real_input')
      .readAsLinesSync()
      .map(int.parse)
      .toList();

  int total = 0;
  for (var seed in seeds) total += getNext(seed).elementAt(iterations - 1);
  print(total);
}

Iterable<int> getNext(int seed) sync* {
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
    s = s9;
    yield s9;
  }
}
