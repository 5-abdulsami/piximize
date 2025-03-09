import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:piximize/model/dropped_file.dart';
import 'package:piximize/services/compress_image_service.dart';
import 'package:piximize/widgets/app_bar.dart';
import 'package:piximize/widgets/dropzone_widget.dart';
import 'package:piximize/widgets/sections/hero_section.dart';
import 'package:piximize/widgets/sections/compression_section.dart';
import 'package:piximize/widgets/sections/preview_section.dart';
import 'package:piximize/widgets/sections/footer_section.dart';
import 'package:piximize/utils/constants.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  DroppedFile? file;
  Uint8List? compressedImageBytes;
  double quality = 80;
  final ScrollController _scrollController = ScrollController();
  bool isCompressing = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isMobile = size.width < AppConstants.mobileBreakpoint;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: customAppBar(context),
      body: Scrollbar(
        controller: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Hero Section
              HeroSection(isMobile: isMobile),

              SizedBox(height: size.height * 0.05),

              // Main content container
              Container(
                width: isMobile ? size.width * 0.9 : size.width * 0.8,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(24),
                margin: EdgeInsets.only(bottom: size.height * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Upload Section
                    _buildUploadSection(isMobile, size),

                    // Compression Settings Section
                    if (file != null) ...[
                      SizedBox(height: size.height * 0.04),
                      const Divider(),
                      SizedBox(height: size.height * 0.04),

                      CompressionSection(
                        file: file!,
                        compressedImageBytes: compressedImageBytes,
                        quality: quality,
                        isMobile: isMobile,
                        onQualityChanged: _handleQualityChange,
                      ),

                      SizedBox(height: size.height * 0.04),
                      const Divider(),
                      SizedBox(height: size.height * 0.04),

                      // Preview Section
                      PreviewSection(
                        file: file,
                        compressedImageBytes: compressedImageBytes,
                        isCompressing: isCompressing,
                        isMobile: isMobile,
                      ),
                    ],
                  ],
                ),
              ),

              SizedBox(height: size.height * 0.02),

              // Footer
              const FooterSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUploadSection(bool isMobile, Size size) {
    return Column(
      children: [
        Text(
          "Upload Your Image",
          style: GoogleFonts.poppins(
            fontSize: isMobile ? 20 : 24,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: size.height * 0.015),
        Text(
          "Drag & drop or select an image to compress",
          style: GoogleFonts.poppins(
            fontSize: isMobile ? 14 : 16,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: size.height * 0.03),
        DropzoneWidget(
          onDroppedFile: _handleFileDropped,
        ),
      ],
    );
  }

  Future<void> _handleFileDropped(DroppedFile file) async {
    setState(() {
      this.file = file;
      isCompressing = true;
    });

    if (file.fileBytes != null) {
      final compressed = await ImageService.compressImage(
        file.fileBytes!,
        quality.toInt(),
      );

      setState(() {
        compressedImageBytes = compressed;
        isCompressing = false;
      });

      _scrollToPreview();
    }
  }

  Future<void> _handleQualityChange(double value) async {
    setState(() {
      quality = value;
      isCompressing = true;
    });

    if (file != null && file!.fileBytes != null) {
      final compressed = await ImageService.compressImage(
        file!.fileBytes!,
        quality.toInt(),
      );

      setState(() {
        compressedImageBytes = compressed;
        isCompressing = false;
      });
    }
  }

  void _scrollToPreview() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent * 0.7,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOut,
        );
      }
    });
  }
}
