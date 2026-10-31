import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genui/genui.dart';
import 'package:genui_playground/catalog.dart';
import 'package:genui_playground/presentation/widgets/interactive_surface.dart';

/// Renders [component] as the only child of a root column and returns the
/// actions it reports.
Future<List<Map<String, dynamic>>> _pumpSurface(
  WidgetTester tester,
  Map<String, dynamic> component,
) async {
  final actions = <Map<String, dynamic>>[];
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: InteractiveSurface(
          catalog: playgroundCatalog,
          components: [
            Component.fromJson({
              'id': 'root',
              'component': 'Column',
              'children': [component['id']],
            }),
            Component.fromJson(component),
          ],
          onEvent: (json) => actions.add(
            (jsonDecode(json) as Map<String, dynamic>)['action']
                as Map<String, dynamic>,
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return actions;
}

void main() {
  testWidgets('a list widget writes the tapped item before its action', (
    tester,
  ) async {
    final actions = await _pumpSurface(tester, {
      'id': 'replies',
      'component': PlaygroundComponents.quickReplies,
      'replies': [
        {'label': 'View invoices', 'value': 'view_invoices'},
        {'label': 'Pay invoice'},
      ],
      'selectedReply': {'path': '/selected_reply'},
      'onTapReply': {
        'event': {
          'name': 'onTapReply',
          'context': {
            'reply': {'path': '/selected_reply'},
          },
        },
      },
    });

    await tester.tap(find.text('View invoices'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pay invoice'));
    await tester.pumpAndSettle();

    expect(actions, hasLength(2));
    expect(actions[0]['name'], 'onTapReply');
    expect(actions[0]['sourceComponentId'], 'replies');
    expect(actions[0]['context'], {'reply': 'view_invoices'});
    // A reply without a value reports its label.
    expect(actions[1]['context'], {'reply': 'Pay invoice'});
  });

  testWidgets('a widget reports the action the model declared', (tester) async {
    final actions = await _pumpSurface(tester, {
      'id': 'pay',
      'component': PlaygroundComponents.customButton,
      'label': 'Pay invoice',
      'color': '#10B981',
      'onPressed': {
        'event': {
          'name': 'onPressed',
          'context': {'label': 'Pay invoice'},
        },
      },
    });

    await tester.tap(find.text('Pay invoice'));
    await tester.pumpAndSettle();

    expect(actions.single['name'], 'onPressed');
    expect(actions.single['context'], {'label': 'Pay invoice'});
  });
}
