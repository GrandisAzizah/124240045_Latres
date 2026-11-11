import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/favorite_provider.dart';
import '../services/api_services.dart';
import '../models/character.dart';
import '../theme/app_theme.dart';
import 'detail_screen.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<Character> _favCharacters = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final favIds = context.read<FavoriteProvider>().favorites;
    if (favIds.isEmpty) {
      setState(() {
        _favCharacters = [];
        _isLoading = false;
      });
      return;
    }

    setState(() => _isLoading = true);
    try {
      final chars = await ApiService.getCharacters();
      final filtered = chars
          .where((c) => favIds.contains(c.id.toString()))
          .toList();
      setState(() {
        _favCharacters = filtered;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch provider untuk sinkronisasi
    final provider = context.watch<FavoriteProvider>();

    // Jika list favorit dihapus dari halaman lain, refresh
    if (provider.favorites.length != _favCharacters.length && !_isLoading) {
      _loadFavorites();
    }

    return Scaffold(
      backgroundColor: AppTheme.bgColor,
      appBar: AppBar(
        backgroundColor: AppTheme.bgColor,
        elevation: 0,
        title: Text(
          'Favorites',
          style: GoogleFonts.spaceGrotesk(
            color: AppTheme.textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppTheme.textColor),
            )
          : _favCharacters.isEmpty
          ? Center(
              child: Text(
                "You don't have any favorite characters yet.\nHeads to Characters!",
                textAlign: TextAlign.center,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: AppTheme.fontMD,
                  color: AppTheme.textSecondary,
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _favCharacters.length,
              separatorBuilder: (context, index) => const Divider(
                color: AppTheme.borderColor,
                height: 1,
                thickness: 1,
              ),
              itemBuilder: (context, index) {
                final char = _favCharacters[index];
                return Dismissible(
                  key: Key(char.id.toString()),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    color: Color.fromARGB(255, 179, 12, 0),
                    child: const Icon(Icons.delete, color: AppTheme.white),
                  ),
                  onDismissed: (direction) {
                    context.read<FavoriteProvider>().removeFavorite(
                      char.id.toString(),
                    );
                    setState(() {
                      _favCharacters.removeAt(index);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${char.name} removed from favorite',
                          style: GoogleFonts.spaceGrotesk(
                            color: AppTheme.textColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        backgroundColor: AppTheme.veryLightGrey,
                      ),
                    );
                  },
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                    leading: Image.network(
                      char.image,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
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
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(character: char),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
