extension ExtendedMap on Map {
  List<String> keysAsStrings() {
    return keys.map((key) => key.toString()).toList();
  }
}

extension FirstKeyListExtension on List<Map<String, dynamic>> {
  List<String> getFirstKeys() {
    return map((map) => map.keys.isEmpty ? '' : map.keys.first).toList();
  }
}

extension FirstValue on List<Map<String, dynamic>> {
  List<String> getFirstValues() {
    return map((map) => map.values.isEmpty ? '' : map.values.first.toString())
        .toList();
  }
}
