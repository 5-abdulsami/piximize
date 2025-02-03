import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:piximize/utils/colors.dart';

Widget piximize({required double fontSize}) {
  return Text(
    "Piximize",
    style: GoogleFonts.pacifico(color: primaryColor, fontSize: fontSize),
  );
}
