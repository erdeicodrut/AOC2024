import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';

final test = false;

int A = 0, B = 0, C = 0, pointer = 0;
List<int> program = [];
List<int> output = [];

void main(List<String> args) {
  final input = File(test ? 'test_input' : 'real_input').readAsLinesSync();

  A = int.parse(input[0].split("Register A: ").last);
  B = int.parse(input[1].split("Register B: ").last);
  C = int.parse(input[2].split("Register C: ").last);
  program =
      input.last.split("Program: ").last.split(',').map(int.parse).toList();
  // int a = 80179000000;
  int a = 8;
  while (true) {
    // if (a % 1000000 == 0)
    stdout.write('$a --> ');

    if (runProgram(a)) {
      print("Success: $a");
      return;
    }
    a *= 8;
    if (a > 1e15) return;
  }
}

bool runProgram(int A) {
  int a = A;
  int b = B;
  int c = C;
  int pointer = 0;
  List<int> out = [];

  if (test) printProgram(out, a, b, c);
  while (pointer < program.length) {
    switch (program[pointer]) {
      case 0: // adv
        a = a ~/ pow(2, combo(program[pointer + 1], a, b, c));
        break;
      case 1: // bxl
        b = b ^ program[pointer + 1];
        break;
      case 2: // bst
        b = combo(program[pointer + 1], a, b, c) % 8;
        break;
      case 3: // jnz
        if (a != 0) {
          pointer = program[pointer + 1];
          if (test) print("jnz $pointer");
          continue;
        }
        break;
      case 4: // bxc
        b = b ^ c;
        break;
      case 5: // out
        out.add(combo(program[pointer + 1], a, b, c) % 8);
        if (out.last != program[out.length - 1]) {
          print(out);
          return false;
        }
        break;
      case 6: // bdv
        b = a ~/ pow(2, combo(program[pointer + 1], a, b, c));
        break;
      case 7: // cdv
        c = a ~/ pow(2, combo(program[pointer + 1], a, b, c));
        break;
      default: // oh noo, anyway
        return false;
    }

    pointer += 2;
    if (test) printProgram(out, a, b, c);
  }
  print(out);
  return ListEquality().equals(out, program);
}

int combo(int operand, int A, int B, int C) => switch (operand) {
      0 || 1 || 2 || 3 => operand,
      4 => A,
      5 => B,
      6 => C,
      _ => exit(4),
    };

void printProgram(List<int> output, int A, int B, int C) {
  print("Register A: $A");
  print("Register B: $B");
  print("Register C: $C");
  print("");
  print("Program: ${program.skip(pointer)}");
  String p = output.fold(" ", (acc, e) => acc += "$e,");
  print("Output: ${p.substring(0, p.length - 1)}");
  print("");
  print("");
}
