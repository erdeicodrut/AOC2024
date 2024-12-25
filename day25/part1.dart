import 'dart:io';

import 'package:trotter/trotter.dart';

const test = false;

typedef Schema = List<int>;

final keys = <Schema>[];
final locks = <Schema>[];

void main(List<String> args) {
  final input = File(test ? 'test_input' : 'real_input').readAsStringSync();

  final schemas = input.split('\n\n');

  for (final schema in schemas) {
    final m = schema.split('\n');
    final isLock = m.first.startsWith('#');

    Schema heights = List.filled(m.first.length, -1);

    for (var i = 0; i < m.length; i++) {
      characters(m[i]).indexed.forEach((e) {
        if (e.$2 == '#') heights[e.$1]++;
      });
    }
    if (isLock)
      locks.add(heights);
    else
      keys.add(heights);
  }

  print(keys);
  print(locks);
  int total = 0;
  for (final k in keys) {
    for (final l in locks) {
      if (k.doesOpen(l)) total++;
    }
  }
  print(total);
}

extension m on Schema {
  bool doesOpen(Schema lock) {
    for (int i = 0; i < this.length; i++) {
      if (this[i] + lock[i] > 5) return false;
    }
    return true;
  }
}
