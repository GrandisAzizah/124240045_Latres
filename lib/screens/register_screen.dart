import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';
import '../services/database_helper.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // variabel buat liat password
  bool _isPasswordObscured = true;
  bool _isConfirmObscured = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.textColor),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Join the Adventure!",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: AppTheme.fontXL,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Create your explorer's identity",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: AppTheme.fontSM,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 40),

                // Input Nama
                TextField(
                  controller: _nameController,
                  style: GoogleFonts.spaceGrotesk(color: AppTheme.textColor),
                  decoration: _inputDecoration(
                    "Your Name",
                    Icons.person_outline,
                  ),
                ),
                const SizedBox(height: 20),

                // Input Password
                TextField(
                  controller: _passwordController,
                  obscureText: _isPasswordObscured,
                  style: GoogleFonts.spaceGrotesk(color: AppTheme.textColor),
                  decoration:
                      _inputDecoration(
                        "Secret Code",
                        Icons.lock_outline,
                      ).copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordObscured
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: AppTheme.textSecondary,
                          ),
                          onPressed: () => setState(
                            () => _isPasswordObscured = !_isPasswordObscured,
                          ),
                        ),
                      ),
                ),
                const SizedBox(height: 8),
                // Guide for password requirements
                Text(
                  "Min. 8 chars, contain letters, numbers, & symbols.",
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 20),

                // Konfirmasi Password
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: _isConfirmObscured,
                  style: GoogleFonts.spaceGrotesk(color: AppTheme.textColor),
                  decoration:
                      _inputDecoration(
                        "Confirm Secret Code",
                        Icons.lock_reset,
                      ).copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isConfirmObscured
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: AppTheme.textSecondary,
                          ),
                          onPressed: () => setState(
                            () => _isConfirmObscured = !_isConfirmObscured,
                          ),
                        ),
                      ),
                ),
                const SizedBox(height: 32),

                // --- TOMBOL REGISTER ---
                SizedBox(
                  height: 54,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.textColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () async {
                      String name = _nameController.text.trim();
                      String pass = _passwordController.text.trim();
                      String confirm = _confirmPasswordController.text.trim();

                      // Cek apakah sudah terisi semua field
                      if (name.isEmpty || pass.isEmpty || confirm.isEmpty) {
                        _showError('All fields are required!');
                        return;
                      }

                      // Cek Panjang Minimal 8 Karakter
                      if (pass.length < 8) {
                        _showError(
                          'Password must be at least 8 characters long!',
                        );
                        return;
                      }

                      // Cek Kombinasi Huruf, Angka, Simbol (Regex)
                      final regex = RegExp(
                        r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>_]).+$',
                      );
                      if (!regex.hasMatch(pass)) {
                        _showError(
                          'Password must contain letters, numbers, and special characters!',
                        );
                        return;
                      }

                      // Cek Konfirmasi Password Cocok
                      if (pass != confirm) {
                        _showError('Passwords do not match!');
                        return;
                      }

                      // Simpan ke Database
                      int userId = await DatabaseHelper().registerUser(
                        name,
                        pass,
                      );

                      if (userId > 0) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Welcome, Explorer!'),
                            backgroundColor: AppTheme.cardColor,
                          ),
                        );
                        Navigator.pop(context);
                      } else {
                        if (!context.mounted) return;
                        _showError('Registration failed, please try again!');
                      }
                    },
                    child: Text(
                      "Become an Explorer",
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: AppTheme.fontMD,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.bgColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Link ke Login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already an explorer? ",
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: AppTheme.fontSM,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text(
                        "Sign in",
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: AppTheme.fontSM,
                          color: AppTheme.textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // snackbar
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.spaceGrotesk(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: const Color(0xFF8B0000),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.spaceGrotesk(color: AppTheme.textSecondary),
      prefixIcon: Icon(icon, color: AppTheme.textSecondary),
      filled: true,
      fillColor: AppTheme.cardColor,
      contentPadding: const EdgeInsets.symmetric(vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppTheme.textSecondary, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppTheme.textColor, width: 2),
      ),
    );
  }
}
