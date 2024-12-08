import 'dart:io';
import 'dart:math';

void main(List<String> args) {
  final input = File('real_input');

  final antennas = <String, List<Point>>{};

  final lines = input.readAsLinesSync();

  int rowNo = -1;
  int colNo = lines[0].length - 1;
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

List<Point> getAntinodes(Point a, Point b) => a.y > b.y
    ? [
        Point(a.x - (b.x - a.x).abs(), a.y + (b.y - a.y).abs()),
        Point(b.x + (a.x - b.x).abs(), b.y - (a.y - b.y).abs()),
        if ((a.x - b.x).abs() % 3 == 0 && (a.y - b.y).abs() % 3 == 0) ...[
          Point(a.x + (b.x - a.x).abs() ~/ 3, a.y - (b.y - a.y).abs() ~/ 3),
          Point(b.x - (a.x - b.x).abs() ~/ 3, b.y + (a.y - b.y).abs() ~/ 3),
        ],
      ]
    : [
        Point(a.x - (b.x - a.x).abs(), a.y - (b.y - a.y).abs()),
        Point(b.x + (a.x - b.x).abs(), b.y + (a.y - b.y).abs()),
        if ((a.x - b.x).abs() % 3 == 0 && (a.y - b.y).abs() % 3 == 0) ...[
          Point(a.x + (b.x - a.x).abs() ~/ 3, a.y + (b.y - a.y).abs() ~/ 3),
          Point(b.x - (a.x - b.x).abs() ~/ 3, b.y - (a.y - b.y).abs() ~/ 3),
        ],
      ];
