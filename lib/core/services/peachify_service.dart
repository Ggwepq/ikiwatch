import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PeachifyService extends ChangeNotifier {
  static const String _progressKey = 'peachifyProgress';
  static final PeachifyService instance = PeachifyService._internal();
  
  // Format: { "76479": { "id": 76479, "type": "tv", "title": "...", "progress": { "watched": 10.0, "duration": 100.0 } } }
  Map<String, dynamic> _progressData = {};
  
  PeachifyService._internal() {
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_progressKey);
    if (jsonStr != null) {
      try {
        _progressData = jsonDecode(jsonStr);
        notifyListeners();
      } catch (e) {
        debugPrint('Error decoding peachify progress: $e');
      }
    }
  }

  Future<void> saveProgress(Map<String, dynamic> newData) async {
    _progressData = newData;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_progressKey, jsonEncode(_progressData));
    notifyListeners();
  }

  Map<String, dynamic>? getProgress(String tmdbId) {
    return _progressData[tmdbId];
  }

  List<Map<String, dynamic>> getAllProgress() {
    final list = _progressData.values.toList().cast<Map<String, dynamic>>();
    // Sort by last_updated if available, descending
    list.sort((a, b) {
      final aTime = a['last_updated'] ?? 0;
      final bTime = b['last_updated'] ?? 0;
      return bTime.compareTo(aTime);
    });
    return list;
  }

  String buildMovieUrl(String tmdbId, {String? sub, String? dub}) {
    // We use our accent color: 4D7A68
    String url = 'https://peachify.top/embed/movie/$tmdbId?accent=4D7A68';
    if (sub != null) url += '&sub=${Uri.encodeComponent(sub)}';
    if (dub != null) url += '&dub=${Uri.encodeComponent(dub)}';
    
    // Check if we have progress to start at
    final prog = getProgress(tmdbId);
    if (prog != null && prog['progress'] != null) {
      final watched = prog['progress']['watched'];
      final duration = prog['progress']['duration'];
      // Only resume if we have watched less than 95%
      if (watched != null && duration != null && (watched / duration) < 0.95) {
        url += '&startAt=${watched.toInt()}';
      }
    }
    return url;
  }

  String buildTvUrl(String tmdbId, int season, int episode, {String? sub, String? dub, int? startAt}) {
    String url = 'https://peachify.top/embed/tv/$tmdbId/$season/$episode?accent=4D7A68';
    if (sub != null) url += '&sub=${Uri.encodeComponent(sub)}';
    if (dub != null) url += '&dub=${Uri.encodeComponent(dub)}';
    
    if (startAt != null) {
      url += '&startAt=$startAt';
    } else {
      // Check for specific episode progress
      final prog = getProgress(tmdbId);
      if (prog != null && prog['show_progress'] != null) {
        final epKey = 's${season}e$episode';
        final epProg = prog['show_progress'][epKey];
        if (epProg != null && epProg['progress'] != null) {
          final watched = epProg['progress']['watched'];
          final duration = epProg['progress']['duration'];
          if (watched != null && duration != null && (watched / duration) < 0.95) {
            url += '&startAt=${watched.toInt()}';
          }
        }
      }
    }
    return url;
  }
}
