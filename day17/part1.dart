import 'dart:io';
import 'dart:math';

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

  printProgram();

  while (pointer < program.length) {
    switch (program[pointer]) {
      case 0: // adv
        A = A ~/ pow(2, combo(program[pointer + 1]));
        break;
      case 1: // bxl
        B = B ^ program[pointer + 1];
        break;
      case 2: // bst
        B = combo(program[pointer + 1]) % 8;
        break;
      case 3: // jnz
        if (A != 0) {
          pointer = program[pointer + 1];
          print("jnz $pointer");
          continue;
        }
        break;
      case 4: // bxc
        B = B ^ C;
        break;
      case 5: // out
        output.add(combo(program[pointer + 1]) % 8);
        break;
      case 6: // bdv
        B = A ~/ pow(2, combo(program[pointer + 1]));
        break;
      case 7: // cdv
        C = A ~/ pow(2, combo(program[pointer + 1]));
        break;
      default: // oh noo, anyway
        exit(4);
    }

    pointer += 2;

    printProgram();
  }
}

int combo(int operand) => switch (operand) {
      0 || 1 || 2 || 3 => operand,
      4 => A,
      5 => B,
      6 => C,
      _ => exit(4),
    };

void printProgram() {
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
