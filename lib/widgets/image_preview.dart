import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:piximize/utils/colors.dart';

class ImagePreview extends StatefulWidget {
  final Uint8List? originalImage;
  final Uint8List? compressedImage;

  const ImagePreview({
    super.key,
    this.originalImage,
    this.compressedImage,
  });

  @override
  ImagePreviewState createState() => ImagePreviewState();
}

class ImagePreviewState extends State<ImagePreview> {
  double _sliderValue = 0.5;
  bool _isDragging = false;
  final double imageWidth = 400;
  final GlobalKey _imageKey = GlobalKey();
  Size? _imageSize;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateImageSize();
    });
  }

  void _updateImageSize() {
    final RenderBox? renderBox =
        _imageKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      setState(() {
        _imageSize = renderBox.size;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.originalImage == null || widget.compressedImage == null) {
      return _buildPlaceholder();
    }

    return Column(
      children: [
        // Image comparison container
        Center(
          child: Container(
            height: 250,
            key: _imageKey,
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
              child: Stack(
                children: [
                  // Base image (compressed)
                  SizedBox(
                    width: imageWidth,
                    child: Image.memory(
                      widget.compressedImage!,
                      fit: BoxFit.contain,
                    ),
                  ),
                  // Overlay image (original)
                  ClipRect(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      widthFactor: _sliderValue,
                      child: SizedBox(
                        width: imageWidth,
                        child: Image.memory(
                          widget.originalImage!,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  // Labels
                  _buildImageLabels(),
                  // Slider handle
                  _buildSliderHandle(),
                  // Touch overlay for mobile
                  Positioned.fill(
                    child: GestureDetector(
                      onHorizontalDragStart: (_) =>
                          setState(() => _isDragging = true),
                      onHorizontalDragEnd: (_) =>
                          setState(() => _isDragging = false),
                      onHorizontalDragUpdate: (details) {
                        if (_imageSize != null) {
                          setState(() {
                            _sliderValue +=
                                details.primaryDelta! / _imageSize!.width;
                            _sliderValue = _sliderValue.clamp(0.0, 1.0);
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
        // Instructions
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.swipe,
                size: 20,
                color: primaryColor,
              ),
              SizedBox(width: 8),
              Text(
                'Drag slider to compare images',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: imageWidth,
      height: 150,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_outlined,
            size: 48,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'No image to preview',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageLabels() {
    return Stack(
      children: [
        // Original image label
        Positioned(
          top: 16,
          left: 16,
          child: _buildLabel(
            'Original',
            _sliderValue > 0.1,
            alignment: Alignment.centerLeft,
          ),
        ),
        // Compressed image label
        Positioned(
          top: 16,
          right: 16,
          child: _buildLabel(
            'Compressed',
            _sliderValue < 0.9,
            alignment: Alignment.centerRight,
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text, bool isVisible,
      {required Alignment alignment}) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 200),
      opacity: isVisible ? 1.0 : 0.0,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildSliderHandle() {
    return Positioned(
      left: (_imageSize?.width ?? imageWidth) * _sliderValue - 16,
      top: 0,
      bottom: 0,
      child: MouseRegion(
        cursor: SystemMouseCursors.resizeLeftRight,
        child: Container(
          width: 32,
          child: Center(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              width: 4,
              height: _isDragging ? 80 : 40,
              decoration: BoxDecoration(
                color: _isDragging ? primaryColor : Colors.white,
                borderRadius: BorderRadius.circular(2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    spreadRadius: 0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
