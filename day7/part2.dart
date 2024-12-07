import 'dart:io';
import 'dart:math';

void main(List<String> args) {
  final input = File('real_input');

  final lines = input.readAsLinesSync();

  int total = 0;

  for (final line in lines) {
    final sl = line.split(': ');
    final left = int.parse(sl.first);
    final right = sl.last.split(' ').map((e) => int.parse(e)).toList();

    if (isPossible(left, right)) total += left;
  }

  print(total);
}

double log10(num x) => log(x) / ln10;

int concat(int a, int b) {
  final tensPow = (log10(b)).floor() + 1;
  return pow(10, tensPow).floor() * a + b;
}

bool isPossible(int left, List<int> right) {
  if (right.length == 1) return right[0] == left;

  return isPossible(left, [right[0] + right[1], ...right.skip(2)]) ||
      isPossible(left, [right[0] * right[1], ...right.skip(2)]) ||
      isPossible(left, [concat(right[0], right[1]), ...right.skip(2)]);
}
