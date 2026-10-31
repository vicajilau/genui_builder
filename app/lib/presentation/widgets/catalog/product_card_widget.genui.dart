// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'product_card_widget.dart';

// **************************************************************************
// GenUiGenerator
// **************************************************************************

/// Generated [CatalogItem] for [ProductCardWidget].
final CatalogItem productCardWidgetCatalogItem = CatalogItem(
  name: 'ProductCardWidget',
  dataSchema: S.object(
    description:
        'A custom premium product card widget to show product '
        'listings, prices, images, and action buttons inside rich '
        'chat sessions.',
    properties: {
      'title': A2uiSchemas.stringReference(description: 'The product name.'),
      'price': A2uiSchemas.stringReference(
        description:
            'The formatted price, including the currency, e.g. '
            '\'\\\$299.99\'.',
      ),
      'imageUrl': A2uiSchemas.stringReference(
        description: 'URL of the product image.',
      ),
      'description': A2uiSchemas.stringReference(
        description: 'A short product description.',
      ),
      'rating': A2uiSchemas.numberReference(
        description: 'The rating, from 0 to 5.',
      ),
      'onTapProduct': A2uiSchemas.action(
        description: 'Fired when the user taps the card.',
      ),
      'onBuy': A2uiSchemas.action(
        description: 'Fired when the user taps the buy button.',
      ),
    },
    required: ['title', 'price'],
  ),
  exampleData: [
    () => r'''
[
  {
    "id": "root",
    "component": "ProductCardWidget",
    "title": "Quarterly report",
    "price": "USD",
    "imageUrl": "https://picsum.photos/seed/genui_gen/400/225",
    "onTapProduct": {
      "event": {
        "name": "onTapProduct"
      }
    },
    "onBuy": {
      "event": {
        "name": "onBuy"
      }
    }
  }
]''',
  ],
  widgetBuilder: (ctx) {
    final data = ctx.data as JsonMap;
    T missing<T>(String property, T fallback) {
      genUiReportMissing(ctx, 'ProductCardWidget', property);
      return fallback;
    }

    return GenUiBindings(
      dataContext: ctx.dataContext,
      bindings: {
        'title': GenUiBinding.string(data['title']),
        'price': GenUiBinding.string(data['price']),
        'imageUrl': GenUiBinding.string(data['imageUrl']),
        'description': GenUiBinding.string(data['description']),
        'rating': GenUiBinding.number(data['rating']),
      },
      builder: (context, v) => ProductCardWidget(
        title: v.string('title') ?? missing<String>('title', ''),
        price: v.string('price') ?? missing<String>('price', ''),
        imageUrl: v.string('imageUrl'),
        description: v.string('description'),
        rating: v.number('rating')?.toDouble(),
        onTapProduct: genUiActionHandler(ctx, data['onTapProduct']),
        onBuy: genUiActionHandler(ctx, data['onBuy']),
      ),
    );
  },
);
