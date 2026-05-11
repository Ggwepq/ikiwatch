/// Unified media model for movies and TV shows from TMDB
class MediaItem {
  final int id;
  final String title;
  final String? overview;
  final String? posterPath;
  final String? backdropPath;
  final double voteAverage;
  final String? releaseDate;
  final String mediaType; // 'movie' or 'tv'
  final List<int> genreIds;
  final String? originCountry;
  final int? numberOfSeasons;
  final int? numberOfEpisodes;
  final Map<String, dynamic>? nextEpisodeToAir;
  final bool _isExplicitKdrama;

  const MediaItem({
    required this.id,
    required this.title,
    this.overview,
    this.posterPath,
    this.backdropPath,
    this.voteAverage = 0,
    this.releaseDate,
    required this.mediaType,
    this.genreIds = const [],
    this.originCountry,
    this.numberOfSeasons,
    this.numberOfEpisodes,
    this.nextEpisodeToAir,
    bool isExplicitKdrama = false,
  }) : _isExplicitKdrama = isExplicitKdrama;

  String get posterUrl =>
      posterPath != null ? 'https://image.tmdb.org/t/p/w500$posterPath' : '';

  String get backdropUrl =>
      backdropPath != null ? 'https://image.tmdb.org/t/p/w780$backdropPath' : '';

  String get year {
    if (releaseDate == null || releaseDate!.isEmpty) return '';
    return releaseDate!.substring(0, 4);
  }

  String get subtitle {
    final parts = <String>[];
    if (mediaType == 'movie') {
      parts.add('Movie');
    } else {
      parts.add('TV Series');
    }
    if (year.isNotEmpty) parts.add(year);
    return parts.join(' • ');
  }

  bool get isKdrama {
    if (_isExplicitKdrama) return true;
    return mediaType == 'tv' &&
        genreIds.contains(18) &&
        originCountry == 'KR';
  }

  factory MediaItem.fromJson(Map<String, dynamic> json, {String? forceMediaType}) {
    final type = forceMediaType ?? json['media_type'] ?? 'movie';
    final isMovie = type == 'movie';

    // Extract origin country
    String? country;
    if (json['origin_country'] is List && (json['origin_country'] as List).isNotEmpty) {
      country = (json['origin_country'] as List).first.toString();
    }

    return MediaItem(
      id: json['id'] ?? 0,
      title: isMovie ? (json['title'] ?? '') : (json['name'] ?? ''),
      overview: json['overview'],
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      releaseDate: isMovie ? json['release_date'] : json['first_air_date'],
      mediaType: type,
      genreIds: (json['genre_ids'] as List?)?.map((e) => e as int).toList() ??
          (json['genres'] as List?)?.map((e) => e['id'] as int).toList() ??
          [],
      originCountry: country,
      numberOfSeasons: json['number_of_seasons'],
      numberOfEpisodes: json['number_of_episodes'],
      nextEpisodeToAir: json['next_episode_to_air'],
      isExplicitKdrama: json['is_kdrama'] == true,
    );
  }
}
