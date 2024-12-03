import 'dart:io';

void main(List<String> args) {
  final input = File('real_input');

  final exp = RegExp(r"(do\(\)|don\'t\(\))|mul\((\d{1,3}),(\d{1,3})\)");

  final lines = input.readAsLinesSync();

  int total = 0;
  bool enabled = true;

  for (final line in lines) {
    final matches = exp.allMatches(line);
    for (final match in matches) {
      if (match.group(1) == 'do()') {
        enabled = true;
        continue;
      } else if (match.group(1) == 'don\'t()') {
        enabled = false;
        continue;
      }

      if (!enabled) {
        continue;
      }

      final l = int.parse(match.group(2)!);
      final r = int.parse(match.group(3)!);

      total += l * r;
    }
  }

  print(total);
}
