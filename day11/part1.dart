import 'dart:io';
import 'dart:math';

void main(List<String> args) {
  final input = File('real_input')
      .readAsLinesSync()
      .first
      .split(' ')
      .map(int.parse)
      .toList();

  Node? list;
  Node? lastCreated;

  for (int i = 0; i < input.length; i++) {
    final node = Node(input[i], null);
    if (list == null)
      list = node;
    else {
      lastCreated!.next = node;
    }
    lastCreated = node;
  }

  for (int step = 1; step <= 75; step++) {
    Node? current = list;

    while (current != null) {
      final digitNumber = tensPow(current.value);

      if (current.value == 0) {
        current.value = 1;
      } else if (digitNumber % 2 == 0) {
        final left = current.value ~/ pow(10, digitNumber ~/ 2);
        final right = (current.value % pow(10, digitNumber ~/ 2)).toInt();

        current.value = left;
        final rightNode = Node(right, current.next);
        current.next = rightNode;

        current = current.next;
      } else {
        current.value *= 2024;
      }

      current = current?.next;
    }
  }

  print(list!.length);
}

// Linked list sim
class Node {
  Node? next;
  int value;

  Node(this.value, this.next);

  int get length {
    int length = 1;
    Node? current = next;
    while (current != null) {
      length++;
      current = current.next;
    }
    return length;
  }

  @override
  String toString() {
    if (next != null) {
      return '$value -> $next';
    }
    return '$value';
  }
}

int tensPow(int b) {
  int zeros = 0;

  int num = b ~/ 1;

  while (num > 0) {
    zeros++;
    num ~/= 10;
  }
  return zeros;
}
