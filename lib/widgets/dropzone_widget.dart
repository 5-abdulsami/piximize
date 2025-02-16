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

  const DropzoneWidget({super.key, required this.onDroppedFile});

  @override
  State<DropzoneWidget> createState() => _DropzoneWidgetState();
}

class _DropzoneWidgetState extends State<DropzoneWidget> {
  late DropzoneViewController controller;
  bool isHighlighted = false;
  Uint8List? imageBytes;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.6,
      height: size.height * 0.4,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          border:
              Border.all(color: primaryColor.withValues(alpha: 0.4), width: 2),
          color:
              isHighlighted ? greenColor : primaryColor.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(size.width * 0.026)),
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: Radius.circular(size.width * 0.02),
        color: whiteColor,
        strokeWidth: 2,
        dashPattern: [7, 7],
        child: Stack(
          children: [
            DropzoneView(
              onCreated: (controller) => this.controller = controller,
              onHover: () => setState(() => isHighlighted = true),
              onLeave: () => setState(() => isHighlighted = false),
              onDropFile: acceptFile,
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: size.height * 0.01),
                  ElevatedButton.icon(
                    onHover: (value) => setState(() {}),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(size.width * 0.15, size.height * 0.1),
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () async {
                      final events = await controller.pickFiles();
                      if (events.isEmpty) return;

                      acceptFile(events.first);
                    },
                    icon: Icon(
                      Icons.image_outlined,
                      color: whiteColor,
                      size: 28,
                    ),
                    label: Text("Select Image",
                        style: GoogleFonts.poppins(
                            color: whiteColor, fontSize: size.width * 0.013)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future acceptFile(dynamic event) async {
    final name = event.name;

    final mime = await controller.getFileMIME(event);
    final bytes = await controller.getFileSize(event);
    final url = await controller.createFileUrl(event);
    final fileBytes = await controller.getFileData(event); // Get raw image data

    log("File Name: $name");
    log("File Mime: $mime");
    log("File Bytes: $bytes");
    log("File url: $url");

    final droppedFile = DroppedFile(
      name: name,
      mime: mime,
      bytes: bytes,
      url: url,
      fileBytes: fileBytes, // Pass raw image data here
    );

    widget.onDroppedFile(droppedFile);
    setState(() => isHighlighted = false);
  }
}
