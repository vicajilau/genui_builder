import 'package:flutter/material.dart';
import 'package:genui_gen/genui_gen.dart';

part 'attachment_list_widget.genui.dart';

/// A custom premium list widget to display file attachments.
@GenUiWidget(
  description: 'A custom premium list widget to display file attachments.',
)
class AttachmentListWidget extends StatelessWidget {
  /// The files to list.
  final List<AttachmentItem> items;

  /// The list title.
  final String title;

  /// The name of the file the user tapped last. Bind it to a data path and
  /// read that path from the `onTapItem` action's context.
  final String? selectedFile;

  /// Writes the tapped file name into `selectedFile`.
  @GenUiWrites('selectedFile')
  final ValueChanged<String>? onSelectFile;

  /// Fired when the user taps a file, after `selectedFile` is written.
  @GenUiAction(eventName: 'onTapItem')
  final VoidCallback? onTapItem;

  const AttachmentListWidget({
    super.key,
    required this.items,
    this.title = 'Attachments',
    this.selectedFile,
    this.onSelectFile,
    this.onTapItem,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0x1F1E293B), // Premium Slate translucent
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header title
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 12),
          // Attachments list
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'No attachments available.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.4),
                  fontStyle: FontStyle.italic,
                ),
              ),
            )
          else
            Column(
              children: items.map((item) {
                final name = item.name;
                final type = item.type;
                final size = item.size;

                final fileIcon = (() {
                  switch (type.toLowerCase()) {
                    case 'image':
                      return Icons.image_outlined;
                    case 'pdf':
                      return Icons.picture_as_pdf_outlined;
                    case 'file':
                      return Icons.insert_drive_file_outlined;
                    case 'audio':
                      return Icons.audio_file_outlined;
                    case 'video':
                      return Icons.video_file_outlined;
                    case 'document':
                      return Icons.article_outlined;
                    case 'folder':
                      return Icons.folder_outlined;
                    case 'spreadsheet':
                      return Icons.table_chart_outlined;
                    case 'archive':
                      return Icons.archive_outlined;
                    default:
                      return Icons.insert_drive_file_outlined;
                  }
                })();

                final iconColor = (() {
                  switch (type.toLowerCase()) {
                    case 'image':
                      return const Color(0xFF10B981);
                    case 'pdf':
                      return const Color(0xFFEF4444);
                    case 'audio':
                      return const Color(0xFFF59E0B);
                    case 'video':
                      return const Color(0xFF3B82F6);
                    case 'document':
                      return const Color(0xFFFAF200);
                    case 'folder':
                      return const Color(0xFFFB8200);
                    case 'spreadsheet':
                      return const Color(0xFF10B981);
                    case 'archive':
                      return const Color(0xFF44EF6F);
                    default:
                      return const Color(0xFF3B8200);
                  }
                })();

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: InkWell(
                    onTap: onTapItem != null
                        ? () {
                            onSelectFile?.call(name);
                            onTapItem!();
                          }
                        : null,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0x0DFFFFFF),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.05),
                        ),
                      ),
                      child: Row(
                        children: [
                          // File icon with type-specific color glow
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: iconColor.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(fileIcon, color: iconColor, size: 18),
                          ),
                          const SizedBox(width: 12),
                          // Details (name, size)
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                if (size != null && size.isNotEmpty) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    size,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.white.withValues(
                                        alpha: 0.4,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Action icon
                          Icon(
                            Icons.open_in_new_rounded,
                            color: Colors.white.withValues(alpha: 0.4),
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}

/// A file shown in an [AttachmentListWidget].
@GenUiData(description: 'A file in an attachment list.')
class AttachmentItem {
  /// The file name, including its extension.
  final String name;

  /// The file type: 'pdf', 'image', 'document', 'spreadsheet', 'audio',
  /// 'video', 'archive', 'folder' or 'file'.
  final String type;

  /// The human-readable file size, e.g. '2.4 MB'.
  final String? size;

  const AttachmentItem({required this.name, this.type = 'file', this.size});
}
