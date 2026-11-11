import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/episode.dart';
import '../services/api_services.dart';
import '../theme/app_theme.dart';

class EpisodeScreen extends StatefulWidget {
  const EpisodeScreen({super.key});

  @override
  State<EpisodeScreen> createState() => _EpisodeScreenState();
}

class _EpisodeScreenState extends State<EpisodeScreen> {
  List<Episode> _episodes = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchEpisodes();
  }

  Future<void> _fetchEpisodes() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final eps = await ApiService.getEpisodes();
      setState(() {
        _episodes = eps;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Cannot fetch episodes.';
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
          'Episodes',
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
          : _errorMessage.isNotEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _errorMessage,
                    style: GoogleFonts.spaceGrotesk(color: AppTheme.textColor),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _fetchEpisodes,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.textColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "Try Again",
                      style: GoogleFonts.spaceGrotesk(color: AppTheme.white),
                    ),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _episodes.length,
              separatorBuilder: (context, index) => const Divider(
                color: AppTheme.borderColor,
                height: 1,
                thickness: 1,
              ),
              itemBuilder: (context, index) {
                final ep = _episodes[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                  leading: Text(
                    '${ep.id}',
                    style: GoogleFonts.spaceGrotesk(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: AppTheme.textColor,
                    ),
                  ),
                  title: Text(
                    ep.name,
                    style: GoogleFonts.spaceGrotesk(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textColor,
                    ),
                  ),
                  subtitle: Text(
                    ep.airDate,
                    style: GoogleFonts.spaceGrotesk(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                );
              },
            ),
    );
  }
}
