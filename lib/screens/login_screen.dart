import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
                      backgroundColor: AppTheme.bgColor, // Hijau Tua
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MainScreen(),
                        ),
                      );
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
