import 'dart:io';

void main(List<String> args) {
  final input = File('real_input');

  final left = <int, int>{};
  final right = <int, int>{};

  final lines = input.readAsLinesSync();

  for (final line in lines) {
    final nums = line.split('   ');
    final l = int.parse(nums[0]);
    if (left.containsKey(l)) {
      left[l] = left[l]! + 1;
    } else {
      left[l] = 1;
    }
    final r = int.parse(nums[1]);
    if (right.containsKey(r)) {
      right[r] = right[r]! + 1;
    } else {
      right[r] = 1;
    }
  }

  int total = 0;
  for (final number in left.keys) {
    if (right.containsKey(number)) {
      total += number * left[number]! * right[number]!;
    }
  }

  print(total);
}
