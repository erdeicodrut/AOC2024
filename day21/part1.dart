import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:trotter/trotter.dart';

const UP = Point(-1, 0);
const DOWN = Point(1, 0);
const RIGHT = Point(0, 1);
const LEFT = Point(0, -1);
const List<Point<int>> directions = [
  UP,
  DOWN,
  RIGHT,
  LEFT,
];

const bool test = false;

void main(List<String> args) {
  final codes = File(test ? 'test_input' : 'real_input').readAsLinesSync();

  final robots = [
    NumericalRobot(),
    DirectionalRobot(),
    DirectionalRobot(),
  ];

  int total = 0;

  for (final code in codes) {
    String finalMoves = '';
    for (var moveFor0 in code.split('')) {
      final moves = robots[0].getPathTo(moveFor0);

      final perms =
          Permutations(moves.length, moves.mapIndexed((e, a) => e).toList())()
              .map((e) => e.map((a) => moves[a]).toList())
              .toList();

      List<List<String>> p = [];
      for (var i = 0; i < perms.length; i++) {
        if (p.where((e) => ListEquality().equals(e, perms[i])).isEmpty) {
          p.add(perms[i]);
        }
      }

      String neededForDigit = '';

      final initialPosition0 = robots[0].hand;
      final initialPosition1 = robots[1].hand;
      final initialPosition2 = robots[2].hand;

      for (var perm in p) {
        robots[0].moveTo(initialPosition0);
        robots[1].moveTo(initialPosition1);
        robots[2].moveTo(initialPosition2);

        String permSolution = '';
        if (!robots[0].validate(perm)) continue;

        for (var moveFor1 in [...perm, 'A']) {
          final moves = robots[1].getPathTo(moveFor1);

          if (!robots[1].validate(moves)) continue;

          for (var moveFor2 in [...moves, 'A']) {
            final moves = robots[2].getPathTo(moveFor2);

            if (!robots[2].validate(moves)) continue;

            permSolution += [...moves, 'A'].fold('', (acc, e) => acc + e);

            robots[2].execute(moves);

            // print('\t\t${[...moves, 'A']}');
            // finalMoves += [...moves, 'A'].fold('', (acc, e) => acc + e);
          }

          robots[1].execute(moves);

          // print('\t${[...moves, 'A']}');
        }

        // * int.parse(code.replaceAll('A', ''))

        if (neededForDigit.isEmpty ||
            permSolution.length + 1 < neededForDigit.length) {
          neededForDigit = permSolution;
        }
      }
      finalMoves += neededForDigit;

      robots[0].execute(moves);
    }
    print(finalMoves);
    total += finalMoves.length * int.parse(code.replaceAll('A', ''));
  }
  print(total);
}

final numericKeypad =
    '789\n456\n123\nx0A'.split('\n').map((e) => e.split('').toList()).toList();

final directionalKeypad =
    'x^A\n<v>'.split('\n').map((e) => e.split('').toList()).toList();

class Robot {
  Point<int> hand;

  Robot(this.hand);

  void moveTo(Point<int> a) => hand = a;

  List<String> getPathTo(String c) => [];
  void execute(List<String> c) {
    for (var command in c) {
      switch (command) {
        case '^':
          hand += UP;
          break;
        case 'v':
          hand += DOWN;
          break;
        case '>':
          hand += RIGHT;
          break;
        case '<':
          hand += LEFT;
          break;
      }
    }
  }

  bool validate(List<String> c) => false;
}

class NumericalRobot extends Robot {
  NumericalRobot() : super(Point(3, 2));

  @override
  List<String> getPathTo(String c) {
    List<String> moves = [];
    Point<int> destination = Point(0, 0);

    for (var i = 0; i < numericKeypad.length; i++) {
      for (var j = 0; j < numericKeypad.first.length; j++) {
        if (numericKeypad[i][j] == c) {
          destination = Point(i, j);
        }
      }
    }

    if (destination.y > hand.y)
      moves.addAll(List.filled(destination.y - hand.y, '>'));
    if (destination.x < hand.x)
      moves.addAll(List.filled(hand.x - destination.x, '^'));
    if (destination.y < hand.y)
      moves.addAll(List.filled(hand.y - destination.y, '<'));
    if (destination.x > hand.x)
      moves.addAll(List.filled(destination.x - hand.x, 'v'));

    return moves;
  }

  @override
  bool validate(List<String> c) {
    Point<int> newHand = hand;
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
      if (numericKeypad[newHand.x][newHand.y] == 'x') return false;
    }
    return true;
  }
}

class DirectionalRobot extends Robot {
  DirectionalRobot() : super(Point(0, 2));

  @override
  List<String> getPathTo(String c) {
    List<String> moves = [];
    Point<int> destination = Point(0, 0);

    for (var i = 0; i < directionalKeypad.length; i++) {
      for (var j = 0; j < directionalKeypad.first.length; j++) {
        if (directionalKeypad[i][j] == c) {
          destination = Point(i, j);
        }
      }
    }

    if (destination.y > hand.y)
      moves.addAll(List.filled(destination.y - hand.y, '>'));
    if (destination.x > hand.x)
      moves.addAll(List.filled(destination.x - hand.x, 'v'));
    if (destination.y < hand.y)
      moves.addAll(List.filled(hand.y - destination.y, '<'));
    if (destination.x < hand.x)
      moves.addAll(List.filled(hand.x - destination.x, '^'));

    return moves;
  }

  @override
  bool validate(List<String> c) {
    Point<int> newHand = hand;
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
      if (directionalKeypad[newHand.x][newHand.y] == 'x') return false;
    }
    return true;
  }
}
