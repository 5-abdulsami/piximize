import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:piximize/model/dropped_file.dart';
import 'package:piximize/widgets/app_bar.dart';
import 'package:piximize/widgets/dropped_file_widget.dart';
import 'package:piximize/widgets/dropzone_widget.dart';
import 'package:piximize/widgets/piximize.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  DroppedFile? file;
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
            DroppedFileWidget(file: file!),
            Container(
              height: 300,
              child: DropzoneWidget(
                  onDroppedFile: (file) => setState(() => this.file = file)),
            ),
          ]),
        ),
      ),
    );
  }
}
