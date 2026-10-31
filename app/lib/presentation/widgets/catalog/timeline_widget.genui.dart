// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'timeline_widget.dart';

// **************************************************************************
// GenUiGenerator
// **************************************************************************

/// Generated [CatalogItem] for [TimelineWidget].
final CatalogItem timelineWidgetCatalogItem = CatalogItem(
  name: 'TimelineWidget',
  dataSchema: S.object(
    description:
        'A premium vertical timeline widget representing log events, '
        'milestones, or actions.',
    properties: {
      'events': A2uiSchemas.listOrReference(
        description: 'The entries, oldest first.',
        items: timelineEntryGenUiSchema,
      ),
      'title': A2uiSchemas.stringReference(description: 'The timeline title.'),
      'selectedEvent': A2uiSchemas.stringReference(
        description:
            'The title of the entry the user tapped last. Bind it to a '
            'data path and read that path from the `onTapEvent` action\'s '
            'context. The component writes the value the user chooses '
            'back to this property, so bind it to a data path if you need '
            'to read the result.',
      ),
      'onTapEvent': A2uiSchemas.action(
        description:
            'Fired when the user taps an entry, after `selectedEvent` is '
            'written.',
      ),
    },
    required: ['events'],
  ),
  exampleData: [
    () => r'''
[
  {
    "id": "root",
    "component": "TimelineWidget",
    "events": [
      {
        "title": "Quarterly report",
        "timestamp": "14:30"
      },
      {
        "title": "Monthly summary",
        "timestamp": "14:30"
      }
    ],
    "title": "14:30",
    "onTapEvent": {
      "event": {
        "name": "onTapEvent"
      }
    }
  }
]''',
  ],
  widgetBuilder: (ctx) {
    final data = ctx.data as JsonMap;
    T missing<T>(String property, T fallback) {
      genUiReportMissing(ctx, 'TimelineWidget', property);
      return fallback;
    }

    GenUiMissingFieldReporter missingIn(String property) =>
        (field) =>
            genUiReportMissing(ctx, 'TimelineWidget', '$property.$field');
    return GenUiBindings(
      dataContext: ctx.dataContext,
      bindings: {
        'events': GenUiBinding.objectList(data['events']),
        'title': GenUiBinding.string(data['title']),
        'selectedEvent': GenUiBinding.string(
          genUiWriteReference(ctx, data['selectedEvent'], 'selectedEvent'),
        ),
      },
      builder: (context, v) => TimelineWidget(
        events:
            v
                .objectList('events')
                ?.map(
                  (json) =>
                      timelineEntryFromGenUiJson(json, missingIn('events')),
                )
                .toList() ??
            missing<List<TimelineEntry>>('events', const <TimelineEntry>[]),
        title: v.string('title') ?? 'Activity Timeline',
        selectedEvent:
            (v.string('selectedEvent') ?? genUiAsString(data['selectedEvent'])),
        onSelectEvent: genUiValueWriter<String>(
          ctx,
          data['selectedEvent'],
          'selectedEvent',
        ),
        onTapEvent: genUiActionHandler(ctx, data['onTapEvent']),
      ),
    );
  },
);

// **************************************************************************
// GenUiDataGenerator
// **************************************************************************

/// Generated schema for [TimelineEntry].
final ObjectSchema timelineEntryGenUiSchema = ObjectSchema(
  description: 'An entry of a timeline.',
  properties: {
    'title': S.string(description: 'What happened.'),
    'description': S.string(description: 'More detail about the entry.'),
    'timestamp': S.string(
      description:
          'When it happened, as display text, e.g. \'Monday\' or \'10:30\'.',
    ),
    'status': S.string(
      description: 'The entry state: \'completed\', \'active\' or \'pending\'.',
    ),
  },
  required: ['title'],
);

/// Decodes a [TimelineEntry] from the map the model produced.
///
/// Values are coerced the same way genui's `Bound*` widgets coerce a
/// widget property, so a field of the wrong type degrades instead of
/// throwing. Every required field that had to fall back is reported
/// through [onMissing], when one is given.
TimelineEntry timelineEntryFromGenUiJson(
  Map<String, Object?> json, [
  GenUiMissingFieldReporter? onMissing,
]) => TimelineEntry(
  title:
      genUiAsString(json['title']) ??
      genUiMissingField<String>(onMissing, 'title', ''),
  description: genUiAsString(json['description']),
  timestamp: genUiAsString(json['timestamp']),
  status: genUiAsString(json['status']) ?? 'pending',
);
