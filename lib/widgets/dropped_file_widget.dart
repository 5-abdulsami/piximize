import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:piximize/model/dropped_file.dart';
import 'package:piximize/utils/colors.dart';

class DroppedFileWidget extends StatelessWidget {
  final DroppedFile? file;

  const DroppedFileWidget({
    super.key,
    required this.file,
  });

  @override
  Widget build(BuildContext context) {
    if (file == null) return SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // File name and type header
          Row(
            children: [
              _buildFileTypeIcon(),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _truncateFileName(file!.name),
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      _getFileType(),
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              _buildValidationBadge(),
            ],
          ),
          SizedBox(height: 16),
          Divider(),
          SizedBox(height: 16),

          // File details
          _buildDetailRow(
            'Size',
            _formatFileSize(file!.bytes),
            Icons.data_usage,
          ),
          SizedBox(height: 12),
          _buildDetailRow(
            'Format',
            _getFileFormat(),
            Icons.image,
          ),
          SizedBox(height: 12),
          _buildDetailRow(
            'Status',
            'Ready to compress',
            Icons.check_circle_outline,
            statusColor: Colors.green,
          ),

          // File recommendations
          if (_shouldShowRecommendations())
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                Divider(),
                SizedBox(height: 16),
                Text(
                  'Recommendations',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 8),
                ..._buildRecommendations(),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildFileTypeIcon() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        _getFileTypeIcon(),
        color: primaryColor,
        size: 24,
      ),
    );
  }

  Widget _buildValidationBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle,
            color: Colors.green[600],
            size: 16,
          ),
          SizedBox(width: 4),
          Text(
            'Valid',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.green[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon,
      {Color? statusColor}) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 16,
            color: statusColor ?? Colors.grey[600],
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: statusColor ?? Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildRecommendations() {
    final List<Widget> recommendations = [];

    if (file!.bytes > 5 * 1024 * 1024) {
      recommendations.add(
        _buildRecommendationItem(
          'Large file detected',
          'Consider using a higher compression rate',
          Icons.warning_amber_rounded,
          Colors.amber[700]!,
        ),
      );
    }

    if (_getFileFormat().toLowerCase() == 'png') {
      recommendations.add(
        _buildRecommendationItem(
          'PNG detected',
          'Converting to JPEG might reduce file size further',
          Icons.lightbulb_outline,
          Colors.blue[600]!,
        ),
      );
    }

    return recommendations;
  }

  Widget _buildRecommendationItem(
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 16,
              color: color,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[800],
                  ),
                ),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _truncateFileName(String fileName) {
    if (fileName.length > 25) {
      return '${fileName.substring(0, 20)}...${fileName.substring(fileName.lastIndexOf('.'))}';
    }
    return fileName;
  }

  IconData _getFileTypeIcon() {
    final format = _getFileFormat().toLowerCase();
    switch (format) {
      case 'png':
        return Icons.image_outlined;
      case 'jpg':
      case 'jpeg':
        return Icons.photo_outlined;
      case 'webp':
        return Icons.web_asset_outlined;
      default:
        return Icons.insert_drive_file_outlined;
    }
  }

  String _getFileType() {
    return 'Image File (${_getFileFormat().toUpperCase()})';
  }

  String _getFileFormat() {
    return file!.mime.split('/').last.toUpperCase();
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  bool _shouldShowRecommendations() {
    return file!.bytes > 5 * 1024 * 1024 ||
        _getFileFormat().toLowerCase() == 'png';
  }
}
