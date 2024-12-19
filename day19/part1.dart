import 'dart:io';

final test = false;

List<String> towels = [];

Map<String, List<String>> possible = {};
Map<String, bool> impossible = {};

void main(List<String> args) {
  final input =
      File(test ? 'test_input' : 'real_input').readAsStringSync().split('\n\n');

  towels = input.first.split(', ').toList();
  final patterns = input.last.split('\n').where((e) => e.isNotEmpty).toList();

  int total = 0;
  for (final pattern in patterns) {
    if (findMatch(pattern) != null) total++;
  }
  print(total);
}

List<String>? findMatch(String pattern) {
  if (pattern.isEmpty) return [];

  if (impossible.containsKey(pattern)) return null;
  if (possible.containsKey(pattern)) return possible[pattern];
  for (final towel in towels) {
    if (pattern.startsWith(towel)) {
      final a = findMatch(pattern.substring(towel.length));
      if (a != null) {
        possible[pattern] = [towel, ...a];
        return [towel, ...a];
      }
    }
  }

  impossible[pattern] = true;
  return null;
}
