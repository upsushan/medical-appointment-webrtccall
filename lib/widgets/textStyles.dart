import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medical/utils/colors.dart';

class AppTextStyles {
  TextStyle primaryStyle = GoogleFonts.sora(
    color: AppColors.mainTextColor,
    fontSize: 28,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.25,
  );

  TextStyle secondaryStyle = GoogleFonts.sora(
    color: AppColors.secondaryColor,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  TextStyle labelStyle = GoogleFonts.sora(
    color: AppColors.secondaryColor,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.40,
  );

  TextStyle hintStyle = GoogleFonts.sora(
    color: Color(0xFF2A2A37),
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
}
