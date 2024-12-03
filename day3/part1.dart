import 'dart:io';

void main(List<String> args) {
  final input = File('real_input');

  final exp = RegExp(r"mul\((\d{1,3}),(\d{1,3})\)");

  final lines = input.readAsLinesSync();

  int total = 0;

  for (final line in lines) {
    final matches = exp.allMatches(line);
    for (final match in matches) {
      final l = int.parse(match.group(1)!);
      final r = int.parse(match.group(2)!);

      total += l * r;
    }
  }

  print(total);
}
