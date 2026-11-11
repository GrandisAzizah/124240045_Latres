import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';
import '../services/database_helper.dart';
import '../theme/app_theme.dart';
import 'register_screen.dart';
import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.textColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // --- GAMBAR RICK & MORTY ---
                Image.asset(
                  'assets/images/rick.png',
                  height: 140,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 24),

                // --- TEXT WELCOME ---
                Text(
                  "Welcome Back, Explorer!",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.bgColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Sign in to continue your adventure",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 14,
                    color: AppTheme.bgColor,
                  ),
                ),
                const SizedBox(height: 40),

                // --- INPUT NAMA ---
                TextField(
                  controller: _nameController,
                  style: GoogleFonts.spaceGrotesk(color: AppTheme.bgColor),
                  decoration: InputDecoration(
                    labelText: "Your Name",
                    labelStyle: GoogleFonts.spaceGrotesk(
                      color: AppTheme.bgColor,
                    ),
                    prefixIcon: const Icon(
                      Icons.person_outline,
                      color: AppTheme.bgColor,
                    ),
                    filled: true,
                    fillColor: AppTheme.textColor,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: AppTheme.bgColor, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: AppTheme.bgColor,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // --- INPUT PASSWORD ---
                TextField(
                  controller: _passwordController,
                  obscureText: _isObscured,
                  style: GoogleFonts.spaceGrotesk(color: AppTheme.bgColor),
                  decoration: InputDecoration(
                    labelText: "Secret Code",
                    labelStyle: GoogleFonts.spaceGrotesk(
                      color: AppTheme.bgColor,
                    ),
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: AppTheme.bgColor,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscured ? Icons.visibility_off : Icons.visibility,
                        color: AppTheme.bgColor,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscured = !_isObscured;
                        });
                      },
                    ),
                    filled: true,
                    fillColor: AppTheme.textColor,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: AppTheme.bgColor, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: AppTheme.bgColor,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // --- TOMBOL LOGIN ---
                SizedBox(
                  height: 54,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.bgColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () async {
                      String name = _nameController.text.trim();
                      String pass = _passwordController.text.trim();

                      // 1. Validasi jika kosong
                      if (name.isEmpty || pass.isEmpty) {
                        _showSnackbar(
                          context,
                          'Name and Secret Code cannot be empty!',
                          isError: true,
                        );
                        return;
                      }

                      // 2. Cek ke Database SQLite
                      bool isValid = await DatabaseHelper().loginUser(
                        name,
                        pass,
                      );

                      if (isValid) {
                        // 3. Jika valid, simpan sesi ke Shared Preferences
                        await AuthService.setLoggedIn(true);

                        if (!context.mounted) return;

                        // 4. Pindah ke halaman utama
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MainScreen(),
                          ),
                        );
                      } else {
                        if (!context.mounted) return;
                        _showSnackbar(
                          context,
                          'Incorrect Name or Secret Code!',
                          isError: true,
                        );
                      }
                    },
                    child: Text(
                      "Enter Realm",
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // --- LINK REGISTER ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "New explorer? ",
                      style: GoogleFonts.spaceGrotesk(color: AppTheme.bgColor),
                    ),
                    GestureDetector(
                      onTap: () {
                        // ini di klik ke register screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Sign here",
                        style: GoogleFonts.spaceGrotesk(
                          color: AppTheme.textSecondary,
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
}

// Fungsi bantuan untuk menampilkan Snackbar
void _showSnackbar(
  BuildContext context,
  String message, {
  bool isError = false,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: GoogleFonts.spaceGrotesk(
          color: isError ? Colors.white : AppTheme.bgColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: isError
          ? const Color(0xFF8B0000)
          : AppTheme.textColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      duration: const Duration(seconds: 2),
    ),
  );
}
