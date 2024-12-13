import 'dart:io';

const adder = 10000000000000;

void main(List<String> args) {
  final input = File('real_input');

  final puzzles = input.readAsStringSync().split('\n\n');
  int total = 0;
  for (final puzzle in puzzles) {
    final lines = puzzle.split("\n");
    print(lines);

    var inputs = lines[0].split(':').last.split(', ');

    final aX = int.parse(inputs.first.split('+').last);
    final aY = int.parse(inputs.last.split('+').last);

    inputs = lines[1].split(':').last.split(', ');

    final bX = int.parse(inputs.first.split('+').last);
    final bY = int.parse(inputs.last.split('+').last);

    inputs = lines[2].split(':').last.split(', ');

    int resultX = int.parse(inputs.first.split('=').last);

    int resultY = int.parse(inputs.last.split('=').last);

//region: part2

    resultX += adder;
    resultY += adder;

//endregion

    final claw = getCost(resultX, resultY, aX, aY, bX, bY);
    print(claw);

    total += claw.$3;
  }
  print(total);
}

(int, int, int) getCost(
    int prizeX, int prizeY, int aX, int aY, int bX, int bY) {
  final top1 = prizeY * bX - prizeX * bY;
  final bottom1 = aY * bX - aX * bY;
  if (top1 % bottom1 != 0) return (0, 0, 0);

  final a1 = top1 ~/ bottom1;
  if ((prizeX - a1 * aX) % bX != 0) return (0, 0, 0);
  final b1 = (prizeX - a1 * aX) ~/ bX;

  return (a1, b1, a1 * 3 + b1);
}
