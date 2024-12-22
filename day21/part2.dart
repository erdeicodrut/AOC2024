import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:trotter/trotter.dart';

const bool test = false;

const UP = Point(-1, 0);
const DOWN = Point(1, 0);
const RIGHT = Point(0, 1);
const LEFT = Point(0, -1);

final numericKeypad =
    '789\n456\n123\nx0A'.split('\n').map((e) => e.split('').toList()).toList();

final directionalKeypad =
    'x^A\n<v>'.split('\n').map((e) => e.split('').toList()).toList();

void main(List<String> args) {
  final codes = File(test ? 'test_input' : 'real_input').readAsLinesSync();

  final robots = [
    Robot(Point(3, 2), numericKeypad),
    ...List.filled(25, Robot(Point(0, 2), directionalKeypad)),
  ];
  int total = 0;
  for (var code in codes) {
    List<Path> moves = [characters(code)];
    for (var (i, robot) in robots.indexed) {
      print('robot $i');
      List<Path> nextMove = [];
      print('moves: ${moves.length}');
      for (var move in moves) {
        nextMove.addAll(robot.getPathsForCode(move.toS));
      }
      //take shortest

      final shortestLength =
          nextMove.map((e) => e.length).sorted((a, b) => a - b).first;

      moves.clear();
      moves.addAll(nextMove.where((e) => e.length == shortestLength).toList());
    }

    final shortestLength =
        moves.map((e) => e.length).sorted((a, b) => a - b).first;
    total += shortestLength * int.parse(code.replaceAll('A', ''));
  }

  print(total);
}

typedef Path = List<String>;

extension s on Path {
  String get toS => this.fold('', (acc, e) => acc + e);
}

class Robot {
  final List<List<String>> keypad;
  final Point<int> initialPosition;

  Robot(this.initialPosition, this.keypad);

  List<Path> getPathsForCode(String code) {
    List<Path> p = [];
    Point<int> position = initialPosition;

    for (var (i, c) in characters(code).indexed) {
      // print('\t$c: $i');

      final destination = getDestination(c);
      final movesForC = getPathTo(destination, position);
      if (p.isEmpty) {
        p.addAll(movesForC.map((e) => [...e, 'A']));
      } else {
        final c = combinations(p, movesForC);
        p.clear();
        p.addAll(c.map((e) => [...e, 'A']));
      }
      position = destination;
    }

    final shortestLength = p.map((e) => e.length).sorted((a, b) => a - b).first;

    return p.where((e) => e.length == shortestLength).toList();
  }

  List<Path> getPathTo(Point<int> destination, Point<int> pos) {
    final vertical = <String>[], horizontal = <String>[];

    if (destination.y > pos.y)
      horizontal.addAll(List.filled(destination.y - pos.y, '>'));
    if (destination.x < pos.x)
      vertical.addAll(List.filled(pos.x - destination.x, '^'));
    if (destination.y < pos.y)
      horizontal.addAll(List.filled(pos.y - destination.y, '<'));
    if (destination.x > pos.x)
      vertical.addAll(List.filled(destination.x - pos.x, 'v'));

    if (vertical.isEmpty) return [horizontal];
    if (horizontal.isEmpty) return [vertical];

    final p = <Path>[];

    if (validate([...horizontal, ...vertical], pos))
      p.add([...horizontal, ...vertical]);

    if (validate([...vertical, ...horizontal], pos))
      p.add([...vertical, ...horizontal]);

    return p;
  }

  Point<int> getDestination(String c) {
    Point<int> destination = Point(0, 0);

    for (var i = 0; i < keypad.length; i++) {
      for (var j = 0; j < keypad.first.length; j++) {
        if (keypad[i][j] == c) {
          destination = Point(i, j);
        }
      }
    }
    return destination;
  }

  bool validate(Path c, Point<int> newHand) {
    for (var command in c) {
      switch (command) {
        case '^':
          newHand += UP;
          break;
        case 'v':
          newHand += DOWN;
          break;
        case '>':
          newHand += RIGHT;
          break;
        case '<':
          newHand += LEFT;
          break;
      }
      if (keypad[newHand.x][newHand.y] == 'x') return false;
    }
    return true;
  }
}

List<Path> combinations(List<Path> a, List<Path> b) {
  final result = <Path>[];

  return a
      .map((e) => b.map((f) => [...e, ...f]).toList())
      .flattenedToList
      .toList();

  return result;
}
