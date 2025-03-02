import 'dart:developer';
import 'dart:typed_data';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:piximize/model/dropped_file.dart';
import 'package:piximize/utils/colors.dart';

class DropzoneWidget extends StatefulWidget {
  final ValueChanged<DroppedFile> onDroppedFile;

  const DropzoneWidget({
    super.key,
    required this.onDroppedFile,
  });

  @override
  State<DropzoneWidget> createState() => _DropzoneWidgetState();
}

class _DropzoneWidgetState extends State<DropzoneWidget> {
  late DropzoneViewController controller;
  bool isHighlighted = false;
  bool isDragging = false;
  String? errorMessage;
  bool isProcessing = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    bool isMobile = size.width < 768;

    return Stack(
      children: [
        Container(
          width: size.width * (isMobile ? 0.9 : 0.6),
          height: size.height * 0.5,
          decoration: BoxDecoration(
            color: isHighlighted
                ? primaryColor.withOpacity(0.05)
                : Colors.grey[50],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isHighlighted
                  ? primaryColor.withOpacity(0.5)
                  : Colors.grey[300]!,
              width: 2,
            ),
          ),
          child: DottedBorder(
            borderType: BorderType.RRect,
            radius: Radius.circular(16),
            color: isHighlighted ? primaryColor : Colors.grey[400]!,
            strokeWidth: 2,
            dashPattern: [8, 8],
            padding: EdgeInsets.all(16),
            child: Stack(
              children: [
                DropzoneView(
                  onCreated: (controller) => this.controller = controller,
                  onHover: () => _updateHighlightedState(true),
                  onLeave: () => _updateHighlightedState(false),
                  onDrop: acceptFile,
                  onError: (String? message) => _showError(message),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Animated Icon
                      AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        padding: EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: isHighlighted
                              ? primaryColor.withOpacity(0.1)
                              : Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isHighlighted
                                ? primaryColor
                                : Colors.grey[300]!,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          isHighlighted
                              ? Icons.file_download
                              : Icons.cloud_upload_outlined,
                          size: 40,
                          color:
                              isHighlighted ? primaryColor : Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 24),

                      // Main Text
                      Text(
                        isHighlighted
                            ? 'Drop your image here'
                            : 'Drag & Drop your image here',
                        style: GoogleFonts.poppins(
                          fontSize: isMobile ? 16 : 20,
                          fontWeight: FontWeight.w600,
                          color:
                              isHighlighted ? primaryColor : Colors.grey[800],
                        ),
                      ),
                      SizedBox(height: 8),

                      // Supported formats text
                      Text(
                        'Supports: JPG, PNG, WebP • Max size: 10MB',
                        style: GoogleFonts.poppins(
                          fontSize: isMobile ? 12 : 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 24),

                      // Or divider
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Divider(
                              color: Colors.grey[300],
                              endIndent: 16,
                            ),
                          ),
                          Text(
                            'OR',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: Colors.grey[300],
                              indent: 16,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24),

                      // Browse button
                      ElevatedButton(
                        onPressed: isProcessing
                            ? null
                            : () async {
                                try {
                                  final events = await controller.pickFiles(
                                    multiple: false,
                                    mime: [
                                      'image/jpeg',
                                      'image/png',
                                      'image/webp'
                                    ],
                                  );
                                  if (events.isEmpty) return;
                                  acceptFile(events.first);
                                } catch (e) {
                                  _showError('Failed to select image');
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.file_upload_outlined, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Browse Files',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (isProcessing)
                  Container(
                    color: Colors.white.withOpacity(0.8),
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (errorMessage != null)
          Positioned(
            bottom: 16,
            left: 50,
            right: 50,
            child: _buildErrorMessage(),
          ),
      ],
    );
  }

  Widget _buildErrorMessage() {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(8),
      color: Colors.red[50],
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        child: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red[700],
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                errorMessage!,
                style: GoogleFonts.poppins(
                  color: Colors.red[700],
                  fontSize: 14,
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.red[700],
              ),
              onPressed: () => setState(() => errorMessage = null),
            ),
          ],
        ),
      ),
    );
  }

  void _updateHighlightedState(bool highlighted) {
    setState(() {
      isHighlighted = highlighted;
    });
  }

  void _showError(String? message) {
    setState(() {
      errorMessage = message ?? 'An error occurred';
      isProcessing = false;
    });

    // Auto-hide error after 5 seconds
    Future.delayed(Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          errorMessage = null;
        });
      }
    });
  }

  Future<void> acceptFile(dynamic event) async {
    setState(() {
      isProcessing = true;
      errorMessage = null;
    });

    try {
      final name = event.name;
      final mime = await controller.getFileMIME(event);
      final bytes = await controller.getFileSize(event);
      final url = await controller.createFileUrl(event);
      final fileBytes = await controller.getFileData(event);

      // Validate file type
      if (!['image/jpeg', 'image/png', 'image/webp'].contains(mime)) {
        throw 'Unsupported file type. Please use JPG, PNG, or WebP images.';
      }

      // Validate file size (10MB limit)
      if (bytes > 10 * 1024 * 1024) {
        throw 'File size exceeds 10MB limit.';
      }

      final droppedFile = DroppedFile(
        name: name,
        mime: mime,
        bytes: bytes,
        url: url,
        fileBytes: fileBytes,
      );

      widget.onDroppedFile(droppedFile);
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          isProcessing = false;
          isHighlighted = false;
        });
      }
    }
  }
}
