import 'package:flutter/material.dart';
import 'package:genui_gen/genui_gen.dart';

part 'quick_replies_widget.genui.dart';

/// A custom interactive widget displaying a horizontal list of suggestion chips/buttons
/// that can be tapped to trigger chat interactions.
@GenUiWidget(
  description:
      'A custom interactive widget displaying a horizontal list of suggestion chips/buttons that can be tapped to trigger chat interactions.',
)
class QuickRepliesWidget extends StatelessWidget {
  /// The suggestions to show as chips.
  final List<QuickReplyItem> replies;

  /// Optional heading above the chips.
  final String? title;

  /// The value of the reply the user tapped last. Bind it to a data path and
  /// read that path from the `onTapReply` action's context.
  final String? selectedReply;

  /// Writes the tapped reply value into `selectedReply`.
  @GenUiWrites('selectedReply')
  final ValueChanged<String>? onSelectReply;

  /// Fired when the user taps a chip, after `selectedReply` is written.
  @GenUiAction(eventName: 'onTapReply')
  final VoidCallback? onTapReply;

  const QuickRepliesWidget({
    super.key,
    required this.replies,
    this.title,
    this.selectedReply,
    this.onSelectReply,
    this.onTapReply,
  });

  @override
  Widget build(BuildContext context) {
    final items = replies;
    if (items.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null && title!.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Text(
                title!,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withValues(alpha: 0.5),
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(height: 6),
          ],
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: items.map((replyItem) {
                if (replyItem.label.isEmpty) return const SizedBox.shrink();

                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: InkWell(
                    onTap: onTapReply != null
                        ? () {
                            onSelectReply?.call(
                              replyItem.value ?? replyItem.label,
                            );
                            onTapReply!();
                          }
                        : null,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0x0DFFFFFF),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF6366F1).withValues(alpha: 0.3),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF6366F1,
                            ).withValues(alpha: 0.05),
                            blurRadius: 4,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.auto_awesome_rounded,
                            size: 13,
                            color: Color(0xFF818CF8),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            replyItem.label,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

/// A suggestion chip of a [QuickRepliesWidget].
@GenUiData(description: 'A suggestion chip.')
class QuickReplyItem {
  /// The visible chip text.
  final String label;

  /// The value reported when the chip is tapped. Defaults to [label].
  final String? value;

  const QuickReplyItem({required this.label, this.value});
}
