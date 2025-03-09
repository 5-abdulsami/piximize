import 'dart:typed_data';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImageService {
  /// Compresses an image with the specified quality
  static Future<Uint8List> compressImage(Uint8List bytes, int quality) async {
    final result = await FlutterImageCompress.compressWithList(
      bytes,
      quality: quality,
    );
    return result;
  }
}
