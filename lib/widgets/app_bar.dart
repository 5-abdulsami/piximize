import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:piximize/utils/colors.dart';

AppBar customAppBar(BuildContext context) {
  var size = MediaQuery.of(context).size;
  return AppBar(
    elevation: 0,
    shadowColor: blackColor,
    bottom: PreferredSize(
      preferredSize: Size.fromHeight(1.0),
      child: Divider(
        height: 1.0,
        thickness: 1.0,
        color: Colors.grey,
      ),
    ),
    toolbarHeight: size.height * 0.1,
    backgroundColor: const Color.fromARGB(255, 56, 55, 68),
    title: Row(
      children: [
        SizedBox(width: size.width * 0.01),
        Image.asset(
          "assets/images/piximize_logo.png",
          width: size.width * 0.0315,
          height: size.width * 0.0315,
        ),
        SizedBox(width: size.width * 0.006),
        Text(
          'Piximize',
          style: GoogleFonts.pacifico(
              color: whiteColor, fontSize: size.width * 0.018),
        ),
      ],
    ),
  );
}
