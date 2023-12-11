import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._(); // This class shouldn't be instantiated

  // princetonOrange color
  static Color princetonOrange = const Color(0xFFF58025);

  // Button grey color
  static Color buttonGrey = const Color(0xFFD9D9D9);

  // Artwork Title TextStyle
  static TextStyle artworkTitle = GoogleFonts.libreCaslonDisplay(
    color: Colors.black,
    fontSize: 40,
    fontWeight: FontWeight.bold,
  );

  // Artist TextStyle
  static TextStyle artistName = GoogleFonts.roboto(
    color: Colors.white,
    fontSize: 12,
    fontWeight: FontWeight.w700,
    height: 0.09,
  );

  // Year TextStyle
  static TextStyle yearText = GoogleFonts.roboto(
    color: Colors.black,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 0.09,
  );

  static BoxDecoration circleText = BoxDecoration(
    color: const Color(0xFF3C4450),
    borderRadius: BorderRadius.circular(50),
  );

  // Materials of the Painting TextStyle
  static TextStyle materialsText = GoogleFonts.inter(
    color: Colors.black,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 0.11,
  );

  // Page title TextStyle
  static TextStyle pageTitle = GoogleFonts.playfairDisplay(
    color: Colors.black,
    fontSize: 30,
    fontWeight: FontWeight.w400,
  );

  // Artwork Description TextStyle
  static TextStyle artworkDescription = GoogleFonts.roboto(
    color: Colors.black,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  // Sign up TextStyle
  static TextStyle signUp = GoogleFonts.lato(
    color: Colors.white,
    fontSize: 25,
    fontWeight: FontWeight.w700,
    height: 0.09,
  );

  // Sign up TextStyle
  static TextStyle username = GoogleFonts.roboto(
    color: Colors.black,
    fontSize: 25,
    fontWeight: FontWeight.w700,
    height: 0.09,
  );

  // Category Item TextStyle
  static TextStyle categoryItem = GoogleFonts.roboto(
    color: Colors.black,
    fontSize: 15,
    fontWeight: FontWeight.w600,
  );
}
