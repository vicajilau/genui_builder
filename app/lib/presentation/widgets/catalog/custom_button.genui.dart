// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'custom_button.dart';

// **************************************************************************
// GenUiGenerator
// **************************************************************************

/// Generated [CatalogItem] for [CustomButton].
final CatalogItem customButtonCatalogItem = CatalogItem(
  name: 'CustomButton',
  dataSchema: S.object(
    description:
        'A custom interactive button widget that renders a labeled '
        'elevated button. Supports a custom label, flexible color '
        'parsing, and click event callbacks.',
    properties: {
      'label': A2uiSchemas.stringReference(description: 'The button text.'),
      'color': A2uiSchemas.stringReference(
        description: 'The background color in hex format, e.g. \'#6366F1\'.',
      ),
      'onPressed': A2uiSchemas.action(
        description: 'Fired when the user presses the button.',
      ),
    },
    required: ['label', 'onPressed'],
  ),
  exampleData: [
    () => r'''
[
  {
    "id": "root",
    "component": "CustomButton",
    "label": "Sample label",
    "color": "#3366FF",
    "onPressed": {
      "event": {
        "name": "onPressed"
      }
    }
  }
]''',
  ],
  widgetBuilder: (ctx) {
    final data = ctx.data as JsonMap;
    T missing<T>(String property, T fallback) {
      genUiReportMissing(ctx, 'CustomButton', property);
      return fallback;
    }

    return GenUiBindings(
      dataContext: ctx.dataContext,
      bindings: {
        'label': GenUiBinding.string(data['label']),
        'color': GenUiBinding.string(data['color']),
      },
      builder: (context, v) => CustomButton(
        label: v.string('label') ?? missing<String>('label', ''),
        color: v.string('color'),
        onPressed:
            genUiActionHandler(ctx, data['onPressed']) ??
            missing<void Function()>('onPressed', () {}),
      ),
    );
  },
);
