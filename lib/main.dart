import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/favorite_provider.dart';
import 'services/auth_service.dart';
import 'screens/login_screen.dart';
import 'screens/main_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (context) => FavoriteProvider()..loadFavorites(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rick & Morty Explorer',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppTheme.bgColor,
        useMaterial3: true,
      ),
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isLoading = true;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  // Fungsi untuk mengecek Shared Preferences
  Future<void> _checkSession() async {
    bool loggedIn = await AuthService.isLoggedIn();
    if (mounted) {
      setState(() {
        _isLoggedIn = loggedIn;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // loading sebentar saat ngecek sesi
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppTheme.textColor),
        ),
      );
    }

    // udah login bisa akses halaman, belum login ke login dulu
    return _isLoggedIn ? const MainScreen() : const LoginScreen();
  }
}
