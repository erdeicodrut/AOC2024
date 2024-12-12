import 'dart:io';

const directions = [
  [-1, 0],
  [1, 0],
  [0, 1],
  [0, -1],
];
final garden = <List<String>>[];
final shadowGarden = <List<bool>>[];

void main(List<String> args) {
  final input = File('real_input');
  final lines = input.readAsLinesSync();

  for (final line in lines) {
    garden.add(line.split(''));
    shadowGarden.add(garden.last.map((_) => false).toList());
  }

  int cost = 0;
  // print(garden);
  for (int i = 0; i < garden.length; i++) {
    for (int j = 0; j < garden[i].length; j++) {
      if (!shadowGarden[i][j]) {
        final region = getRegion(i, j);
        print('$i $j $region');

        cost += region.area * region.perimeter;
      }
    }
  }
  print(cost);
}

class Region {
  int perimeter;
  int area;

  Region()
      : perimeter = 4,
        area = 1;

  @override
  String toString() => '{$perimeter, $area}';
}

Region getRegion(int x, int y) {
  shadowGarden[x][y] = true;
  final region = Region();

  for (final direction in directions) {
    final nX = x + direction[0];
    final nY = y + direction[1];
    if (nX >= 0 &&
        nX < garden.length &&
        nY >= 0 &&
        nY < garden.first.length &&
        garden[x][y] == garden[nX][nY]) {
      if (!shadowGarden[nX][nY]) {
        final c = getRegion(nX, nY);
        region.area += c.area;

        region.perimeter += c.perimeter;
      }
      region.perimeter -= 1;
    }
  }

  return region;
}
