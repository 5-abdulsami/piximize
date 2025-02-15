import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:piximize/model/dropped_file.dart';
import 'package:piximize/utils/colors.dart';
import 'package:piximize/widgets/app_bar.dart';
import 'package:piximize/widgets/dropped_file_widget.dart';
import 'package:piximize/widgets/dropzone_widget.dart';
import 'package:piximize/widgets/piximize.dart';
import 'package:piximize/widgets/quality_slider.dart';
import 'package:piximize/widgets/image_preview.dart';
import 'package:piximize/widgets/download_button.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  DroppedFile? file;
  Uint8List? compressedImageBytes;
  double quality = 80;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: customAppBar(context),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: size.height * 0.08),
              piximize(fontSize: size.width * 0.04),
              Text(
                "Compress your images without losing quality",
                style: GoogleFonts.poppins(fontSize: size.width * 0.013),
              ),
              SizedBox(height: size.height * 0.1),
              DroppedFileWidget(file: file),
              SizedBox(height: size.height * 0.02),
              SizedBox(
                height: size.height * 0.5,
                width: size.width * 0.5,
                child: DropzoneWidget(
                  onDroppedFile: (file) async {
                    setState(() {
                      this.file = file;
                    });
                    if (file.fileBytes != null) {
                      compressedImageBytes =
                          await _compressImage(file.fileBytes!);
                      setState(() {});
                    }
                  },
                ),
              ),
              SizedBox(height: size.height * 0.02),
              if (file != null)
                QualitySlider(
                  value: quality,
                  onChanged: (value) async {
                    setState(() => quality = value);
                    if (file != null && file!.fileBytes != null) {
                      compressedImageBytes =
                          await _compressImage(file!.fileBytes!);
                      setState(() {});
                    }
                  },
                ),
              SizedBox(height: size.height * 0.02),
              if (file != null && compressedImageBytes != null)
                ImagePreview(
                  originalImage: file!.fileBytes!,
                  compressedImage: compressedImageBytes!,
                ),
              SizedBox(height: size.height * 0.02),
              if (compressedImageBytes != null)
                DownloadButton(
                  compressedImage: compressedImageBytes!,
                  fileName: file?.name ?? 'compressed_image.jpg',
                ),
              SizedBox(height: size.height * 0.14),
            ],
          ),
        ),
      ),
    );
  }

  Future<Uint8List> _compressImage(Uint8List bytes) async {
    final result = await FlutterImageCompress.compressWithList(
      bytes,
      quality: quality.toInt(),
    );
    return result;
  }
}
