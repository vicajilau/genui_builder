import 'dart:convert';

import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

/// A piece of an assistant reply: plain text, or a JSON code block.
sealed class ReplySegment {
  const ReplySegment();
}

final class TextSegment extends ReplySegment {
  const TextSegment(this.text);
  final String text;
}

final class JsonBlockSegment extends ReplySegment {
  const JsonBlockSegment(this.json);
  final String json;
}

/// Splits an assistant reply into text and ```json code blocks.
///
/// genui's parser turns every valid JSON block into an A2UI message, so a block
/// that is still in the reply text is one it could not parse.
List<ReplySegment> splitReply(String text) {
  final segments = <ReplySegment>[];
  var start = 0;
  for (final match in RegExp(
    r'```(?:json)?\s*([\s\S]*?)\s*```',
  ).allMatches(text)) {
    final before = text.substring(start, match.start).trim();
    if (before.isNotEmpty) segments.add(TextSegment(before));
    segments.add(JsonBlockSegment(match.group(1)!));
    start = match.end;
  }
  final rest = text.substring(start).trim();
  if (rest.isNotEmpty) segments.add(TextSegment(rest));
  return segments;
}

/// Describes why [json] does not parse, e.g. `Unexpected character (line 12,
/// column 9)`, or returns `null` when it does.
String? describeJsonError(String json) {
  try {
    jsonDecode(json);
    return null;
  } on FormatException catch (e) {
    final offset = e.offset;
    if (offset == null || offset > json.length) return e.message;
    final before = json.substring(0, offset);
    final line = '\n'.allMatches(before).length + 1;
    final column = offset - before.lastIndexOf('\n');
    return '${e.message} (line $line, column $column)';
  }
}

/// Shows a JSON block from the model that genui could not render, with the
/// parse error and the JSON itself collapsed.
class InvalidUiJsonCard extends StatelessWidget {
  const InvalidUiJsonCard({super.key, required this.json});

  final String json;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final error = describeJsonError(json);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      // ExpansionTile paints its ink on the nearest Material.
      child: Material(
        color: const Color(0x1AF59E0B), // Amber, translucent
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0x66F59E0B)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Theme(
          // Drops the dividers ExpansionTile draws when expanded.
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(horizontal: 12),
            childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            leading: const Icon(
              Icons.warning_amber_rounded,
              color: Color(0xFFF59E0B),
              size: 20,
            ),
            iconColor: Colors.white70,
            collapsedIconColor: Colors.white70,
            title: Text(
              l10n.invalidUiJsonTitle,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFFFCD34D),
              ),
            ),
            subtitle: error == null
                ? null
                : Text(
                    error,
                    style: const TextStyle(fontSize: 12, color: Colors.white70),
                  ),
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SelectableText(
                  json,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                    color: Color(0xFFE2E8F0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
