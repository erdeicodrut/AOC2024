import 'dart:io';

import 'package:collection/collection.dart';

const test = false;

final Map<String, (String, String?, bool Function(bool, bool)?, bool?)> wires =
    {};

void main(List<String> args) {
  final input = File(test ? 'test_input' : 'real_input').readAsStringSync();

  final parts = input.split('\n\n');

  for (final p in parts.first.split('\n')) {
    final pa = p.split(': ');
    wires[pa.first] = (pa.last, null, null, int.parse(pa.last) == 1);
  }

  for (final gate in parts.last.split('\n').takeWhile((e) => e.isNotEmpty)) {
    final g = gate.split(' ');
    final bool Function(bool, bool) operation = switch (g[1]) {
      'AND' => (a, b) => a && b,
      'OR' => (a, b) => a || b,
      'XOR' => (a, b) => a ^ b,
      _ => (a, b) => false,
    };

    wires[g.last] = (g[0], g[2], operation, null);
  }

  final zs = wires.keys
      .where((e) => e.startsWith('z'))
      .toList()
      .sorted((a, b) => b.compareTo(a));

  String out = '';

  for (var wire in zs) {
    evaluate(wire);
    out += wires[wire]!.$4! ? 1.toString() : 0.toString();
  }

  print(wires.entries.where((e) => e.value.$4 == null));
  print(out);

  print(int.parse(out, radix: 2));
}

void evaluate(String wire) {
  final w = wires[wire]!;

  if (w.$4 != null) return;

  if (wires[w.$1]!.$4 == null) evaluate(w.$1);
  if (wires[w.$2]!.$4 == null) evaluate(w.$2!);

  wires[wire] =
      (w.$1, w.$2, w.$3, w.$3!.call(wires[w.$1]!.$4!, wires[w.$2!]!.$4!));
}
