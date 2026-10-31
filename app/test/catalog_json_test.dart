import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:genui_gen/genui_gen.dart';
import 'package:genui_playground/genui_catalog.g.dart';

/// Keeps `catalog.json`, the A2UI catalog document of the playground's own
/// components, in step with the widgets. Agents and backends outside the app
/// read the catalog from this file.
///
/// Update it with `flutter test test/catalog_json_test.dart --update-goldens`.
void main() {
  test('catalog.json describes the generated catalog', () {
    final file = File('catalog.json');
    final json =
        '${genUiCatalogJsonString(genUiCatalog, title: 'GenUI Playground', description: 'Custom components of the GenUI Playground.')}\n';
    if (autoUpdateGoldenFiles || !file.existsSync()) {
      file.writeAsStringSync(json);
    }
    expect(file.readAsStringSync(), json);
  });
}
