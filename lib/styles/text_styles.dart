import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'color_styles.dart';

class MyTextStyles {
  static final header = GoogleFonts.inter(
    textStyle: const TextStyle(
      color: ColorStyle.blackColor,
      fontSize: 20,
      fontWeight: FontWeight.w700,
    ),
  );
  static final headerlight = GoogleFonts.inter(
    textStyle: const TextStyle(
      color: ColorStyle.blackColor,
      fontSize: 20,
      fontWeight: FontWeight.w400,
    ),
  );

  static final button = GoogleFonts.inter(
    textStyle: const TextStyle(
      color: ColorStyle.whiteColor,
      fontSize: 20,
      fontWeight: FontWeight.w700,
    ),
  );

  static final text = GoogleFonts.inter(
    textStyle: const TextStyle(
      color: ColorStyle.blackColor,
      fontSize: 15,
      fontWeight: FontWeight.w400,
    ),
  );

  static final textBold = GoogleFonts.inter(
    textStyle: const TextStyle(
      color: ColorStyle.blackColor,
      fontSize: 15,
      fontWeight: FontWeight.w700,
    ),
  );

  static final inputField = GoogleFonts.inter(
    textStyle: const TextStyle(
      color: ColorStyle.whiteColor,
      fontSize: 18,
      fontWeight: FontWeight.w300,
    ),
  );

  static final size10 = GoogleFonts.inter(
    textStyle: const TextStyle(
      color: ColorStyle.blackColor,
      fontSize: 10,
      fontWeight: FontWeight.w400,
    ),
  );
}
