// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'stats_widget.dart';

// **************************************************************************
// GenUiGenerator
// **************************************************************************

/// Generated [CatalogItem] for [StatsWidget].
final CatalogItem statsWidgetCatalogItem = CatalogItem(
  name: 'StatsWidget',
  dataSchema: S.object(
    description:
        'A custom progress reporting widget showing completed vs '
        'total tasks using a text summary label and a graphical '
        'linear progress indicator bar.',
    properties: {
      'totalTasks': A2uiSchemas.numberReference(
        description: 'The total number of tasks.',
      ),
      'completedTasks': A2uiSchemas.numberReference(
        description: 'How many of the tasks are done.',
      ),
    },
    required: ['totalTasks', 'completedTasks'],
  ),
  exampleData: [
    () => r'''
[
  {
    "id": "root",
    "component": "StatsWidget",
    "totalTasks": 20,
    "completedTasks": 42
  }
]''',
  ],
  widgetBuilder: (ctx) {
    final data = ctx.data as JsonMap;
    T missing<T>(String property, T fallback) {
      genUiReportMissing(ctx, 'StatsWidget', property);
      return fallback;
    }

    return GenUiBindings(
      dataContext: ctx.dataContext,
      bindings: {
        'totalTasks': GenUiBinding.number(data['totalTasks']),
        'completedTasks': GenUiBinding.number(data['completedTasks']),
      },
      builder: (context, v) => StatsWidget(
        totalTasks: (v.number('totalTasks') ?? missing<num>('totalTasks', 0))
            .toInt(),
        completedTasks:
            (v.number('completedTasks') ?? missing<num>('completedTasks', 0))
                .toInt(),
      ),
    );
  },
);
