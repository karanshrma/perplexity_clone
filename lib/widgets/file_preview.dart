import 'package:flutter/material.dart';
import 'dart:typed_data';
import '../theme/colors.dart';

class FilePreview extends StatelessWidget {
  const FilePreview({
    super.key,
    required this.imageBytes,
    required this.filename,
    this.onRemove,
  });

  final Uint8List imageBytes;
  final String filename;
  final VoidCallback? onRemove;

  // Helper method to determine if file is an image
  bool _isImageFile(String filename) {
    final ext = filename.toLowerCase().split('.').last;
    return ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'].contains(ext);
  }

  // Helper method to get appropriate icon for file type
  IconData _getFileIcon(String filename) {
    final ext = filename.toLowerCase().split('.').last;
    switch (ext) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'txt':
        return Icons.text_snippet;
      case 'csv':
        return Icons.table_chart;
      case 'json':
        return Icons.code;
      default:
        return Icons.insert_drive_file;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
      decoration: BoxDecoration(
        color: AppColors.searchBarBorder.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: AppColors.searchBarBorder.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // File preview (image or icon)
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.grey[100],
            ),
            child: _isImageFile(filename)
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.memory(
                      imageBytes,
                      width: 32,
                      height: 32,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.broken_image,
                          color: Colors.grey[400],
                          size: 16,
                        );
                      },
                    ),
                  )
                : Icon(
                    _getFileIcon(filename),
                    color: Colors.grey[600],
                    size: 18,
                  ),
          ),
          const SizedBox(width: 8),
          // Filename
          Flexible(
            child: Text(
              filename,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textGrey,
                fontWeight: FontWeight.w400,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          const SizedBox(width: 8),
          // Remove button
          if (onRemove != null)
            GestureDetector(
              onTap: onRemove,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, size: 12, color: Colors.black54),
              ),
            ),
        ],
      ),
    );
  }
}
