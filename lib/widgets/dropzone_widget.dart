import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:piximize/model/dropped_file.dart';
import 'package:piximize/utils/colors.dart';
import 'package:image_picker_web/image_picker_web.dart';

class DropzoneWidget extends StatefulWidget {
  final ValueChanged<DroppedFile> onDroppedFile;
  const DropzoneWidget({super.key, required this.onDroppedFile});

  @override
  State<DropzoneWidget> createState() => _DropzoneWidgetState();
}

class _DropzoneWidgetState extends State<DropzoneWidget> {
  late DropzoneViewController controller;
  Uint8List? imageBytes;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(color: Colors.green),
      child: Stack(
        children: [
          DropzoneView(
            onCreated: (controller) => this.controller = controller,
            onDropFile: acceptFile,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.upload_file,
                  color: whiteColor,
                  size: 80,
                ),
                Text(
                  "Drop Files here",
                  style: TextStyle(color: whiteColor),
                ),
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
                    Icons.image,
                    color: whiteColor,
                    size: 30,
                  ),
                  label: Text("Select Image",
                      style: GoogleFonts.poppins(
                          color: whiteColor, fontSize: size.width * 0.015)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future acceptFile(dynamic event) async {
    final name = event.name;

    final mime = await controller.getFileMIME(event);
    final bytes = await controller.getFileSize(event);
    final url = await controller.createFileUrl(event);

    print("File Name: $name");
    print("File Mime: $mime");
    print("File Bytes: $bytes");
    print("File url: $url");

    final droppedFile = DroppedFile(
      name: name,
      mime: mime,
      bytes: bytes,
      url: url,
    );

    widget.onDroppedFile(droppedFile);
  }
}
