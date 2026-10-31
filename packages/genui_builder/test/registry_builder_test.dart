import 'dart:async';

import 'package:build/build.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui_builder/genui_builder.dart';
import 'package:glob/glob.dart';

/// Minimal in-memory [BuildStep] covering what [GenUIRegistryBuilder] uses.
class _FakeBuildStep implements BuildStep {
  _FakeBuildStep(this.sources);

  final Map<String, String> sources;
  final Map<AssetId, String> outputs = {};

  @override
  AssetId get inputId => AssetId('app', r'lib/$lib$');

  @override
  Stream<AssetId> findAssets(Glob glob) => Stream.fromIterable(
    sources.keys
        .where((path) => glob.matches(path))
        .map((path) => AssetId('app', path)),
  );

  @override
  Future<String> readAsString(AssetId id, {Object? encoding}) async =>
      sources[id.path]!;

  @override
  Future<void> writeAsString(
    AssetId id,
    FutureOr<String> contents, {
    Object? encoding,
  }) async {
    outputs[id] = await contents;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('BuildStep.${invocation.memberName}');
}

Future<String?> runRegistry(Map<String, String> sources) async {
  final step = _FakeBuildStep(sources);
  await GenUIRegistryBuilder().build(step);
  return step.outputs[AssetId('app', 'lib/genui_registry.g.dart')];
}

void main() {
  test('collects every annotated class across files', () async {
    final output = await runRegistry({
      'lib/widgets/card.dart': '''
@generativeUI
class ProfileCard extends StatelessWidget {}

@GenerativeUI(name: 'Banner')
class AlertBanner extends StatelessWidget {}
''',
      'lib/widgets/meter.dart': '''
@generativeUI
class Meter extends StatelessWidget {}
''',
    });

    expect(output, isNotNull);
    expect(output, contains("import 'package:app/widgets/card.dart';"));
    expect(output, contains("import 'package:app/widgets/meter.dart';"));
    expect(output, contains(r'$ProfileCardCatalogItem'));
    expect(output, contains(r'$AlertBannerCatalogItem'));
    expect(output, contains(r'$MeterCatalogItem'));
    expect(output, contains('final Catalog globalGenUICatalog = Catalog('));
    expect(output, contains('String get globalGenUISchemasPromptDescription'));
  });

  test('ignores generated files and unannotated classes', () async {
    final output = await runRegistry({
      'lib/widgets/card.dart': '''
@generativeUI
class ProfileCard extends StatelessWidget {}

class Helper {}
''',
      'lib/widgets/card.genui.g.dart': '''
@generativeUI
class ShouldNotAppear {}
''',
      'lib/plain.dart': 'class Plain {}',
    });

    expect(output, contains(r'$ProfileCardCatalogItem'));
    expect(output, isNot(contains('Helper')));
    expect(output, isNot(contains('ShouldNotAppear')));
    expect(output, isNot(contains('plain.dart')));
  });

  test('writes nothing when no class is annotated', () async {
    final output = await runRegistry({'lib/plain.dart': 'class Plain {}'});

    expect(output, isNull);
  });
}
