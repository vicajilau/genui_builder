// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'single_attachment_widget.dart';

// **************************************************************************
// GenUiGenerator
// **************************************************************************

/// Generated [CatalogItem] for [SingleAttachmentWidget].
final CatalogItem singleAttachmentWidgetCatalogItem = CatalogItem(
  name: 'SingleAttachmentWidget',
  dataSchema: S.object(
    description:
        'A custom premium card widget to display a single file '
        'attachment. Designed for modern, rich chat feeds.',
    properties: {
      'name': A2uiSchemas.stringReference(
        description: 'The file name, including its extension.',
      ),
      'type': A2uiSchemas.stringReference(
        description:
            'The file type: \'pdf\', \'image\', \'document\', \'spreadsheet\', '
            '\'audio\', \'video\', \'archive\', \'folder\' or \'file\'.',
      ),
      'size': A2uiSchemas.stringReference(
        description: 'The human-readable file size, e.g. \'2.4 MB\'.',
      ),
      'status': A2uiSchemas.stringReference(
        description:
            'The download state: \'ready\', \'downloading\', \'pending\', '
            '\'downloaded\' or \'failed\'.',
      ),
      'onTap': A2uiSchemas.action(
        description: 'Fired when the user taps the card.',
      ),
      'onAction': A2uiSchemas.action(
        description: 'Fired when the user taps the download button.',
      ),
    },
    required: ['name'],
  ),
  exampleData: [
    () => r'''
[
  {
    "id": "root",
    "component": "SingleAttachmentWidget",
    "name": "Sample name",
    "type": "https://picsum.photos/seed/genui_gen/400/225",
    "onTap": {
      "event": {
        "name": "onTap"
      }
    },
    "onAction": {
      "event": {
        "name": "onAction"
      }
    }
  }
]''',
  ],
  widgetBuilder: (ctx) {
    final data = ctx.data as JsonMap;
    T missing<T>(String property, T fallback) {
      genUiReportMissing(ctx, 'SingleAttachmentWidget', property);
      return fallback;
    }

    return GenUiBindings(
      dataContext: ctx.dataContext,
      bindings: {
        'name': GenUiBinding.string(data['name']),
        'type': GenUiBinding.string(data['type']),
        'size': GenUiBinding.string(data['size']),
        'status': GenUiBinding.string(data['status']),
      },
      builder: (context, v) => SingleAttachmentWidget(
        name: v.string('name') ?? missing<String>('name', ''),
        type: v.string('type') ?? 'file',
        size: v.string('size'),
        status: v.string('status') ?? 'ready',
        onTap: genUiActionHandler(ctx, data['onTap']),
        onAction: genUiActionHandler(ctx, data['onAction']),
      ),
    );
  },
);
