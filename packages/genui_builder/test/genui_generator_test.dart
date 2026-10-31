import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui_builder/genui_builder.dart';
import 'package:source_gen/source_gen.dart';

/// The Dart SDK bundled with Flutter.
///
/// Under `flutter test` the running executable is `flutter_tester`, so the
/// analyzer cannot infer the SDK location on its own.
String get _dartSdkPath {
  final exe = Platform.resolvedExecutable.replaceAll(r'\\', '/');
  final cache = exe.substring(
    0,
    exe.indexOf('/bin/cache/') + '/bin/cache'.length,
  );
  return '$cache/dart-sdk';
}

/// Writes [source] to a fixture file and resolves it with the analyzer.
///
/// The fixture lives under `.dart_tool` so that the analyzer picks up the
/// workspace package config and can resolve `package:flutter` and
/// `package:genui_annotations`.
Future<LibraryElement> resolve(String source, String fileName) async {
  final dir = Directory(
    '${Directory.current.path}/.dart_tool/genui_builder_test',
  )..createSync(recursive: true);
  final file = File('${dir.path}/$fileName.dart')..writeAsStringSync(source);

  final collection = AnalysisContextCollection(
    includedPaths: [file.path],
    sdkPath: _dartSdkPath,
  );
  final result = await collection
      .contextFor(file.path)
      .currentSession
      .getResolvedLibrary(file.path);
  if (result is! ResolvedLibraryResult) {
    throw StateError('Could not resolve fixture: $result');
  }
  return result.element;
}

/// Returns the generator output for the class named [className] in [source].
Future<String> generateFor(String source, String className) async {
  final library = await resolve(source, 'fixture_${className.toLowerCase()}');
  final element = library.classes.firstWhere((c) => c.name == className);
  final annotation = ConstantReader(
    element.metadata.annotations.first.computeConstantValue(),
  );

  return GenerativeUIGenerator().generateForAnnotatedElement(
    element,
    annotation,
    _UnusedBuildStep(),
  );
}

/// The generator never touches the [BuildStep], so any call is a test bug.
class _UnusedBuildStep implements BuildStep {
  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('BuildStep.${invocation.memberName}');
}

const _header = '''
import 'package:flutter/widgets.dart';
import 'package:genui_annotations/genui_annotations.dart';
''';

void main() {
  test('emits identifier, schema and required fields', () async {
    final output = await generateFor('''
$_header
@generativeUI
class ProfileCard extends StatelessWidget {
  final String name;
  final int age;
  final double score;
  final bool verified;
  final List<String> tags;
  const ProfileCard({
    super.key,
    required this.name,
    required this.age,
    this.score = 1.5,
    this.verified = false,
    this.tags = const [],
  });
  @override
  Widget build(BuildContext context) => const SizedBox();
}
''', 'ProfileCard');

    expect(
      output,
      contains(r'const String $ProfileCardIdentifier = "ProfileCard";'),
    );
    expect(output, contains(r'final CatalogItem $ProfileCardCatalogItem'));
    expect(output, contains('"name": S.string('));
    expect(output, contains('"age": S.integer('));
    expect(output, contains('"score": S.number('));
    expect(output, contains('"verified": S.boolean('));
    expect(output, contains('"tags": S.list('));
    expect(output, contains('required: ["name", "age"]'));
    expect(output, isNot(contains('"key"')));
  });

  test('uses the custom name from the annotation', () async {
    final output = await generateFor('''
$_header
@GenerativeUI(name: 'Banner')
class AlertBannerWidget extends StatelessWidget {
  final String message;
  const AlertBannerWidget({super.key, required this.message});
  @override
  Widget build(BuildContext context) => const SizedBox();
}
''', 'AlertBannerWidget');

    expect(
      output,
      contains(r'const String $AlertBannerWidgetIdentifier = "Banner";'),
    );
  });

  test('reads values with numeric casts, defaults and fallbacks', () async {
    final output = await generateFor('''
$_header
@generativeUI
class Meter extends StatelessWidget {
  final double value;
  final int? steps;
  final String label;
  final String? caption;
  const Meter({
    super.key,
    required this.value,
    this.steps,
    this.label = 'Progress',
    this.caption,
  });
  @override
  Widget build(BuildContext context) => const SizedBox();
}
''', 'Meter');

    expect(
      output,
      contains('value: ((data["value"] as num?)?.toDouble()) ?? 0.0,'),
    );
    expect(output, contains('steps: (data["steps"] as num?)?.toInt(),'));
    expect(
      output,
      contains('''label: (data["label"] as String?) ?? 'Progress','''),
    );
    expect(output, contains('caption: data["caption"] as String?,'));
  });

  test('maps Color fields to hex strings and parses them back', () async {
    final output = await generateFor('''
$_header
@generativeUI
class Swatch extends StatelessWidget {
  final Color color;
  final Color? border;
  const Swatch({super.key, required this.color, this.border});
  @override
  Widget build(BuildContext context) => const SizedBox();
}
''', 'Swatch');

    expect(
      output,
      contains(
        '"color": S.string(description: "The color property in hex format',
      ),
    );
    expect(
      output,
      contains('if (val is! String) return const Color(0xFF000000);'),
    );
    expect(output, contains('if (val is! String) return null;'));
  });

  test('turns callbacks into dispatched events', () async {
    final output = await generateFor('''
$_header
@generativeUI
class TaskItem extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onToggle;
  const TaskItem({super.key, required this.title, this.onTap, this.onToggle});
  @override
  Widget build(BuildContext context) => const SizedBox();
}
''', 'TaskItem');

    expect(output, contains('abstract class TaskItemEvents {'));
    expect(
      output,
      contains("static const String onTap = 'TaskItem_onTapEvent';"),
    );
    expect(
      output,
      contains("static const String onToggle = 'TaskItem_onToggleEvent';"),
    );
    expect(output, contains('onTap: () {'));
    expect(output, contains('onToggle: (bool value) {'));
    expect(output, contains("...data, ...{'value': value}"));
    // Callbacks are not part of the data schema.
    expect(output, isNot(contains('"onTap":')));
    expect(output, isNot(contains('"onToggle":')));
  });

  test('rejects annotations on non-class elements', () async {
    final library = await resolve('''
$_header
@generativeUI
void notAWidget() {}
''', 'fixture_function');
    final Element element = library.topLevelFunctions.single;

    expect(
      () => GenerativeUIGenerator().generateForAnnotatedElement(
        element,
        ConstantReader(null),
        _UnusedBuildStep(),
      ),
      throwsA(isA<InvalidGenerationSourceError>()),
    );
  });
}
