import 'dart:typed_data';
import 'package:flutter/material.dart';

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
  final double imageWidth = 400; // Set a fixed image width

  @override
  Widget build(BuildContext context) {
    if (widget.originalImage == null || widget.compressedImage == null) {
      return Center(child: Text('No images available'));
    }

    return Center(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 3),
        ),
        child: Stack(
          children: [
            SizedBox(
              width: imageWidth,
              child: Image.memory(widget.compressedImage!),
            ),
            ClipRect(
              child: Align(
                alignment: Alignment.centerLeft,
                widthFactor: _sliderValue,
                child: SizedBox(
                  width: imageWidth,
                  child: Image.memory(widget.originalImage!),
                ),
              ),
            ),
            Positioned(
              top: 10,
              left: 10,
              child: Text(
                'Original Image',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  backgroundColor: Colors.black54,
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Text(
                'Compressed Image',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  backgroundColor: Colors.black54,
                ),
              ),
            ),
            Positioned(
              left: imageWidth * _sliderValue - 12.5,
              top: 0,
              bottom: 0,
              child: GestureDetector(
                onHorizontalDragUpdate: (details) {
                  setState(() {
                    _sliderValue += details.primaryDelta! / imageWidth;
                    _sliderValue = _sliderValue.clamp(0.0, 1.0);
                  });
                },
                child: Container(
                  width: 25,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.drag_handle,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
