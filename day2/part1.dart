import 'dart:io';

void main(List<String> args) {
  final input = File('real_input');

  final lines = input.readAsLinesSync();

  int noOfSafes = 0;

  for (final line in lines) {
    final nums = line.split(' ').map((e) => int.parse(e)).toList();

    final bool increasing = nums[0] < nums[1];
    bool safe = true;
    for (int i = 0; i < nums.length - 1; i++) {
      if ((increasing && nums[i] < nums[i + 1]) ||
          (!increasing && nums[i] > nums[i + 1])) {
      } else {
        safe = false;
        break;
      }
      if ((nums[i] - nums[i + 1]).abs() > 3) {
        safe = false;
        break;
      }
    }
    if (safe) noOfSafes++;
  }

  print(noOfSafes);
}
