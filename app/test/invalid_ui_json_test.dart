import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui/genui.dart';
import 'package:genui_playground/catalog.dart';
import 'package:genui_playground/data/models/chat_timeline_item.dart';
import 'package:genui_playground/l10n/app_localizations.dart';
import 'package:genui_playground/presentation/widgets/chat_message_bubble.dart';
import 'package:genui_playground/presentation/widgets/invalid_ui_json_card.dart';

/// A reply Gemma 4 E2B gave in Local mode: commas are missing between items.
const _invalidReply = '''
Hola, aquí tienes un botón.
```json
{
  "version": "v0.9",
  "updateComponents": {
    "surfaceId": "composed_surface",
    "components": [
      {
        "id": "root",
        "component": "Column",
        "children": ["AlertBannerWidget"]
      }
      {
        "id": "root",
        "component": "CustomButton",
        "label": "hola"
      }
    ]
  }
}
```
''';

void main() {
  test('splits a reply into text and JSON blocks', () {
    final segments = splitReply(_invalidReply);

    expect(segments, hasLength(2));
    expect((segments[0] as TextSegment).text, 'Hola, aquí tienes un botón.');
    expect((segments[1] as JsonBlockSegment).json, startsWith('{'));
    expect((segments[1] as JsonBlockSegment).json, endsWith('}'));
  });

  test('locates the JSON error by line and column', () {
    final json = (splitReply(_invalidReply)[1] as JsonBlockSegment).json;

    // The second component starts without a comma after the first one.
    final error = findJsonError(json)!;
    expect(error.line, 11);
    expect(error.column, 7);
    expect(error.lineText, '      {');
    expect(findJsonError('{"valid": true}'), isNull);
  });

  test('reports a trailing comma at the closing brace', () {
    const json = '{\n  "id": "root",\n}';

    final error = findJsonError(json)!;
    expect(error.line, 3);
    expect(error.column, 1);
    expect(error.lineText, '}');
  });

  test('reports a missing closing brace at the end of the input', () {
    final error = findJsonError('{"id": "root"')!;

    expect(error.line, 1);
    expect(error.column, 14);
  });

  testWidgets('a reply with invalid JSON shows the text and an error card', (
    tester,
  ) async {
    final controller = SurfaceController(catalogs: [playgroundCatalog]);
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en')],
        home: Scaffold(
          body: ChatMessageBubble(
            item: ChatTimelineItem(isUser: false, text: _invalidReply),
            controller: controller,
          ),
        ),
      ),
    );

    expect(find.text('Hola, aquí tienes un botón.'), findsOneWidget);
    expect(find.byType(InvalidUiJsonCard), findsOneWidget);
    expect(
      find.text("The model returned UI JSON that isn't valid"),
      findsOneWidget,
    );
    // The offending line is shown with a caret under the column.
    expect(find.text('      {\n      ^'), findsOneWidget);
    // The JSON stays collapsed until the card is expanded.
    expect(find.byType(SelectableText), findsNothing);

    await tester.tap(find.byType(InvalidUiJsonCard));
    await tester.pumpAndSettle();
    expect(find.byType(SelectableText), findsOneWidget);
  });
}
