import 'dart:io';

final test = false;

List<String> towels = [];

Map<String, bool> impossible = {};
Map<String, int> possible = {};

void main(List<String> args) {
  final input =
      File(test ? 'test_input' : 'real_input').readAsStringSync().split('\n\n');

  towels = input.first.split(', ').toList();
  final patterns = input.last.split('\n').where((e) => e.isNotEmpty).toList();

  int total = 0;
  for (final pattern in patterns) {
    total += findMatch(pattern);
  }
  print(total);
}

int findMatch(String pattern) {
  if (pattern.isEmpty) return 1;

  int total = 0;
  if (impossible.containsKey(pattern)) return 0;
  if (possible.containsKey(pattern)) return possible[pattern]!;

  for (final towel in towels) {
    if (pattern.startsWith(towel)) {
      total += findMatch(pattern.substring(towel.length));
    }
  }

  if (total == 0)
    impossible[pattern] = true;
  else
    possible[pattern] = total;

  return total;
}
