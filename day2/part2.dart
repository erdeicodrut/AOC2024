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
    if (!safe) {
      if (checkSafe(nums)) noOfSafes++;
    }
    if (safe) noOfSafes++;
  }

  print(noOfSafes);
}

bool checkSafe(List<int> nums, [bool deletedOne = false]) {
  final bool increasing = nums[0] < nums[1];
  bool safe = true;
  int i = 0;
  for (; i < nums.length - 1; i++) {
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
  if (!safe && !deletedOne) {
    final withoutOne = nums.skip(1).toList();
    final withoutFirst = nums.take(i).toList()..addAll(nums.skip(i + 1));
    final withoutSecond = nums.take(i + 1).toList()..addAll(nums.skip(i + 2));
    return checkSafe(withoutFirst, true) ||
        checkSafe(withoutSecond, true) ||
        checkSafe(withoutOne, true);
  }

  return safe;
}
