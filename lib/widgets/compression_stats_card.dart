import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:piximize/utils/colors.dart';

class CompressionStatsCard extends StatelessWidget {
  final int originalSize;
  final int compressedSize;

  const CompressionStatsCard({
    Key? key,
    required this.originalSize,
    required this.compressedSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final compressionRatio = (1 - (compressedSize / originalSize)) * 100;
    final savedSpace = originalSize - compressedSize;

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
          Text(
            'Compression Results',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 16),

          // Compression ratio indicator
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.auto_awesome,
                  color: primaryColor,
                  size: 24,
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${compressionRatio.toStringAsFixed(1)}%',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    Text(
                      'Size Reduction',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 16),

          // Detailed stats
          _buildStatRow(
            'Original Size',
            _formatFileSize(originalSize),
            Icons.photo_outlined,
          ),
          SizedBox(height: 12),
          _buildStatRow(
            'Compressed Size',
            _formatFileSize(compressedSize),
            Icons.compress,
          ),
          SizedBox(height: 12),
          _buildStatRow(
            'Space Saved',
            _formatFileSize(savedSpace),
            Icons.save_outlined,
            highlight: true,
          ),

          // Progress bar
          SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Size Comparison',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 8),
              Stack(
                children: [
                  // Background bar
                  Container(
                    height: 8,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  // Foreground bar
                  Container(
                    height: 8,
                    width: (compressedSize / originalSize) * double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          primaryColor,
                          primaryColor.withOpacity(0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Compressed',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    'Original',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value, IconData icon,
      {bool highlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: highlight ? primaryColor : Colors.grey[600],
            ),
            SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: highlight ? FontWeight.w600 : FontWeight.normal,
            color: highlight ? primaryColor : Colors.grey[800],
          ),
        ),
      ],
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
