import 'dart:io';
import 'dart:math';

int rowNo = -1;
int colNo = 0;

void main(List<String> args) {
  final input = File('real_input');

  final antennas = <String, List<Point>>{};

  final lines = input.readAsLinesSync();

  colNo = lines[0].length - 1;
  for (final line in lines) {
    rowNo++;
    final row = line.split('');

    for (int i = 0; i < row.length; i++) {
      if (row[i] == '.') continue;
      if (!antennas.containsKey(row[i])) antennas[row[i]] = [];
      antennas[row[i]]!.add(Point(rowNo, i));
    }
  }

  // finding antinodes
  final antinodes = <Point>{};
  for (final points in antennas.values) {
    for (int i = 0; i < points.length - 1; i++) {
      for (int j = i + 1; j < points.length; j++) {
        antinodes.addAll(
          getAntinodes(points[i], points[j]).where(
              (e) => e.x >= 0 && e.x <= rowNo && e.y >= 0 && e.y <= colNo),
        );
      }
    }
  }
  print(antinodes.length);
}

Set<Point> getAntinodes(Point a, Point b) {
  final Set<Point> points = {};
  for (int i = 0; i <= rowNo; i++) {
    for (int j = 0; j <= colNo; j++) {
      if (isCollinear(a, b, Point(i, j))) points.add(Point(i, j));
    }
  }
  return points;
}

bool isCollinear(Point a, Point b, Point c) =>
    ((b.x - a.x) * (c.y - a.y) - (c.x - a.x) * (b.y - a.y)).abs() < 0.001;
