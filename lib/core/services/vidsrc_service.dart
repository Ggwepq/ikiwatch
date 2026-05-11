/// Vidsrc streaming URL builder with API 1 → API 3 fallback
class VidsrcService {
  /// App's sage green primary color for the player theme
  static const _themeColor = '334537';

  /// Available API versions
  static const api1 = 1;
  static const api3 = 3;

  /// Build movie streaming URL
  static String movieUrl({required int tmdbId, int apiVersion = 1}) {
    return 'https://vidsrc.wtf/$apiVersion/movie/$tmdbId?color=$_themeColor';
  }

  /// Build TV episode streaming URL
  static String tvUrl({
    required int tmdbId,
    required int season,
    required int episode,
    int apiVersion = 1,
  }) {
    return 'https://vidsrc.wtf/$apiVersion/tv/$tmdbId/$season/$episode?color=$_themeColor';
  }

  /// Get the fallback API version
  static int fallbackApi(int currentApi) {
    return currentApi == api1 ? api3 : api1;
  }

  /// Get ordered list of URLs to try (primary → fallback)
  static List<String> getMovieUrls({
    required int tmdbId,
    int preferredApi = 1,
  }) {
    return [
      movieUrl(tmdbId: tmdbId, apiVersion: preferredApi),
      movieUrl(tmdbId: tmdbId, apiVersion: fallbackApi(preferredApi)),
    ];
  }

  /// Get ordered list of TV URLs to try (primary → fallback)
  static List<String> getTvUrls({
    required int tmdbId,
    required int season,
    required int episode,
    int preferredApi = 1,
  }) {
    return [
      tvUrl(
          tmdbId: tmdbId,
          season: season,
          episode: episode,
          apiVersion: preferredApi),
      tvUrl(
          tmdbId: tmdbId,
          season: season,
          episode: episode,
          apiVersion: fallbackApi(preferredApi)),
    ];
  }
}
