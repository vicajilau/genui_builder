// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

import 'package:genui_gen/genui_gen.dart';

import 'presentation/widgets/catalog/alert_banner_widget.dart';
import 'presentation/widgets/catalog/attachment_list_widget.dart';
import 'presentation/widgets/catalog/custom_button.dart';
import 'presentation/widgets/catalog/metric_chart_widget.dart';
import 'presentation/widgets/catalog/priority_pill_widget.dart';
import 'presentation/widgets/catalog/product_card_widget.dart';
import 'presentation/widgets/catalog/quick_replies_widget.dart';
import 'presentation/widgets/catalog/single_attachment_widget.dart';
import 'presentation/widgets/catalog/stats_widget.dart';
import 'presentation/widgets/catalog/task_item_widget.dart';
import 'presentation/widgets/catalog/timeline_widget.dart';
import 'presentation/widgets/catalog/user_card_widget.dart';

/// Every [CatalogItem] generated in this package, by name.
///
/// Rebuilt whenever a `@GenUiWidget` is added, renamed or
/// removed, so a catalog composed from it cannot fall behind
/// the widgets it is meant to describe.
final List<CatalogItem> genUiCatalogItems = <CatalogItem>[
  alertBannerWidgetCatalogItem,
  attachmentListWidgetCatalogItem,
  customButtonCatalogItem,
  metricChartWidgetCatalogItem,
  priorityPillWidgetCatalogItem,
  productCardWidgetCatalogItem,
  quickRepliesWidgetCatalogItem,
  singleAttachmentWidgetCatalogItem,
  statsWidgetCatalogItem,
  taskItemWidgetCatalogItem,
  timelineWidgetCatalogItem,
  userCardWidgetCatalogItem,
];

/// Every [ClientFunction] generated in this package, by
/// name.
///
/// These are the other half of a catalog: what the model
/// computes a value with, through the `{"call": ...}` form
/// any bound property accepts.
final List<ClientFunction> genUiCatalogFunctions = <ClientFunction>[];

/// Every generated [CatalogItem] of this package, as a
/// [Catalog] ready to hand to genui.
///
/// Compose it with any other catalog through
/// [Catalog.copyWith], for instance to add genui's own
/// basic components:
///
/// ```dart
/// final catalog = genUiCatalog.copyWith(
///   newItems: BasicCatalogItems.asCatalog().items.toList(),
///   newFunctions: BasicCatalogItems.asCatalog().functions.toList(),
/// );
/// ```
final Catalog genUiCatalog = Catalog(
  genUiCatalogItems,
  functions: genUiCatalogFunctions,
  catalogId: 'genui_playground',
);
