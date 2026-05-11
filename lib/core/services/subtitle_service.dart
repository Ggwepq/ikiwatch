import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';

class SubtitleTrack {
  final String id;
  final String language;
  final String downloadUrl;

  SubtitleTrack({
    required this.id,
    required this.language,
    required this.downloadUrl,
  });
}

class SubtitleService {
  static const String _baseUrl = 'https://api.opensubtitles.com/api/v1';

  static String get _apiKey => dotenv.env['OPENSUBTITLES_API_KEY'] ?? '';
  
  static Future<List<SubtitleTrack>> searchSubtitles(int tmdbId, {String type = 'movie', int? season, int? episode}) async {
    if (_apiKey.isEmpty) return [];

    try {
      final uri = Uri.parse('$_baseUrl/subtitles?tmdb_id=$tmdbId${season != null ? '&season_number=$season' : ''}${episode != null ? '&episode_number=$episode' : ''}');
      
      final response = await http.get(
        uri,
        headers: {
          'Api-Key': _apiKey,
          'User-Agent': 'Ikiwatch v1.0.0', // Important for OpenSubtitles API
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<SubtitleTrack> tracks = [];
        
        // OpenSubtitles API requires authentication (JWT) to actually get the direct download link
        // via the /download endpoint. For a free, unauthenticated approach with just an API key,
        // we can extract the file_id, but we must use the /download endpoint to get the file.
        // Let's implement the basic search first, and if we need direct URLs we'll have to see if the API allows it without auth.
        
        // Wait, the API docs say we need authentication to POST /api/v1/download.
        // Actually, some endpoints return a 'url' if it's a public subtitle.
        // Let's parse whatever we can get for now.
        
        for (var item in data['data']) {
          final attrs = item['attributes'];
          final files = attrs['files'] as List?;
          if (files != null && files.isNotEmpty) {
            final fileId = files.first['file_id'];
            tracks.add(SubtitleTrack(
              id: fileId.toString(),
              language: attrs['language'] ?? 'en',
              downloadUrl: '', // We would need to fetch the download URL using the file_id
            ));
          }
        }
        return tracks;
      }
    } catch (e) {
      debugPrint('Subtitle fetch error: $e');
    }
    return [];
  }
}
