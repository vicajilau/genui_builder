import 'package:a2ui_core/a2ui_core.dart'
    show CreateSurfaceMessage, UpdateComponentsMessage;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui/genui.dart';
import 'package:genui_playground/catalog.dart';
import 'package:genui_playground/data/models/chat_timeline_item.dart';
import 'package:genui_playground/l10n/app_localizations.dart';
import 'package:genui_playground/presentation/widgets/chat_message_bubble.dart';
import 'package:genui_playground/utils/surface_echo.dart';

const _reply = 'Hola, ¿en qué puedo ayudarte hoy?';

SurfaceDefinition _surface(List<Map<String, Object?>> components) =>
    SurfaceDefinition(
      surfaceId: 's',
      components: {
        for (final json in components)
          json['id']! as String: Component.fromJson(json),
      },
    );

final _root = {
  'id': 'root',
  'component': 'Column',
  'children': ['text'],
};

void main() {
  group('isEchoOfReply', () {
    test('a surface that only repeats the reply is an echo', () {
      final surface = _surface([
        _root,
        {'id': 'text', 'component': 'Text', 'text': _reply},
      ]);

      expect(isEchoOfReply(surface, _reply), isTrue);
      // Case and spacing differences don't matter.
      expect(
        isEchoOfReply(surface, '  hola,   ¿EN QUÉ puedo ayudarte hoy?\n'),
        isTrue,
      );
    });

    test('text the reply does not contain is not an echo', () {
      final surface = _surface([
        _root,
        {'id': 'text', 'component': 'Text', 'text': 'Tus tareas de hoy'},
      ]);

      expect(isEchoOfReply(surface, _reply), isFalse);
    });

    test('a surface with any other component is not an echo', () {
      final surface = _surface([
        _root,
        {'id': 'text', 'component': 'Text', 'text': _reply},
        {
          'id': 'file',
          'component': PlaygroundComponents.singleAttachment,
          'name': 'certificado.pdf',
        },
      ]);

      expect(isEchoOfReply(surface, _reply), isFalse);
    });

    test('a bound text is not an echo', () {
      final surface = _surface([
        _root,
        {
          'id': 'text',
          'component': 'Text',
          'text': {'path': '/greeting'},
        },
      ]);

      expect(isEchoOfReply(surface, _reply), isFalse);
    });

    test('an empty surface or reply is not an echo', () {
      expect(isEchoOfReply(_surface([_root]), _reply), isFalse);
      expect(
        isEchoOfReply(
          _surface([
            _root,
            {'id': 'text', 'component': 'Text', 'text': ''},
          ]),
          '',
        ),
        isFalse,
      );
    });
  });

  testWidgets('the chat hides a surface that echoes the reply', (tester) async {
    final controller = SurfaceController(catalogs: [playgroundCatalog]);
    addTearDown(controller.dispose);

    void show(String id, String text) {
      controller.handleMessage(
        CreateSurfaceMessage(surfaceId: id, catalogId: playgroundCatalogId),
      );
      controller.handleMessage(
        UpdateComponentsMessage(
          surfaceId: id,
          components: [
            {..._root},
            {'id': 'text', 'component': 'Text', 'text': text},
          ],
        ),
      );
    }

    show('echo', _reply);
    show('other', 'Tus tareas de hoy');

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en')],
        home: Scaffold(
          body: Column(
            children: [
              for (final surfaceId in ['echo', 'other'])
                ChatMessageBubble(
                  item: ChatTimelineItem(isUser: false, surfaceId: surfaceId),
                  controller: controller,
                  replyText: _reply,
                ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(Surface), findsOneWidget);
    expect(find.text('Tus tareas de hoy'), findsOneWidget);
    expect(find.text(_reply), findsNothing);
  });
}
