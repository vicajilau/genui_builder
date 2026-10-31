// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'quick_replies_widget.dart';

// **************************************************************************
// GenUiGenerator
// **************************************************************************

/// Generated [CatalogItem] for [QuickRepliesWidget].
final CatalogItem quickRepliesWidgetCatalogItem = CatalogItem(
  name: 'QuickRepliesWidget',
  dataSchema: S.object(
    description:
        'A custom interactive widget displaying a horizontal list of '
        'suggestion chips/buttons that can be tapped to trigger chat '
        'interactions.',
    properties: {
      'replies': A2uiSchemas.listOrReference(
        description: 'The suggestions to show as chips.',
        items: quickReplyItemGenUiSchema,
      ),
      'title': A2uiSchemas.stringReference(
        description: 'Optional heading above the chips.',
      ),
      'selectedReply': A2uiSchemas.stringReference(
        description:
            'The value of the reply the user tapped last. Bind it to a '
            'data path and read that path from the `onTapReply` action\'s '
            'context. The component writes the value the user chooses '
            'back to this property, so bind it to a data path if you need '
            'to read the result.',
      ),
      'onTapReply': A2uiSchemas.action(
        description:
            'Fired when the user taps a chip, after `selectedReply` is '
            'written.',
      ),
    },
    required: ['replies'],
  ),
  exampleData: [
    () => r'''
[
  {
    "id": "root",
    "component": "QuickRepliesWidget",
    "replies": [
      {
        "label": "Sample label 1"
      },
      {
        "label": "Sample label 2"
      }
    ],
    "onTapReply": {
      "event": {
        "name": "onTapReply"
      }
    }
  }
]''',
  ],
  widgetBuilder: (ctx) {
    final data = ctx.data as JsonMap;
    T missing<T>(String property, T fallback) {
      genUiReportMissing(ctx, 'QuickRepliesWidget', property);
      return fallback;
    }

    GenUiMissingFieldReporter missingIn(String property) =>
        (field) =>
            genUiReportMissing(ctx, 'QuickRepliesWidget', '$property.$field');
    return GenUiBindings(
      dataContext: ctx.dataContext,
      bindings: {
        'replies': GenUiBinding.objectList(data['replies']),
        'title': GenUiBinding.string(data['title']),
        'selectedReply': GenUiBinding.string(
          genUiWriteReference(ctx, data['selectedReply'], 'selectedReply'),
        ),
      },
      builder: (context, v) => QuickRepliesWidget(
        replies:
            v
                .objectList('replies')
                ?.map(
                  (json) =>
                      quickReplyItemFromGenUiJson(json, missingIn('replies')),
                )
                .toList() ??
            missing<List<QuickReplyItem>>('replies', const <QuickReplyItem>[]),
        title: v.string('title'),
        selectedReply:
            (v.string('selectedReply') ?? genUiAsString(data['selectedReply'])),
        onSelectReply: genUiValueWriter<String>(
          ctx,
          data['selectedReply'],
          'selectedReply',
        ),
        onTapReply: genUiActionHandler(ctx, data['onTapReply']),
      ),
    );
  },
);

// **************************************************************************
// GenUiDataGenerator
// **************************************************************************

/// Generated schema for [QuickReplyItem].
final ObjectSchema quickReplyItemGenUiSchema = ObjectSchema(
  description: 'A suggestion chip.',
  properties: {
    'label': S.string(description: 'The visible chip text.'),
    'value': S.string(
      description:
          'The value reported when the chip is tapped. Defaults to '
          '[label].',
    ),
  },
  required: ['label'],
);

/// Decodes a [QuickReplyItem] from the map the model produced.
///
/// Values are coerced the same way genui's `Bound*` widgets coerce a
/// widget property, so a field of the wrong type degrades instead of
/// throwing. Every required field that had to fall back is reported
/// through [onMissing], when one is given.
QuickReplyItem quickReplyItemFromGenUiJson(
  Map<String, Object?> json, [
  GenUiMissingFieldReporter? onMissing,
]) => QuickReplyItem(
  label:
      genUiAsString(json['label']) ??
      genUiMissingField<String>(onMissing, 'label', ''),
  value: genUiAsString(json['value']),
);
