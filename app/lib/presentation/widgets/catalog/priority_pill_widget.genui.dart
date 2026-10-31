// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'priority_pill_widget.dart';

// **************************************************************************
// GenUiGenerator
// **************************************************************************

/// Generated [CatalogItem] for [PriorityPillWidget].
final CatalogItem priorityPillWidgetCatalogItem = CatalogItem(
  name: 'PriorityPillWidget',
  dataSchema: S.object(
    description: 'A custom premium priority badge/pill widget.',
    properties: {
      'priority': A2uiSchemas.stringReference(
        description: 'The priority level: \'high\', \'medium\' or \'low\'.',
      ),
      'label': A2uiSchemas.stringReference(
        description: 'Custom text for the pill. Defaults to the priority.',
      ),
    },
    required: ['priority'],
  ),
  exampleData: [
    () => r'''
[
  {
    "id": "root",
    "component": "PriorityPillWidget",
    "priority": "Sample priority"
  }
]''',
  ],
  widgetBuilder: (ctx) {
    final data = ctx.data as JsonMap;
    T missing<T>(String property, T fallback) {
      genUiReportMissing(ctx, 'PriorityPillWidget', property);
      return fallback;
    }

    return GenUiBindings(
      dataContext: ctx.dataContext,
      bindings: {
        'priority': GenUiBinding.string(data['priority']),
        'label': GenUiBinding.string(data['label']),
      },
      builder: (context, v) => PriorityPillWidget(
        priority: v.string('priority') ?? missing<String>('priority', ''),
        label: v.string('label'),
      ),
    );
  },
);
