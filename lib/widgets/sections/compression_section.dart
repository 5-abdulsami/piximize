import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:piximize/model/dropped_file.dart';
import 'package:piximize/widgets/dropped_file_widget.dart';
import 'package:piximize/widgets/sections/compression_stats_card.dart';
import 'package:piximize/widgets/quality_slider.dart';

class CompressionSection extends StatelessWidget {
  final DroppedFile file;
  final Uint8List? compressedImageBytes;
  final double quality;
  final bool isMobile;
  final Function(double) onQualityChanged;

  const CompressionSection({
    super.key,
    required this.file,
    required this.compressedImageBytes,
    required this.quality,
    required this.isMobile,
    required this.onQualityChanged,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        Text(
          "Compression Settings",
          style: GoogleFonts.poppins(
            fontSize: isMobile ? 20 : 24,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: size.height * 0.02),

        // File info and compression stats
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 0 : size.width * 0.05,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: DroppedFileWidget(file: file),
              ),
              SizedBox(
                width: isMobile ? 0 : size.width * 0.05,
              ),
              if (compressedImageBytes != null && !isMobile)
                Expanded(
                  child: CompressionStatsCard(
                    originalSize: file.bytes,
                    compressedSize: compressedImageBytes!.length,
                  ),
                ),
            ],
          ),
        ),

        SizedBox(height: size.height * 0.03),

        // Quality slider with better explanation
        _buildQualitySlider(size),
      ],
    );
  }

  Widget _buildQualitySlider(Size size) {
    return Container(
      width: isMobile ? double.infinity : size.width * 0.63,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Text(
            "Adjust Compression Quality",
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Higher quality means larger file size. Lower quality means smaller file size.",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          QualitySlider(
            value: quality,
            onChanged: onQualityChanged,
          ),
        ],
      ),
    );
  }
}
