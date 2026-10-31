// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'metric_chart_widget.dart';

// **************************************************************************
// GenUiGenerator
// **************************************************************************

/// Generated [CatalogItem] for [MetricChartWidget].
final CatalogItem metricChartWidgetCatalogItem = CatalogItem(
  name: 'MetricChartWidget',
  dataSchema: S.object(
    description:
        'A premium circular chart widget displaying a progress '
        'metric.',
    properties: {
      'title': A2uiSchemas.stringReference(description: 'The chart title.'),
      'value': A2uiSchemas.numberReference(
        description:
            'The progress, from 0 to 1. Values above 1 are read as '
            'percentages.',
      ),
      'legendLabel': A2uiSchemas.stringReference(
        description: 'The legend shown next to the value.',
      ),
      'colorHex': A2uiSchemas.stringReference(
        description: 'The chart color in hex format, e.g. \'#6366F1\'.',
      ),
    },
    required: ['title', 'value'],
  ),
  exampleData: [
    () => r'''
[
  {
    "id": "root",
    "component": "MetricChartWidget",
    "title": "Quarterly report",
    "value": 0.65,
    "colorHex": "#3366FF"
  }
]''',
  ],
  widgetBuilder: (ctx) {
    final data = ctx.data as JsonMap;
    T missing<T>(String property, T fallback) {
      genUiReportMissing(ctx, 'MetricChartWidget', property);
      return fallback;
    }

    return GenUiBindings(
      dataContext: ctx.dataContext,
      bindings: {
        'title': GenUiBinding.string(data['title']),
        'value': GenUiBinding.number(data['value']),
        'legendLabel': GenUiBinding.string(data['legendLabel']),
        'colorHex': GenUiBinding.string(data['colorHex']),
      },
      builder: (context, v) => MetricChartWidget(
        title: v.string('title') ?? missing<String>('title', ''),
        value: (v.number('value') ?? missing<num>('value', 0)).toDouble(),
        legendLabel: v.string('legendLabel') ?? 'Completed',
        colorHex: v.string('colorHex'),
      ),
    );
  },
);
