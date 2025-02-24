import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_saver/file_saver.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:piximize/model/dropped_file.dart';
import 'package:piximize/utils/colors.dart';
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
    var size = MediaQuery.of(context).size;
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(size.width * 0.15, size.height * 0.1),
        backgroundColor: primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
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
      icon: Icon(
        Icons.download,
        color: whiteColor,
        size: 28,
      ),
      label: Text("Download Compressed Image",
          style: GoogleFonts.poppins(
              color: whiteColor, fontSize: size.width * 0.013)),
    );
  }
}
