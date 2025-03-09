import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:piximize/model/dropped_file.dart';
import 'package:piximize/widgets/image_preview.dart';
import 'package:piximize/widgets/download_button.dart';
import 'package:piximize/utils/colors.dart';

class PreviewSection extends StatelessWidget {
  final DroppedFile? file;
  final Uint8List? compressedImageBytes;
  final bool isCompressing;
  final bool isMobile;

  const PreviewSection({
    super.key,
    required this.file,
    required this.compressedImageBytes,
    required this.isCompressing,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        Text(
          "Preview & Download",
          style: GoogleFonts.poppins(
            fontSize: isMobile ? 20 : 24,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Compare original and compressed images",
          style: GoogleFonts.poppins(
            fontSize: isMobile ? 14 : 16,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: size.height * 0.03),
        if (isCompressing)
          _buildLoadingIndicator()
        else if (file != null && compressedImageBytes != null)
          _buildPreviewAndDownload(size),
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    return SizedBox(
      height: 500,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
            ),
            const SizedBox(height: 16),
            Text(
              "Compressing your image...",
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewAndDownload(Size size) {
    return Column(
      children: [
        // Image preview with comparison slider
        Container(
          width: isMobile ? double.infinity : size.width * 0.6,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 0,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: ImagePreview(
              originalImage: file!.fileBytes!,
              compressedImage: compressedImageBytes!,
            ),
          ),
        ),

        SizedBox(height: size.height * 0.05),

        // Download button
        DownloadButton(
          compressedImage: compressedImageBytes!,
          file: file,
        ),
      ],
    );
  }
}
