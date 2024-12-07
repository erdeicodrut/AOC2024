import 'dart:io';

void main(List<String> args) {
  // final input = File('test_input');
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

bool isPossible(int left, List<int> right) {
  if (right.length == 1) return right[0] == left;

  return isPossible(left, [right[0] + right[1], ...right.skip(2)]) ||
      isPossible(left, [right[0] * right[1], ...right.skip(2)]);
}
