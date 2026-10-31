import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'package:a2ui_core/a2ui_core.dart' show UpdateComponentsMessage;
import 'package:genui/genui.dart';

import '../../catalog.dart';

/// A custom action delegate that intercepts A2UI interface events
/// (like alert dismissal, timelines, or task toggling) and processes them locally
/// on the surface controller before they propagate to the network.
class ChatUiActionDelegate implements ActionDelegate {
  final SurfaceController controller;

  const ChatUiActionDelegate(this.controller);

  @override
  bool handleEvent(
    BuildContext context,
    UiEvent event,
    SurfaceContext genUiContext,
    Widget Function(SurfaceDefinition, Catalog, String, DataContext)
    buildWidget,
  ) {
    if (event is! UserActionEvent) return false;

    final l10n = AppLocalizations.of(context)!;

    // The model names the events, so the source component's type tells which
    // widget fired it, and the event name which of its actions.
    final definition = genUiContext.definition.value;
    final source = definition?.components[event.sourceComponentId];
    if (definition == null || source == null) return false;
    final action = (source.type, event.name);

    if (action == (PlaygroundComponents.attachmentList, 'onTapItem')) {
      final fileName =
          _writtenValue(genUiContext, source, 'selectedFile') ??
          l10n.defaultFileName;
      final messenger = ScaffoldMessenger.of(context);

      messenger.clearSnackBars();
      messenger.showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.downloadingFile(fileName),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          duration: const Duration(seconds: 1),
          backgroundColor: const Color(0xFF6366F1),
        ),
      );

      Future.delayed(const Duration(seconds: 1), () {
        messenger.clearSnackBars();
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              l10n.downloadSuccess(fileName),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            backgroundColor: const Color(0xFF10B981),
            behavior: SnackBarBehavior.floating,
          ),
        );
      });

      return true;
    }

    if (action == (PlaygroundComponents.alertBanner, 'onDismiss')) {
      final surfaceId = genUiContext.surfaceId;
      final componentId = event.sourceComponentId;
      final parentComponent = definition.components['root'];
      final List<Component> finalUpdatedComponents = [];

      if (parentComponent != null) {
        final currentChildren = List<String>.from(
          parentComponent.properties['children'] as List<dynamic>? ?? [],
        );
        currentChildren.remove(componentId);

        finalUpdatedComponents.add(
          Component(
            id: parentComponent.id,
            type: parentComponent.type,
            properties: {
              ...parentComponent.properties,
              'children': currentChildren,
            },
          ),
        );
      }

      controller.handleMessage(
        UpdateComponentsMessage(
          surfaceId: surfaceId,
          components: finalUpdatedComponents.map((c) => c.toJson()).toList(),
        ),
      );

      final messenger = ScaffoldMessenger.of(context);
      messenger.clearSnackBars();
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            l10n.alertDismissedLocally,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          duration: const Duration(milliseconds: 700),
          behavior: SnackBarBehavior.floating,
        ),
      );

      return true;
    }

    if (action == (PlaygroundComponents.alertBanner, 'onAction')) {
      final actionLabel =
          _literal(source, 'actionLabel') ?? l10n.defaultActionLabel;
      final messenger = ScaffoldMessenger.of(context);

      messenger.clearSnackBars();
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            l10n.actionExecuted(actionLabel),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          duration: const Duration(seconds: 1),
          backgroundColor: const Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
        ),
      );

      return true;
    }

    if (action == (PlaygroundComponents.timeline, 'onTapEvent')) {
      final surfaceId = genUiContext.surfaceId;
      final component = source;

      final eventTitle = _writtenValue(genUiContext, source, 'selectedEvent');
      if (eventTitle == null) return false;

      final currentEvents =
          component.properties['events'] as List<dynamic>? ?? [];
      final updatedEvents = currentEvents.map((e) {
        if (e is Map) {
          final eMap = Map<String, dynamic>.from(e);
          if (eMap['title'] == eventTitle) {
            final currentStatus = eMap['status'] as String? ?? 'pending';
            eMap['status'] = currentStatus == 'completed'
                ? 'pending'
                : 'completed';
          }
          return eMap;
        }
        return e;
      }).toList();

      controller.handleMessage(
        UpdateComponentsMessage(
          surfaceId: surfaceId,
          components: [
            Component(
              id: component.id,
              type: component.type,
              properties: {...component.properties, 'events': updatedEvents},
            ).toJson(),
          ],
        ),
      );

      final messenger = ScaffoldMessenger.of(context);
      messenger.clearSnackBars();
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            l10n.timelineStatusUpdated(eventTitle),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          duration: const Duration(milliseconds: 700),
          backgroundColor: const Color(0xFF3B82F6),
          behavior: SnackBarBehavior.floating,
        ),
      );

      return true;
    }

    if (action == (PlaygroundComponents.taskItem, 'onToggle')) {
      final surfaceId = genUiContext.surfaceId;
      final componentId = source.id;
      final component = source;

      final List<Component> updatedComponents = [];

      final currentIsCompleted =
          component.properties['isCompleted'] as bool? ?? false;
      final newIsCompleted = !currentIsCompleted;

      final updatedTask = Component(
        id: component.id,
        type: component.type,
        properties: {...component.properties, 'isCompleted': newIsCompleted},
      );
      updatedComponents.add(updatedTask);

      int totalTasks = 0;
      int completedTasks = 0;

      for (final comp in definition.components.values) {
        if (comp.type == PlaygroundComponents.taskItem) {
          totalTasks++;
          final isComp = (comp.id == componentId)
              ? newIsCompleted
              : (comp.properties['isCompleted'] as bool? ?? false);
          if (isComp) {
            completedTasks++;
          }
        }
      }

      for (final comp in definition.components.values) {
        if (comp.type == PlaygroundComponents.stats) {
          updatedComponents.add(
            Component(
              id: comp.id,
              type: comp.type,
              properties: {
                ...comp.properties,
                'totalTasks': totalTasks,
                'completedTasks': completedTasks,
              },
            ),
          );
        }
      }

      controller.handleMessage(
        UpdateComponentsMessage(
          surfaceId: surfaceId,
          components: updatedComponents.map((c) => c.toJson()).toList(),
        ),
      );

      return true;
    }

    if (action == (PlaygroundComponents.customButton, 'onPressed')) {
      final label = _literal(source, 'label') ?? l10n.defaultButtonLabel;
      final messenger = ScaffoldMessenger.of(context);

      final labelLower = label.toLowerCase();
      if (labelLower.contains('pagar') || labelLower.contains('pay')) {
        messenger.clearSnackBars();
        messenger.showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.processingSecurePayment,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            duration: const Duration(seconds: 1),
            backgroundColor: const Color(0xFF6366F1),
          ),
        );

        Future.delayed(const Duration(seconds: 1), () {
          messenger.clearSnackBars();
          messenger.showSnackBar(
            SnackBar(
              content: Text(
                l10n.paymentSuccessful,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              backgroundColor: const Color(0xFF10B981),
              behavior: SnackBarBehavior.floating,
            ),
          );
        });
        return true;
      }

      messenger.clearSnackBars();
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            l10n.buttonPressed(label),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          duration: const Duration(seconds: 1),
          backgroundColor: const Color(0xFF6366F1),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return true;
    }

    return false;
  }

  /// Returns [property] of [component] when the model sent it as a literal
  /// string rather than a data binding.
  static String? _literal(Component component, String property) {
    final value = component.properties[property];
    return value is String ? value : null;
  }

  /// Reads the value [component] wrote for [property] through genui_gen's
  /// `@GenUiWrites`: at the path the property is bound to, or at
  /// `<componentId>.<property>` when the model sent a literal.
  static String? _writtenValue(
    SurfaceContext surface,
    Component component,
    String property,
  ) {
    final reference = component.properties[property];
    final boundPath = reference is Map ? reference['path'] : null;
    var path = boundPath is String && boundPath.isNotEmpty
        ? boundPath
        : '${component.id}.$property';
    if (!path.startsWith('/')) path = '/$path';
    return surface.dataModel.getValue<String>(DataPath(path));
  }
}
