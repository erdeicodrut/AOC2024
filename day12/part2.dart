import 'dart:io';

const directions = [
  (-1, 0),
  (1, 0),
  (0, 1),
  (0, -1),
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
  for (int i = 0; i < garden.length; i++) {
    for (int j = 0; j < garden[i].length; j++) {
      if (!shadowGarden[i][j]) {
        final region = getRegion(i, j);

        int totalSides = 0;
        for (final direction in directions) {
          final sorted = region.fences.where((e) => e.$2 == direction).toList();
          sorted.sort((a, b) {
            if (direction.$1 == 0) {
              if (a.$1.$2 == b.$1.$2) return a.$1.$1 - b.$1.$1;
              return a.$1.$2 - b.$1.$2;
            }
            if (a.$1.$1 == b.$1.$1) return a.$1.$2 - b.$1.$2;
            return a.$1.$1 - b.$1.$1;
          });

          int sides = 1;
          var lastP = sorted.first;
          for (final p in sorted.skip(1)) {
            if (direction.$2 == 0 &&
                (p.$1.$1 != lastP.$1.$1 || (p.$1.$2 - lastP.$1.$2).abs() != 1))
              sides++;

            if (direction.$2 != 0 &&
                (p.$1.$2 != lastP.$1.$2 || (p.$1.$1 - lastP.$1.$1).abs() != 1))
              sides++;

            lastP = p;
          }
          totalSides += sides;
        }
        cost += region.area * totalSides;
      }
    }
  }
  print(cost);
}

class Region {
  int area;
  List<((int, int), (int, int))> fences;

  Region()
      : area = 1,
        fences = [];
}

Region getRegion(int x, int y) {
  shadowGarden[x][y] = true;
  final region = Region();

  for (final direction in directions) {
    final nX = x + direction.$1;
    final nY = y + direction.$2;
    if (nX >= 0 &&
        nX < garden.length &&
        nY >= 0 &&
        nY < garden.first.length &&
        garden[x][y] == garden[nX][nY]) {
      if (!shadowGarden[nX][nY]) {
        final c = getRegion(nX, nY);
        region.area += c.area;

        region.fences.addAll(c.fences);
      }
    } else {
      region.fences.add(((x, y), (direction.$1, direction.$2)));
    }
  }

  return region;
}
