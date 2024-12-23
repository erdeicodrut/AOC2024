import 'dart:io';

import 'package:collection/collection.dart';

const test = false;

final Map<String, Set<String>> links = {};

void main(List<String> args) {
  final rawLinks = File(test ? 'test_input' : 'real_input')
      .readAsLinesSync()
      .map((e) => e.split('-'))
      .map((e) => (e.first, e.last))
      .toList();

  for (var link in rawLinks) {
    if (!links.containsKey(link.$1)) links[link.$1] = {};
    if (!links.containsKey(link.$2)) links[link.$2] = {};

    links[link.$1]!.add(link.$2);
    links[link.$2]!.add(link.$1);
  }

  final networks = <Set<String>>[];
  for (var link in links.entries) {
    for (var node in link.value) {
      final n = <String>{node, link.key};

      for (var node2 in link.value) {
        if (links[node]!.contains(node2)) {
          if (links[node2]!.containsAll(n)) n.add(node2);
        }
      }
      print(n);
      networks.add(n);
    }
  }
  print(networks.length);
  final longest = networks
      .sorted((a, b) => a.length - b.length)
      .last
      .sorted((a, b) => a.compareTo(b));

  print(longest.fold('', (acc, a) => (acc as String) + ',' + a));
}
