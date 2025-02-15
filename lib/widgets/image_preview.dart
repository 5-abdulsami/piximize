import 'dart:typed_data';

import 'package:flutter/material.dart';

class ImagePreview extends StatelessWidget {
  final Uint8List? originalImage;
  final Uint8List? compressedImage;

  const ImagePreview({
    super.key,
    this.originalImage,
    this.compressedImage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (originalImage != null)
          Column(
            children: [
              Text('Original Image', style: TextStyle(fontSize: 16)),
              Image.memory(originalImage!, height: 200),
            ],
          ),
        if (compressedImage != null)
          Column(
            children: [
              Text('Compressed Image', style: TextStyle(fontSize: 16)),
              Image.memory(compressedImage!, height: 200),
            ],
          ),
      ],
    );
  }
}
