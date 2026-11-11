import 'package:flutter/material.dart';

class AppTheme {
  // Warna dari gambar palette
  static const Color white = Color(0xFFFFFFFF);
  static const Color fogGrey = Color(0xFFCCCCCC);
  static const Color smokeGrey = Color(0xFF7D7D7D);
  static const Color ironGrey = Color(0xFF4D4D4D);
  static const Color midnightGrey = Color(0xFF262626);
  static const Color black = Color(0xFF1A1A1A);

  // Pengaturan Tema
  static const Color bgColor = white;
  static const Color textColor = black;
  static const Color textSecondary = smokeGrey;
  static const Color cardColor =
      white; // Karena kita tidak pakai card, ini buat input
  static const Color borderColor = fogGrey;
  static const Color veryLightGrey = Color(0xFFF5F5F5);

  // Ukuran Font
  static const double fontXS = 12.0;
  static const double fontSM = 14.0;
  static const double fontMD = 16.0;
  static const double fontLG = 20.0;
  static const double fontXL = 26.0;
}
