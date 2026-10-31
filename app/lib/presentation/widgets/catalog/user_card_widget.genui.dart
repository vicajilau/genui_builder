// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'user_card_widget.dart';

// **************************************************************************
// GenUiGenerator
// **************************************************************************

/// Generated [CatalogItem] for [UserCardWidget].
final CatalogItem userCardWidgetCatalogItem = CatalogItem(
  name: 'UserCardWidget',
  dataSchema: S.object(
    description:
        'A custom widget presenting a user profile card containing a '
        'name, role, active status, and initials avatar with status '
        'coloring.',
    properties: {
      'name': A2uiSchemas.stringReference(
        description: 'The person\'s full name.',
      ),
      'role': A2uiSchemas.stringReference(
        description: 'The person\'s role or job title.',
      ),
      'isActive': A2uiSchemas.booleanReference(
        description: 'Whether the person is currently online.',
      ),
      'avatarUrl': A2uiSchemas.stringReference(
        description: 'URL of the avatar image. Initials are shown when absent.',
      ),
    },
    required: ['name', 'role'],
  ),
  exampleData: [
    () => r'''
[
  {
    "id": "root",
    "component": "UserCardWidget",
    "name": "Sample name",
    "role": "Sample role",
    "avatarUrl": "https://picsum.photos/seed/genui_gen/400/225"
  }
]''',
  ],
  widgetBuilder: (ctx) {
    final data = ctx.data as JsonMap;
    T missing<T>(String property, T fallback) {
      genUiReportMissing(ctx, 'UserCardWidget', property);
      return fallback;
    }

    return GenUiBindings(
      dataContext: ctx.dataContext,
      bindings: {
        'name': GenUiBinding.string(data['name']),
        'role': GenUiBinding.string(data['role']),
        'isActive': GenUiBinding.bool(data['isActive']),
        'avatarUrl': GenUiBinding.string(data['avatarUrl']),
      },
      builder: (context, v) => UserCardWidget(
        name: v.string('name') ?? missing<String>('name', ''),
        role: v.string('role') ?? missing<String>('role', ''),
        isActive: v.boolean('isActive') ?? false,
        avatarUrl: v.string('avatarUrl'),
      ),
    );
  },
);
