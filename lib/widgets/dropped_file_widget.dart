import 'package:flutter/material.dart';
import 'package:piximize/model/dropped_file.dart';
import 'package:piximize/utils/colors.dart';

class DroppedFileWidget extends StatelessWidget {
  final DroppedFile file;
  const DroppedFileWidget({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildImage(),
        if (file != null) buildFileDetails(file),
      ],
    );
  }

  Widget buildImage() {
    if (file == null) return buildEmptyFile("No File");

    return Image.network(
      file.url,
      width: 120,
      height: 120,
      fit: BoxFit.cover,
      errorBuilder: (context, error, _) => buildEmptyFile("No Preview"),
    );
  }

  Widget buildEmptyFile(String text) {
    return Container(
      width: 120,
      height: 120,
      color: primaryColor,
      child: Center(
          child: Text(
        text,
        style: TextStyle(color: whiteColor),
      )),
    );
  }

  Widget buildFileDetails(DroppedFile file) {
    return Column(
      children: [
        Text(
          file.name,
          style: TextStyle(color: blackColor),
        ),
        Text(file.mime, style: TextStyle(color: blackColor)),
        Text(file.size, style: TextStyle(color: blackColor)),
      ],
    );
  }
}
