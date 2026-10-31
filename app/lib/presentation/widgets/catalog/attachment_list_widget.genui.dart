// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'attachment_list_widget.dart';

// **************************************************************************
// GenUiGenerator
// **************************************************************************

/// Generated [CatalogItem] for [AttachmentListWidget].
final CatalogItem attachmentListWidgetCatalogItem = CatalogItem(
  name: 'AttachmentListWidget',
  dataSchema: S.object(
    description: 'A custom premium list widget to display file attachments.',
    properties: {
      'items': A2uiSchemas.listOrReference(
        description: 'The files to list.',
        items: attachmentItemGenUiSchema,
      ),
      'title': A2uiSchemas.stringReference(description: 'The list title.'),
      'selectedFile': A2uiSchemas.stringReference(
        description:
            'The name of the file the user tapped last. Bind it to a data '
            'path and read that path from the `onTapItem` action\'s '
            'context. The component writes the value the user chooses '
            'back to this property, so bind it to a data path if you need '
            'to read the result.',
      ),
      'onTapItem': A2uiSchemas.action(
        description:
            'Fired when the user taps a file, after `selectedFile` is '
            'written.',
      ),
    },
    required: ['items'],
  ),
  exampleData: [
    () => r'''
[
  {
    "id": "root",
    "component": "AttachmentListWidget",
    "items": [
      {
        "name": "Sample name 1",
        "type": "https://picsum.photos/seed/genui_gen/400/225"
      },
      {
        "name": "Sample name 2",
        "type": "https://picsum.photos/seed/genui_gen/400/225"
      }
    ],
    "onTapItem": {
      "event": {
        "name": "onTapItem"
      }
    }
  }
]''',
  ],
  widgetBuilder: (ctx) {
    final data = ctx.data as JsonMap;
    T missing<T>(String property, T fallback) {
      genUiReportMissing(ctx, 'AttachmentListWidget', property);
      return fallback;
    }

    GenUiMissingFieldReporter missingIn(String property) =>
        (field) =>
            genUiReportMissing(ctx, 'AttachmentListWidget', '$property.$field');
    return GenUiBindings(
      dataContext: ctx.dataContext,
      bindings: {
        'items': GenUiBinding.objectList(data['items']),
        'title': GenUiBinding.string(data['title']),
        'selectedFile': GenUiBinding.string(
          genUiWriteReference(ctx, data['selectedFile'], 'selectedFile'),
        ),
      },
      builder: (context, v) => AttachmentListWidget(
        items:
            v
                .objectList('items')
                ?.map(
                  (json) =>
                      attachmentItemFromGenUiJson(json, missingIn('items')),
                )
                .toList() ??
            missing<List<AttachmentItem>>('items', const <AttachmentItem>[]),
        title: v.string('title') ?? 'Attachments',
        selectedFile:
            (v.string('selectedFile') ?? genUiAsString(data['selectedFile'])),
        onSelectFile: genUiValueWriter<String>(
          ctx,
          data['selectedFile'],
          'selectedFile',
        ),
        onTapItem: genUiActionHandler(ctx, data['onTapItem']),
      ),
    );
  },
);

// **************************************************************************
// GenUiDataGenerator
// **************************************************************************

/// Generated schema for [AttachmentItem].
final ObjectSchema attachmentItemGenUiSchema = ObjectSchema(
  description: 'A file in an attachment list.',
  properties: {
    'name': S.string(description: 'The file name, including its extension.'),
    'type': S.string(
      description:
          'The file type: \'pdf\', \'image\', \'document\', \'spreadsheet\', '
          '\'audio\', \'video\', \'archive\', \'folder\' or \'file\'.',
    ),
    'size': S.string(
      description: 'The human-readable file size, e.g. \'2.4 MB\'.',
    ),
  },
  required: ['name'],
);

/// Decodes a [AttachmentItem] from the map the model produced.
///
/// Values are coerced the same way genui's `Bound*` widgets coerce a
/// widget property, so a field of the wrong type degrades instead of
/// throwing. Every required field that had to fall back is reported
/// through [onMissing], when one is given.
AttachmentItem attachmentItemFromGenUiJson(
  Map<String, Object?> json, [
  GenUiMissingFieldReporter? onMissing,
]) => AttachmentItem(
  name:
      genUiAsString(json['name']) ??
      genUiMissingField<String>(onMissing, 'name', ''),
  type: genUiAsString(json['type']) ?? 'file',
  size: genUiAsString(json['size']),
);
