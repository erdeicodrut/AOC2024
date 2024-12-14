import 'dart:io';
import 'dart:math';

const test = false;

const width = test ? 11 : 101;
const height = test ? 7 : 103;

const seconds = 100;

final robots = <(Point<int>, Point<int>)>[];

void main(List<String> args) {
  final lines = File(test ? 'test_input' : 'real_input').readAsLinesSync();

  for (final line in lines) {
    final nums = line.split(' ');
    final left = nums.first.split('p=').last.split(',');
    final p = Point(int.parse(left.last), int.parse(left.first));

    final right = nums.last.split('v=').last.split(',');
    final v = Point(int.parse(right.last), int.parse(right.first));

    robots.add((p, v));
  }

  for (int i = 0; i < robots.length; i++) {
    final x = (robots[i].$1.x + seconds * robots[i].$2.x) % height;
    final y = (robots[i].$1.y + seconds * robots[i].$2.y) % width;

    robots[i] = (Point(x, y), robots[i].$2);
  }
  print(getSafetyFactor());
}

void printRobots() {
  for (int i = 0; i < height; i++) {
    if (i == height ~/ 2)
      stdout.write('\n');
    else {
      for (int j = 0; j < width; j++) {
        final l = robots.where((e) => e.$1.x == i && e.$1.y == j).length;
        if (j == width ~/ 2)
          stdout.write(' ');
        else
          stdout.write(l == 0 ? '.' : l.toString());
      }
      stdout.write('\n');
    }
  }
  stdout.write('\n');
}

int getSafetyFactor() {
  int q1 = 0, q2 = 0, q3 = 0, q4 = 0;
  for (int i = 0; i < height ~/ 2; i++) {
    for (int j = 0; j < width ~/ 2; j++) {
      q1 += robots.where((e) => e.$1.x == i && e.$1.y == j).length;
    }
  }
  for (int i = height ~/ 2 + 1; i < height; i++) {
    for (int j = 0; j < width ~/ 2; j++) {
      q2 += robots.where((e) => e.$1.x == i && e.$1.y == j).length;
    }
  }
  for (int i = 0; i < height ~/ 2; i++) {
    for (int j = width ~/ 2 + 1; j < width; j++) {
      q3 += robots.where((e) => e.$1.x == i && e.$1.y == j).length;
    }
  }
  for (int i = height ~/ 2 + 1; i < height; i++) {
    for (int j = width ~/ 2 + 1; j < width; j++) {
      q4 += robots.where((e) => e.$1.x == i && e.$1.y == j).length;
    }
  }
  return q1 * q2 * q3 * q4;
}
