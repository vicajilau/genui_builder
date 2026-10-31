import 'package:genui/genui.dart';

/// Layout components that hold others without showing anything themselves.
const _layoutComponents = {'Column', 'Row'};

/// Whether [definition] only repeats [replyText]: it holds nothing but `Text`
/// components in layouts, and every one of those texts is already in the
/// reply.
///
/// Small models sometimes wrap their plain answer in a surface as well, which
/// would show the same sentence twice.
bool isEchoOfReply(SurfaceDefinition definition, String replyText) {
  final reply = _normalize(replyText);
  if (reply.isEmpty) return false;

  var texts = 0;
  for (final component in definition.components.values) {
    if (_layoutComponents.contains(component.type)) continue;
    if (component.type != 'Text') return false;
    final text = component.properties['text'];
    // A bound or computed text may show something the reply doesn't.
    if (text is! String || !reply.contains(_normalize(text))) return false;
    texts++;
  }
  return texts > 0;
}

String _normalize(String text) =>
    text.toLowerCase().replaceAll(RegExp(r'\s+'), ' ').trim();
