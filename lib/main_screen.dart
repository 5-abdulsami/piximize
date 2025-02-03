import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:piximize/utils/colors.dart';
import 'package:piximize/widgets/app_bar.dart';
import 'package:piximize/widgets/piximize.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
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
              height: size.height * 0.5,
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(width: 3, color: primaryColor),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onHover: (value) => setState(() {}),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(size.width * 0.15, size.height * 0.1),
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {},
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
