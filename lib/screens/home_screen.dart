import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/character.dart';
import '../services/api_services.dart';
import '../theme/app_theme.dart';
import 'detail_screen.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import '../providers/favorite_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Character> _characters = [];
  bool _isLoading = true;
  String _errorMessage = '';
  String _currentFilter = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchCharacters();
  }

  Future<void> _fetchCharacters() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final chars = await ApiService.getCharacters(
        status: _currentFilter,
        name: _searchQuery,
      );
      setState(() {
        _characters = chars;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage =
            'Ups! Karakter tidak ditemukan atau koneksi bermasalah.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgColor,
      appBar: AppBar(
        backgroundColor: AppTheme.bgColor,
        elevation: 0,
        title: Text(
          'Characters',
          style: GoogleFonts.spaceGrotesk(
            color: AppTheme.textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppTheme.textColor),
            onPressed: () async {
              await AuthService.logout();
              if (!context.mounted) return;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // --- SEARCH BAR ---
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
            child: TextField(
              controller: _searchController,
              onSubmitted: (value) {
                setState(() => _searchQuery = value);
                _fetchCharacters();
              },
              style: GoogleFonts.spaceGrotesk(color: AppTheme.textColor),
              decoration: InputDecoration(
                hintText: "Search character...",
                hintStyle: GoogleFonts.spaceGrotesk(
                  color: AppTheme.textSecondary,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppTheme.textSecondary,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear, color: AppTheme.textSecondary),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                    _fetchCharacters();
                  },
                ),
                filled: true,
                fillColor: AppTheme.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppTheme.borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppTheme.borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: AppTheme.textColor,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),

          // --- FILTER STATUS ---
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: ['All', 'Alive', 'Dead', 'Unknown'].map((status) {
                final isSelected = _currentFilter == status;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(status),
                    selected: isSelected,
                    showCheckmark: false,
                    selectedColor: AppTheme.textColor,
                    backgroundColor: AppTheme.bgColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        4,
                      ), // sudut ga rounded
                      side: BorderSide(
                        color: isSelected
                            ? AppTheme.textColor
                            : AppTheme.borderColor,
                      ),
                    ),
                    labelStyle: GoogleFonts.spaceGrotesk(
                      color: isSelected ? AppTheme.white : AppTheme.textColor,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _currentFilter = status);
                        _fetchCharacters();
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          // --- KONTEN UTAMA ---
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: AppTheme.textColor),
                  )
                : _errorMessage.isNotEmpty
                ? Center(
                    child: Text(
                      _errorMessage,
                      style: GoogleFonts.spaceGrotesk(
                        color: AppTheme.textColor,
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _characters.length,
                    separatorBuilder: (context, index) => const Divider(
                      color: AppTheme.borderColor,
                      height: 1,
                      thickness: 1,
                    ),
                    itemBuilder: (context, index) {
                      final char = _characters[index];
                      final isFav = context
                          .watch<FavoriteProvider>()
                          .isFavorite(char.id.toString());

                      // --- garis pemisah---
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                        ),
                        leading: Image.network(
                          char.image,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ), // Gambar kotak
                        title: Text(
                          char.name,
                          style: GoogleFonts.spaceGrotesk(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textColor,
                          ),
                        ),
                        subtitle: Text(
                          char.status,
                          style: GoogleFonts.spaceGrotesk(
                            color: AppTheme.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav
                                ? AppTheme.textColor
                                : AppTheme.textSecondary,
                          ),
                          onPressed: () {
                            context.read<FavoriteProvider>().toggleFavorite(
                              char.id.toString(),
                            );
                          },
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailScreen(character: char),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
