import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_saver/file_saver.dart';
import 'package:piximize/model/dropped_file.dart';
import 'package:piximize/utils/utils.dart';

class DownloadButton extends StatelessWidget {
  final Uint8List? compressedImage;
  final DroppedFile? file;

  const DownloadButton({
    super.key,
    required this.compressedImage,
    required this.file,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: compressedImage != null
          ? () async {
              // Remove the existing extension from the file name
              String fileNameWithoutExtension =
                  file!.name.replaceAll(RegExp(r'\.\w+$'), '');

              await FileSaver.instance
                  .saveFile(
                name:
                    '${fileNameWithoutExtension}_compressed', // Name without extension
                bytes: compressedImage!,
                ext: file?.mime.split('/').last ??
                    'jpg', // Use the correct extension
              )
                  .then((_) {
                Utils.toastMessage("Image Downloaded Successfully");
              });
            }
          : null,
      icon: Icon(Icons.download),
      label: Text('Download Compressed Image'),
    );
  }
}
