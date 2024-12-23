import 'dart:io';

import 'package:collection/collection.dart';

const test = false;

final Map<String, List<String>> links = {};

void main(List<String> args) {
  final rawLinks = File(test ? 'test_input' : 'real_input')
      .readAsLinesSync()
      .map((e) => e.split('-'))
      .map((e) => (e.first, e.last))
      .toList();

  for (var link in rawLinks) {
    if (!links.containsKey(link.$1)) links[link.$1] = [];
    if (!links.containsKey(link.$2)) links[link.$2] = [];

    links[link.$1]!.add(link.$2);
    links[link.$2]!.add(link.$1);
  }

  final networks = <List<String>>[];
  for (var link in links.keys.where((e) => e.startsWith('t'))) {
    for (var i = 0; i < links[link]!.length - 1; i++) {
      for (var j = i + 1; j < links[link]!.length; j++) {
        final l1 = links[link]![i];
        final l2 = links[link]![j];

        if (links[l1]!.contains(l2)) {
          final network = [link, l1, l2].sorted((a, b) => a.compareTo(b));
          if (networks.where((e) => ListEquality().equals(e, network)).isEmpty)
            networks.add(network);
        }
      }
    }
  }
  print(networks.length);
}
