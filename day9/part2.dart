import 'dart:io';

void main(List<String> args) {
  final input = File('real_input');

  final nums = input.readAsLinesSync()[0].split('').map(int.parse).toList();

  final disk = <Block>[];
  int index = 0;
  for (int i = 0; i < nums.length; i++) {
    disk.add(Block(i % 2 == 0 ? i ~/ 2 : -1, index, nums[i]));
    index += nums[i];
  }

  for (int i = disk.length - 1; i >= 0; i--) {
    if (disk[i].id == -1) continue;
    final si = disk.indexWhere(
      (e) =>
          e.id == -1 &&
          e.size >= disk[i].size &&
          e.startingIndex < disk[i].startingIndex,
    );
    if (si == -1) continue;

    final space = disk[si];
    final block = Block(disk[i].id, space.startingIndex, disk[i].size);
    disk[si] = block;

    disk[i] = Block(-1, disk[i].startingIndex, disk[i].size);
    if (space.size > block.size) {
      disk.insert(si + 1,
          Block(-1, block.startingIndex + block.size, space.size - block.size));
      i++;
    }
  }

  int checksum = 0;
  for (int i = 0; i < disk.length; i++) {
    checksum += disk[i].checksum;
  }

  print(checksum);
}

class Block {
  final int id;
  final int startingIndex;
  final int size;

  const Block(this.id, this.startingIndex, this.size);

  int get checksum {
    if (id == -1) return 0;

    return id * (size * startingIndex + size * (size - 1) ~/ 2);
  }

  @override
  String toString() => '$id $startingIndex $size';
}
