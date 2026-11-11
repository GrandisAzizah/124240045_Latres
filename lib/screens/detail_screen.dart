import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/character.dart';
import '../theme/app_theme.dart';

import 'package:provider/provider.dart';

import '../providers/favorite_provider.dart';

class DetailScreen extends StatelessWidget {
  final Character character;

  const DetailScreen({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    final isFav = context.watch<FavoriteProvider>().isFavorite(
      character.id.toString(),
    );
    return Scaffold(
      backgroundColor: AppTheme.bgColor,
      appBar: AppBar(
        backgroundColor: AppTheme.bgColor,
        iconTheme: const IconThemeData(color: AppTheme.textColor),
        title: Text(
          character.name,
          style: GoogleFonts.spaceGrotesk(
            color: AppTheme.textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isFav ? Icons.favorite : Icons.favorite_border,
              color: isFav
                  ? AppTheme.textSecondary
                  : AppTheme.textColor.withValues(alpha: 0.6),
            ),
            onPressed: () {
              context.read<FavoriteProvider>().toggleFavorite(
                character.id.toString(),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Foto Karakter
            ClipRRect(
              child: Image.network(
                character.image,
                height: 250,
                width: 250,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 24),

            // Nama
            Text(
              character.name,
              textAlign: TextAlign.center,
              style: GoogleFonts.spaceGrotesk(
                fontSize: AppTheme.fontXL,
                fontWeight: FontWeight.bold,
                color: AppTheme.textColor,
              ),
            ),
            const SizedBox(height: 32),

            // Info Detail
            _buildInfoRow("Status", character.status),
            _buildInfoRow("Species", character.species),
            _buildInfoRow("Gender", character.gender),
            _buildInfoRow("Origin", character.origin),
            _buildInfoRow("Location", character.location),
          ],
        ),
      ),
    );
  }

  // Widget bantuan untuk baris info
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: GoogleFonts.spaceGrotesk(
                fontWeight: FontWeight.w600,
                color: AppTheme.textColor.withValues(alpha: 0.6),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.spaceGrotesk(
                fontWeight: FontWeight.bold,
                color: AppTheme.textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
