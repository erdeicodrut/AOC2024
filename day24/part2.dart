import 'dart:io';

import 'package:collection/collection.dart';

const test = false;

final Map<String, (String, String?, bool Function(bool, bool)?, bool?)> wires =
    {};

void main(List<String> args) {
  final input = File(test ? 'larger_input' : 'real_input').readAsStringSync();

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

  final wiresStartWithZ = wires.keys
      .where((e) => e.startsWith('z'))
      .toList()
      .sorted((a, b) => b.compareTo(a));
  String zs = '';
  for (var wire in wiresStartWithZ) {
    evaluate(wire);
    zs += wires[wire]!.$4! ? 1.toString() : 0.toString();
  }

  final wiresStartWithX = wires.keys
      .where((e) => e.startsWith('x'))
      .toList()
      .sorted((a, b) => b.compareTo(a));
  String xs = '';
  for (var wire in wiresStartWithX) {
    evaluate(wire);
    xs += wires[wire]!.$4! ? 1.toString() : 0.toString();
  }
  final wiresStartWithY = wires.keys
      .where((e) => e.startsWith('y'))
      .toList()
      .sorted((a, b) => b.compareTo(a));
  String ys = '';
  for (var wire in wiresStartWithY) {
    evaluate(wire);
    ys += wires[wire]!.$4! ? 1.toString() : 0.toString();
  }

  print(' ' + int.parse(xs, radix: 2).toRadixString(2));
  print(' ' + int.parse(ys, radix: 2).toRadixString(2));
  print(zs);
  // print(int.parse(zs, radix: 2).toRadixString(2));
  print((int.parse(xs, radix: 2) + int.parse(ys, radix: 2)).toRadixString(2));
  final r =
      (int.parse(xs, radix: 2) + int.parse(ys, radix: 2)).toRadixString(2);

  for (int i = 0; i < zs.length; i++) {
    if (r[i] == zs[i]) {
      stdout.write(r[i]);
    } else {
      stdout.write('ø');
    }
  }
}

// Lazy eval for all wires
void evaluate(String wire) {
  final w = wires[wire]!;

  if (w.$4 != null) return;

  if (wires[w.$1]!.$4 == null) evaluate(w.$1);
  if (wires[w.$2]!.$4 == null) evaluate(w.$2!);

  wires[wire] =
      (w.$1, w.$2, w.$3, w.$3!.call(wires[w.$1]!.$4!, wires[w.$2!]!.$4!));
}
