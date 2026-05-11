/// Content type filter used across all screens
enum ContentFilter {
  all,
  movie,
  tv,
  kdrama,
}

extension ContentFilterExtension on ContentFilter {
  String get label {
    switch (this) {
      case ContentFilter.all:
        return 'All';
      case ContentFilter.movie:
        return 'Movies';
      case ContentFilter.tv:
        return 'TV Shows';
      case ContentFilter.kdrama:
        return 'K-Drama';
    }
  }

  /// The TMDB media_type path segment
  String get mediaType {
    switch (this) {
      case ContentFilter.all:
        return 'all';
      case ContentFilter.movie:
        return 'movie';
      case ContentFilter.tv:
      case ContentFilter.kdrama:
        return 'tv';
    }
  }
}
