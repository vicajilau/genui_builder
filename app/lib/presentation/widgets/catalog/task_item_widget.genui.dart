// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'task_item_widget.dart';

// **************************************************************************
// GenUiGenerator
// **************************************************************************

/// Generated [CatalogItem] for [TaskItemWidget].
final CatalogItem taskItemWidgetCatalogItem = CatalogItem(
  name: 'TaskItemWidget',
  dataSchema: S.object(
    description:
        'A custom interactive widget representing a single checklist '
        'task item. Renders with a title, completion checkbox, and '
        'custom priority pill badges.',
    properties: {
      'title': A2uiSchemas.stringReference(description: 'The task title.'),
      'isCompleted': A2uiSchemas.booleanReference(
        description: 'Whether the task is checked as done.',
      ),
      'priority': A2uiSchemas.stringReference(
        description: 'The task priority: \'high\', \'medium\' or \'low\'.',
      ),
      'onToggle': A2uiSchemas.action(
        description: 'Fired when the user taps the checkbox.',
      ),
    },
    required: ['title', 'isCompleted', 'priority', 'onToggle'],
  ),
  exampleData: [
    () => r'''
[
  {
    "id": "root",
    "component": "TaskItemWidget",
    "title": "Quarterly report",
    "isCompleted": true,
    "priority": "Sample priority",
    "onToggle": {
      "event": {
        "name": "onToggle"
      }
    }
  }
]''',
  ],
  widgetBuilder: (ctx) {
    final data = ctx.data as JsonMap;
    T missing<T>(String property, T fallback) {
      genUiReportMissing(ctx, 'TaskItemWidget', property);
      return fallback;
    }

    return GenUiBindings(
      dataContext: ctx.dataContext,
      bindings: {
        'title': GenUiBinding.string(data['title']),
        'isCompleted': GenUiBinding.bool(data['isCompleted']),
        'priority': GenUiBinding.string(data['priority']),
      },
      builder: (context, v) => TaskItemWidget(
        title: v.string('title') ?? missing<String>('title', ''),
        isCompleted:
            v.boolean('isCompleted') ?? missing<bool>('isCompleted', false),
        priority: v.string('priority') ?? missing<String>('priority', ''),
        onToggle:
            genUiActionHandler(ctx, data['onToggle']) ??
            missing<void Function()>('onToggle', () {}),
      ),
    );
  },
);
