import 'dart:io';

void main(List<String> args) {
  final input = File('real_input');
  final lines = input.readAsLinesSync();

  final rules = <int, List<int>>{};
  int lineNo = 0;
  for (; lineNo < lines.length; lineNo++) {
    final line = lines[lineNo];
    if (line == '') {
      lineNo++;
      break;
    }

    final nums = line.split('|');

    final l = int.parse(nums.first);
    final r = int.parse(nums.last);

    if (!rules.containsKey(r)) {
      rules[r] = <int>[];
    }

    rules[r]!.add(l);
  }

  int total = 0;
  for (; lineNo < lines.length; lineNo++) {
    final pages = lines[lineNo].split(',').map((e) => int.parse(e)).toList();

    bool correct = true;

    for (int i = 0; i < pages.length - 1 && correct; i++) {
      for (int j = i + 1; j < pages.length && correct; j++) {
        if (rules[pages[i]]?.contains(pages[j]) ?? false) {
          correct = false;
        }
      }
    }
    if (correct) continue;

    pages
        .sort((a, b) => rules.containsKey(a) && rules[a]!.contains(b) ? 1 : -1);

    total += pages[pages.length ~/ 2];
  }

  print(total);
}
