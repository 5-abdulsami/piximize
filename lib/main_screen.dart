import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:piximize/model/dropped_file.dart';
import 'package:piximize/widgets/app_bar.dart';
import 'package:piximize/widgets/dropped_file_widget.dart';
import 'package:piximize/widgets/dropzone_widget.dart';
import 'package:piximize/widgets/piximize.dart';
import 'package:piximize/widgets/quality_slider.dart';
import 'package:piximize/widgets/image_preview.dart';
import 'package:piximize/widgets/download_button.dart';
import 'package:piximize/utils/colors.dart';
import 'package:piximize/widgets/compression_stats_card.dart';
import 'package:piximize/widgets/feature_card.dart';

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
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    bool isMobile = size.width < 768;

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
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      primaryColor.withOpacity(0.1),
                      primaryColor.withOpacity(0.05),
                    ],
                  ),
                ),
                padding: EdgeInsets.symmetric(
                  vertical: size.height * 0.08,
                  horizontal: size.width * 0.05,
                ),
                child: Column(
                  children: [
                    piximize(fontSize: isMobile ? 32 : size.width * 0.05),
                    SizedBox(height: size.height * 0.02),
                    Text(
                      "Compress images without sacrificing quality",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: isMobile ? 16 : size.width * 0.015,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                    Text(
                      "Reduce file size by up to 90% while maintaining visual clarity",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: isMobile ? 14 : size.width * 0.012,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: size.height * 0.04),

                    // Feature cards
                    if (!isMobile)
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: size.width * 0.05),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FeatureCard(
                              icon: Icons.speed_outlined,
                              title: "Lightning Fast",
                              description: "Compress images in seconds",
                            ),
                            FeatureCard(
                              icon: Icons.lock_outline,
                              title: "100% Secure",
                              description:
                                  "Your images never leave your device",
                            ),
                            FeatureCard(
                              icon: Icons.high_quality_outlined,
                              title: "Quality Control",
                              description: "Adjust compression to your needs",
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              SizedBox(height: size.height * 0.05),

              // Main content container
              Container(
                width: isMobile ? size.width * 0.9 : size.width * 0.8,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                padding: EdgeInsets.all(24),
                margin: EdgeInsets.only(bottom: size.height * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Dropzone Section
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
                      onDroppedFile: (file) async {
                        setState(() {
                          this.file = file;
                          isCompressing = true;
                        });

                        if (file.fileBytes != null) {
                          compressedImageBytes =
                              await _compressImage(file.fileBytes!);
                          setState(() {
                            isCompressing = false;
                          });
                          _scrollToPreview();
                        }
                      },
                    ),

                    // File Details and Compression Controls
                    if (file != null) ...[
                      SizedBox(height: size.height * 0.04),
                      Divider(),
                      SizedBox(height: size.height * 0.04),

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
                            if (compressedImageBytes != null && !isMobile)
                              Expanded(
                                child: CompressionStatsCard(
                                  originalSize: file!.bytes,
                                  compressedSize: compressedImageBytes!.length,
                                ),
                              ),
                          ],
                        ),
                      ),

                      if (compressedImageBytes != null && isMobile)
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: CompressionStatsCard(
                            originalSize: file!.bytes,
                            compressedSize: compressedImageBytes!.length,
                          ),
                        ),

                      SizedBox(height: size.height * 0.03),

                      // Quality slider with better explanation
                      Container(
                        width: isMobile ? double.infinity : size.width * 0.6,
                        padding: EdgeInsets.all(16),
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
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[800],
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Higher quality means larger file size. Lower quality means smaller file size.",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 16),
                            QualitySlider(
                              value: quality,
                              onChanged: (value) async {
                                setState(() {
                                  quality = value;
                                  isCompressing = true;
                                });
                                if (file != null && file!.fileBytes != null) {
                                  compressedImageBytes =
                                      await _compressImage(file!.fileBytes!);
                                  setState(() {
                                    isCompressing = false;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: size.height * 0.04),
                      Divider(),
                      SizedBox(height: size.height * 0.04),

                      // Preview and download section
                      Text(
                        "Preview & Download",
                        style: GoogleFonts.poppins(
                          fontSize: isMobile ? 20 : 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Compare original and compressed images",
                        style: GoogleFonts.poppins(
                          fontSize: isMobile ? 14 : 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: size.height * 0.03),

                      if (isCompressing)
                        Container(
                          height: 300,
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      primaryColor),
                                ),
                                SizedBox(height: 16),
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
                        )
                      else if (file != null && compressedImageBytes != null)
                        Column(
                          children: [
                            // Image preview with comparison slider
                            Container(
                              width:
                                  isMobile ? double.infinity : size.width * 0.6,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
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
                        ),
                    ],
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.02),
              // Footer
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  vertical: size.height * 0.05,
                  horizontal: size.width * 0.05,
                ),
                color: Colors.grey[100],
                child: Column(
                  children: [
                    Text(
                      "Piximize",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "© ${DateTime.now().year} Piximize. All rights reserved.",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FooterLink(text: "Privacy Policy"),
                        SizedBox(width: 24),
                        FooterLink(text: "Terms of Service"),
                        SizedBox(width: 24),
                        FooterLink(text: "Contact Us"),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Uint8List> _compressImage(Uint8List bytes) async {
    final result = await FlutterImageCompress.compressWithList(
      bytes,
      quality: quality.toInt(),
    );
    return result;
  }

  void _scrollToPreview() {
    Future.delayed(Duration(milliseconds: 300), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent * 0.7,
        duration: Duration(milliseconds: 600),
        curve: Curves.easeOut,
      );
    });
  }
}

class FooterLink extends StatelessWidget {
  final String text;

  const FooterLink({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: primaryColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
