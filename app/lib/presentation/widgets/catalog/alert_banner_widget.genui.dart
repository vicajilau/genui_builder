// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'alert_banner_widget.dart';

// **************************************************************************
// GenUiGenerator
// **************************************************************************

/// Generated [CatalogItem] for [AlertBannerWidget].
final CatalogItem alertBannerWidgetCatalogItem = CatalogItem(
  name: 'AlertBannerWidget',
  dataSchema: S.object(
    description:
        'A premium alert banner displaying warnings, errors, '
        'notifications, or success states.',
    properties: {
      'type': A2uiSchemas.stringReference(
        description:
            'The alert style: \'info\', \'success\', \'warning\' or \'error\'.',
      ),
      'message': A2uiSchemas.stringReference(description: 'The alert text.'),
      'actionLabel': A2uiSchemas.stringReference(
        description:
            'Label of the action button. The button is hidden when '
            'absent.',
      ),
      'onAction': A2uiSchemas.action(
        description: 'Fired when the user taps the action button.',
      ),
      'onDismiss': A2uiSchemas.action(
        description: 'Fired when the user dismisses the alert.',
      ),
    },
    required: ['type', 'message'],
  ),
  exampleData: [
    () => r'''
[
  {
    "id": "root",
    "component": "AlertBannerWidget",
    "type": "Sample type",
    "message": "Something needs your attention.",
    "onAction": {
      "event": {
        "name": "onAction"
      }
    },
    "onDismiss": {
      "event": {
        "name": "onDismiss"
      }
    }
  }
]''',
  ],
  widgetBuilder: (ctx) {
    final data = ctx.data as JsonMap;
    T missing<T>(String property, T fallback) {
      genUiReportMissing(ctx, 'AlertBannerWidget', property);
      return fallback;
    }

    return GenUiBindings(
      dataContext: ctx.dataContext,
      bindings: {
        'type': GenUiBinding.string(data['type']),
        'message': GenUiBinding.string(data['message']),
        'actionLabel': GenUiBinding.string(data['actionLabel']),
      },
      builder: (context, v) => AlertBannerWidget(
        type: v.string('type') ?? missing<String>('type', ''),
        message: v.string('message') ?? missing<String>('message', ''),
        actionLabel: v.string('actionLabel'),
        onAction: genUiActionHandler(ctx, data['onAction']),
        onDismiss: genUiActionHandler(ctx, data['onDismiss']),
      ),
    );
  },
);
