import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/media_item.dart';

/// TMDB API service — handles all movie/TV data fetching
class TmdbService {
  static const _baseUrl = 'https://api.themoviedb.org/3';
  static const imageBase = 'https://image.tmdb.org/t/p';

  static String get _token => dotenv.env['TMDB_ACCESS_TOKEN'] ?? '';

  static Map<String, String> get _headers => {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
      };

  // ── Generic fetch ──
  static Future<Map<String, dynamic>?> _get(String path,
      [Map<String, String>? params]) async {
    try {
      final uri = Uri.parse('$_baseUrl$path').replace(queryParameters: params);
      final response = await http.get(uri, headers: _headers);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (e) {
      // Silently fail — screens show empty state
    }
    return null;
  }

  static List<MediaItem> _parseResults(Map<String, dynamic>? data,
      {String? forceMediaType}) {
    if (data == null || data['results'] == null) return [];
    return (data['results'] as List)
        .map((j) => MediaItem.fromJson(j, forceMediaType: forceMediaType))
        .toList();
  }

  // ── Trending ──
  static Future<List<MediaItem>> getTrending({
    String mediaType = 'all',
    String timeWindow = 'week',
  }) async {
    final data = await _get('/trending/$mediaType/$timeWindow');
    return _parseResults(data);
  }

  // ── Top Rated ──
  static Future<List<MediaItem>> getTopRated({
    String mediaType = 'movie',
  }) async {
    final data = await _get('/$mediaType/top_rated');
    return _parseResults(data, forceMediaType: mediaType);
  }

  // ── Popular ──
  static Future<List<MediaItem>> getPopular({
    String mediaType = 'movie',
  }) async {
    final data = await _get('/$mediaType/popular');
    return _parseResults(data, forceMediaType: mediaType);
  }

  // ── Now Playing (movies) / On The Air (TV) ──
  static Future<List<MediaItem>> getNowPlaying({
    String mediaType = 'movie',
  }) async {
    final endpoint =
        mediaType == 'movie' ? '/movie/now_playing' : '/tv/on_the_air';
    final data = await _get(endpoint);
    return _parseResults(data, forceMediaType: mediaType);
  }

  // ── Discover K-Dramas ──
  static Future<List<MediaItem>> getKdramas({
    String sortBy = 'popularity.desc',
  }) async {
    final data = await _get('/discover/tv', {
      'with_origin_country': 'KR',
      'with_genres': '18',
      'sort_by': sortBy,
    });
    return _parseResults(data, forceMediaType: 'tv');
  }

  // ── Search ──
  static Future<List<MediaItem>> search(String query) async {
    if (query.trim().isEmpty) return [];
    final data = await _get('/search/multi', {'query': query});
    if (data == null || data['results'] == null) return [];
    return (data['results'] as List)
        .where((j) => j['media_type'] == 'movie' || j['media_type'] == 'tv')
        .map((j) => MediaItem.fromJson(j))
        .toList();
  }

  // ── Details ──
  static Future<MediaItem?> getDetails({
    required String mediaType,
    required int id,
  }) async {
    final data =
        await _get('/$mediaType/$id', {'append_to_response': 'credits'});
    if (data == null) return null;
    return MediaItem.fromJson(data, forceMediaType: mediaType);
  }

  // ── TV Season Episodes ──
  static Future<List<Map<String, dynamic>>> getSeasonEpisodes({
    required int tvId,
    required int seasonNumber,
  }) async {
    final data = await _get('/tv/$tvId/season/$seasonNumber');
    if (data == null || data['episodes'] == null) return [];
    return (data['episodes'] as List).cast<Map<String, dynamic>>();
  }

  // ── Full details JSON (for cast, etc.) ──
  static Future<Map<String, dynamic>?> getDetailsRaw({
    required String mediaType,
    required int id,
  }) async {
    return _get('/$mediaType/$id', {'append_to_response': 'credits'});
  }
}
