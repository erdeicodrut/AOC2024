import 'dart:io';

void main(List<String> args) {
  final input = File('real_input');

  final left = <int>[];
  final right = <int>[];

  final lines = input.readAsLinesSync();

  for (final line in lines) {
    final nums = line.split('   ');
    left.add(int.parse(nums[0]));
    right.add(int.parse(nums[1]));
  }

  left.sort();
  right.sort();

  int total = 0;

  for (int i = 0; i < left.length; i++) {
    total += (left[i] - right[i]).abs();
  }

  print(total);
}
