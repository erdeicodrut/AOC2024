import 'dart:io';

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

    final resultX = int.parse(inputs.first.split('=').last);

    final resultY = int.parse(inputs.last.split('=').last);

    final claw = getCost(resultX, resultY, aX, aY, bX, bY);
    print(claw);

    total += claw.$3;
  }
  print(total);
}

(int, int, int) getCost(
    int prizeX, int prizeY, int aX, int aY, int bX, int bY) {
  final top = prizeY * bX - prizeX * bY;
  final bottom = aY * bX - aX * bY;
  if (top % bottom != 0) return (0, 0, 0);

  final a = top ~/ bottom;
  final b = (prizeX - a * aX) ~/ bX;

  return (a, b, a * 3 + b);
}
