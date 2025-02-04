import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:piximize/services/drag_drop_widget.dart';
import 'package:piximize/utils/colors.dart';
import 'package:piximize/widgets/app_bar.dart';
import 'package:piximize/widgets/piximize.dart';
import 'package:image_picker_web/image_picker_web.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Uint8List? imageBytes;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: customAppBar(context),
      body: SingleChildScrollView(
        child: Center(
          child: Column(children: [
            SizedBox(
              height: size.height * 0.08,
            ),
            piximize(fontSize: size.width * 0.04),
            Text(
              "Compress your images without losing quality",
              style: GoogleFonts.poppins(fontSize: size.width * 0.013),
            ),
            SizedBox(
              height: size.height * 0.14,
            ),
            Container(
              width: size.width * 0.5,
              height: size.height * 0.6,
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(width: 3, color: primaryColor),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    imageBytes != null
                        ? Image.memory(
                            imageBytes!,
                            width: 250,
                            height: 250,
                            filterQuality: FilterQuality.high,
                            fit: BoxFit.contain,
                          )
                        : DragDropWidget(
                            onFileDropped: (bytes) {
                              setState(() => imageBytes = bytes);
                            },
                          ),
                    SizedBox(
                      height: size.height * 0.02,
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
                        Uint8List? bytesFromPicker =
                            await ImagePickerWeb.getImageAsBytes();

                        if (bytesFromPicker != null) {
                          setState(() {
                            imageBytes = bytesFromPicker;
                          });
                        }
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
            ),
            SizedBox(
              height: size.height * 0.14,
            ),
          ]),
        ),
      ),
    );
  }
}
