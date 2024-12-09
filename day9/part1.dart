import 'dart:io';

void main(List<String> args) {
  final input = File('real_input');

  final nums = input.readAsLinesSync()[0].split('');

  final disk = <int>[];
  for (int i = 0; i < nums.length; i++) {
    disk.addAll(List.filled(int.parse(nums[i]), i % 2 == 0 ? i ~/ 2 : -1));
  }
  print(disk);

  int left = 0;
  int right = disk.length - 1;

  while (left < right) {
    if (disk[left] != -1) {
      left++;
      continue;
    }

    while (disk[right] == -1) right--;
    if (left >= right) break;

    disk[left] = disk[right];
    disk[right] = -1;

    left++;
  }

  print(disk);

  int checksum = 0;
  for (int i = 0; i < disk.length; i++) {
    if (disk[i] == -1) break;

    checksum += i * disk[i];
  }

  print(checksum);
}
