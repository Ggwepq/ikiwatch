import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/models/media_item.dart';
import '../../../core/services/tmdb_service.dart';
import '../../../core/services/peachify_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/content_card.dart';
import '../../player/screens/player_screen.dart';
import 'cast_detail_screen.dart';

class ShowDetailsScreen extends StatefulWidget {
  final MediaItem media;
  const ShowDetailsScreen({super.key, required this.media});

  @override
  State<ShowDetailsScreen> createState() => _ShowDetailsScreenState();
}

class _ShowDetailsScreenState extends State<ShowDetailsScreen> {
  Map<String, dynamic>? _details;
  List<Map<String, dynamic>> _episodes = [];
  List<Map<String, dynamic>> _reviews = [];
  List<MediaItem> _recommendations = [];
  int _selectedSeason = 1;

  bool _hasUpcomingEpisode() {
    if (_details == null || _details!['next_episode_to_air'] == null) return false;
    final airDateStr = _details!['next_episode_to_air']['air_date'];
    if (airDateStr == null) return true; // Show it if no date is provided
    final airDate = DateTime.tryParse(airDateStr);
    if (airDate == null) return true;
    final today = DateTime.now();
    // Compare dates ignoring time
    final airDateOnly = DateTime(airDate.year, airDate.month, airDate.day);
    final todayOnly = DateTime(today.year, today.month, today.day);
    return airDateOnly.isAfter(todayOnly) || airDateOnly.isAtSameMomentAs(todayOnly);
  }

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  Future<void> _loadDetails() async {
    final results = await Future.wait([
      TmdbService.getDetailsRaw(
        mediaType: widget.media.mediaType,
        id: widget.media.id,
      ),
      TmdbService.getReviews(
        mediaType: widget.media.mediaType,
        id: widget.media.id,
      ),
      TmdbService.getRecommendations(
        mediaType: widget.media.mediaType,
        id: widget.media.id,
      ),
    ]);
    if (!mounted) return;
    setState(() {
      _details = results[0] as Map<String, dynamic>?;
      _reviews = results[1] as List<Map<String, dynamic>>;
      _recommendations = results[2] as List<MediaItem>;
    });
    if (widget.media.mediaType == 'tv') {
      _loadEpisodes(_selectedSeason);
    }
  }

  String? _getTrailerUrl() {
    final videos = _details?['videos']?['results'] as List?;
    if (videos == null) return null;
    for (final v in videos) {
      if (v['type'] == 'Trailer' && v['site'] == 'YouTube') {
        return 'https://www.youtube.com/watch?v=${v['key']}';
      }
    }
    return null;
  }

  Future<void> _openTrailer() async {
    final url = _getTrailerUrl();
    if (url != null) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _loadEpisodes(int season) async {
    final eps = await TmdbService.getSeasonEpisodes(
      tvId: widget.media.id,
      seasonNumber: season,
    );
    if (!mounted) return;
    setState(() => _episodes = eps);
  }

  void _playMovie() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => PlayerScreen(
        tmdbId: widget.media.id,
        title: widget.media.title,
        mediaType: 'movie',
        isKdrama: widget.media.isKdrama,
      ),
    ));
  }

  void _playEpisode(int season, int episode, String epTitle) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => PlayerScreen(
        tmdbId: widget.media.id,
        title: '${widget.media.title} — S${season}E$episode',
        mediaType: 'tv',
        season: season,
        episode: episode,
        isKdrama: widget.media.isKdrama,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final m = widget.media;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Hero app bar
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: AppColors.surface,
            foregroundColor: AppColors.primary,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.surface.withValues(alpha: 0.8),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.arrow_back, size: 20, color: AppColors.primary),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (m.backdropUrl.isNotEmpty)
                    Image.network(m.backdropUrl, fit: BoxFit.cover,
                        errorBuilder: (_, _a, _b) =>
                            Container(color: AppColors.surfaceContainerHigh)),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppColors.onSurface.withValues(alpha: 0.4),
                        ],
                      ),
                    ),
                  ),
                  if (_getTrailerUrl() != null)
                    Center(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(40),
                          onTap: _openTrailer,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.background.withValues(alpha: 0.7),
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.primary.withValues(alpha: 0.5)),
                            ),
                            child: Icon(Icons.play_arrow, size: 40, color: AppColors.primary),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Info card
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.outlineVariant),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF3D405B).withValues(alpha: 0.08),
                      blurRadius: 24,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      Text(m.title,
                          style:
                              AppTextStyles.headlineMedium.copyWith(fontSize: 26)),
                      const SizedBox(height: 8),

                      // User score + metadata row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Circular score gauge
                          if ((_details?['vote_average'] ?? m.voteAverage) > 0)
                            _UserScoreGauge(
                              score: ((_details?['vote_average'] ?? m.voteAverage) as num).toDouble(),
                            ),
                          if ((_details?['vote_average'] ?? m.voteAverage) > 0)
                            const SizedBox(width: 14),
                          // Text metadata
                          Expanded(
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 8,
                              children: [
                                Text(m.mediaType == 'movie' ? 'Movie' : 'TV Series',
                                    style: AppTextStyles.labelMedium
                                        .copyWith(color: AppColors.onSurfaceVariant)),
                                if (m.year.isNotEmpty) ...[
                                  _dot(),
                                  Text(m.year,
                                      style: AppTextStyles.labelMedium
                                          .copyWith(color: AppColors.onSurfaceVariant)),
                                ],
                                if (_details?['number_of_seasons'] != null) ...[
                                  _dot(),
                                  Text(
                                      '${_details!['number_of_seasons']} Season${_details!['number_of_seasons'] > 1 ? 's' : ''}',
                                      style: AppTextStyles.labelMedium
                                          .copyWith(color: AppColors.onSurfaceVariant)),
                                ],
                                if (_details?['runtime'] != null) ...[
                                  _dot(),
                                  Text('${_details!['runtime']}min',
                                      style: AppTextStyles.labelMedium
                                          .copyWith(color: AppColors.onSurfaceVariant)),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Watch button
                      AnimatedBuilder(
                        animation: PeachifyService.instance,
                        builder: (context, _) {
                          final prog = PeachifyService.instance.getProgress(m.id.toString());
                          bool hasProgress = false;
                          String btnText = m.mediaType == 'movie' ? 'WATCH NOW' : 'START WATCHING';
                          
                          if (prog != null) {
                            if (m.mediaType == 'movie' && prog['progress'] != null) {
                              final watched = prog['progress']['watched'] ?? 0;
                              final duration = prog['progress']['duration'] ?? 1;
                              if (watched > 0 && (watched / duration) < 0.95) {
                                hasProgress = true;
                                btnText = 'RESUME';
                              }
                            } else if (m.mediaType == 'tv' && prog['last_season_watched'] != null) {
                              hasProgress = true;
                              btnText = 'CONTINUE S${prog['last_season_watched']} E${prog['last_episode_watched']}';
                            }
                          }

                          return SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: m.mediaType == 'movie'
                                  ? _playMovie
                                  : (hasProgress
                                      ? () => _playEpisode(
                                            int.tryParse(prog?['last_season_watched']?.toString() ?? '1') ?? 1,
                                            int.tryParse(prog?['last_episode_watched']?.toString() ?? '1') ?? 1,
                                            '',
                                          )
                                      : (_episodes.isNotEmpty
                                          ? () => _playEpisode(
                                                _selectedSeason,
                                                _episodes.first['episode_number'] ?? 1,
                                                _episodes.first['name'] ?? '',
                                              )
                                          : null)),
                              icon: Icon(hasProgress ? Icons.play_circle_filled : Icons.play_arrow),
                              label: Text(btnText),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                backgroundColor: hasProgress ? AppColors.secondary : AppColors.primary,
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),

          // Synopsis
          if (((_details != null ? _details!['overview'] : m.overview) ?? '').isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Synopsis',
                        style: AppTextStyles.headlineSmall.copyWith(fontSize: 18)),
                    const SizedBox(height: 8),
                    Text((_details != null ? _details!['overview'] : m.overview) ?? '',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.onSurfaceVariant, fontSize: 14)),
                  ],
                ),
              ),
            ),

          // Genres
          if (_details != null && _details!['genres'] != null)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                child: Wrap(
                  spacing: 8,
                  children: (_details!['genres'] as List)
                      .map((g) => Chip(
                            label: Text(g['name'],
                                style: AppTextStyles.labelSmall.copyWith(
                                    fontSize: 11,
                                    color: AppColors.onSurfaceVariant)),
                            backgroundColor: AppColors.surfaceContainerHigh,
                            side: BorderSide(color: AppColors.outlineVariant),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            padding: EdgeInsets.zero,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ))
                      .toList(),
                ),
              ),
            ),

          // Episodes (for TV)
          if (m.mediaType == 'tv') ...[
            if (_hasUpcomingEpisode())
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryContainer.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.secondary.withValues(alpha: 0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.calendar_month, color: AppColors.secondary, size: 20),
                            const SizedBox(width: 8),
                            Text('Upcoming Episode',
                                style: AppTextStyles.labelMedium.copyWith(color: AppColors.secondary)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'S${_details!['next_episode_to_air']['season_number']} E${_details!['next_episode_to_air']['episode_number']} - ${_details!['next_episode_to_air']['name']}',
                          style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                        ),
                        if (_details!['next_episode_to_air']['air_date'] != null)
                          Text(
                            'Airing on ${_details!['next_episode_to_air']['air_date']}',
                            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurfaceVariant),
                          ),
                      ],
                    ),
                  ),
                ),
              ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Episodes',
                            style: AppTextStyles.headlineSmall),
                        if (_details?['number_of_seasons'] != null)
                          _SeasonDropdown(
                            totalSeasons: _details!['number_of_seasons'],
                            selected: _selectedSeason,
                            onChanged: (s) {
                              setState(() => _selectedSeason = s);
                              _loadEpisodes(s);
                            },
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Divider(color: AppColors.outlineVariant),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final ep = _episodes[index];
                  return _EpisodeTile(
                    episode: ep,
                    onTap: () => _playEpisode(
                      _selectedSeason,
                      ep['episode_number'] ?? 1,
                      ep['name'] ?? '',
                    ),
                  );
                },
                childCount: _episodes.length,
              ),
            ),
          ],

          // Cast
          if (_details?['credits']?['cast'] != null)
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                    child: Text('CAST',
                        style: AppTextStyles.labelSmall
                            .copyWith(color: AppColors.outline, letterSpacing: 1.5)),
                  ),
                  SizedBox(
                    height: 180,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      scrollDirection: Axis.horizontal,
                      itemCount: (_details!['credits']['cast'] as List).length.clamp(0, 20),
                      itemBuilder: (context, index) {
                        final cast = _details!['credits']['cast'][index];
                        final imageUrl = cast['profile_path'] != null
                            ? 'https://image.tmdb.org/t/p/w200${cast['profile_path']}'
                            : '';
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CastDetailScreen(personId: cast['id'], personName: cast['name'] ?? ''),
                              ),
                            );
                          },
                          child: Container(
                            width: 120,
                            margin: const EdgeInsets.only(right: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: imageUrl.isNotEmpty
                                        ? Image.network(imageUrl, fit: BoxFit.cover, width: double.infinity,
                                            errorBuilder: (_, _a, _b) =>
                                              Container(color: AppColors.surfaceContainerHigh))
                                        : Container(
                                            color: AppColors.surfaceContainerHigh,
                                            width: double.infinity,
                                            child: const Icon(Icons.person, color: AppColors.outlineVariant),
                                          ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  cast['name'] ?? '',
                                  style: AppTextStyles.labelMedium.copyWith(fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  cast['character'] ?? '',
                                  style: AppTextStyles.labelSmall.copyWith(color: AppColors.onSurfaceVariant),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

          // Reviews
          if (_reviews.isNotEmpty)
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
                    child: Text('REVIEWS',
                        style: AppTextStyles.labelSmall
                            .copyWith(color: AppColors.outline, letterSpacing: 1.5)),
                  ),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      scrollDirection: Axis.horizontal,
                      itemCount: _reviews.length,
                      itemBuilder: (context, index) {
                        final review = _reviews[index];
                        final authorDetails = review['author_details'];
                        final rating = authorDetails?['rating'];
                        final content = review['content'] ?? '';
                        
                        return Container(
                          width: 300,
                          margin: const EdgeInsets.only(right: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.outlineVariant),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: AppColors.primaryContainer,
                                    child: Text(
                                      (review['author'] ?? 'U')[0].toUpperCase(),
                                      style: AppTextStyles.labelMedium.copyWith(color: AppColors.onPrimaryContainer),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(review['author'] ?? 'User',
                                            style: AppTextStyles.labelMedium.copyWith(fontWeight: FontWeight.bold),
                                            maxLines: 1, overflow: TextOverflow.ellipsis),
                                        if (rating != null)
                                          Row(
                                            children: [
                                              Icon(Icons.star, size: 12, color: AppColors.primary),
                                              const SizedBox(width: 4),
                                              Text(rating.toString(), style: AppTextStyles.labelSmall),
                                            ],
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Expanded(
                                child: Text(
                                  content,
                                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurfaceVariant),
                                  maxLines: 5,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

          // Recommendations
          if (_recommendations.isNotEmpty)
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
                    child: Text('RECOMMENDATIONS',
                        style: AppTextStyles.labelSmall
                            .copyWith(color: AppColors.outline, letterSpacing: 1.5)),
                  ),
                  SizedBox(
                    height: 220,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      scrollDirection: Axis.horizontal,
                      itemCount: _recommendations.length,
                      itemBuilder: (context, index) {
                        final rec = _recommendations[index];
                        final title = rec.mediaType == 'movie' ? rec.title : rec.title;
                        final subtitle = rec.mediaType == 'movie' ? 'Movie' : 'TV Series';
                        
                        return Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: ContentCard(
                            imageUrl: rec.posterUrl,
                            title: title,
                            subtitle: subtitle,
                            width: 140,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ShowDetailsScreen(media: rec),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  Widget _dot() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Container(
          width: 4, height: 4,
          decoration: BoxDecoration(
            color: AppColors.outlineVariant, shape: BoxShape.circle),
        ),
      );
}

class _SeasonDropdown extends StatelessWidget {
  final int totalSeasons;
  final int selected;
  final ValueChanged<int> onChanged;
  const _SeasonDropdown(
      {required this.totalSeasons,
      required this.selected,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: selected,
          isDense: true,
          style: AppTextStyles.labelMedium
              .copyWith(color: AppColors.primary, fontSize: 12),
          icon: Icon(Icons.expand_more, size: 16, color: AppColors.primary),
          items: List.generate(
            totalSeasons,
            (i) => DropdownMenuItem(
                value: i + 1,
                child: Text('Season ${i + 1}')),
          ),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
    );
  }
}

class _EpisodeTile extends StatelessWidget {
  final Map<String, dynamic> episode;
  final VoidCallback? onTap;
  const _EpisodeTile({required this.episode, this.onTap});

  @override
  Widget build(BuildContext context) {
    final epNum = episode['episode_number'] ?? 0;
    final name = episode['name'] ?? 'Episode $epNum';
    final overview = episode['overview'] ?? '';
    final stillPath = episode['still_path'];
    final stillUrl = stillPath != null
        ? 'https://image.tmdb.org/t/p/w300$stillPath'
        : '';
    final runtime = episode['runtime'];

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (stillUrl.isNotEmpty)
                      Image.network(stillUrl, fit: BoxFit.cover,
                          errorBuilder: (_, _a, _b) =>
                              Container(color: AppColors.surfaceContainerHigh))
                    else
                      Container(color: AppColors.surfaceContainerHigh,
                          child: const Center(
                              child: Icon(Icons.play_circle_outline,
                                  size: 40, color: AppColors.outlineVariant))),
                    // Play overlay
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.4),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.play_arrow,
                            color: Colors.white, size: 28),
                      ),
                    ),
                    if (runtime != null)
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text('${runtime}min',
                              style: AppTextStyles.labelSmall
                                  .copyWith(color: Colors.white, fontSize: 10)),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text('$epNum. $name',
                style: AppTextStyles.labelMedium.copyWith(fontSize: 15)),
            if (overview.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(overview,
                  style: AppTextStyles.bodyMedium.copyWith(
                      fontSize: 13, color: AppColors.onSurfaceVariant),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
            ],
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _UserScoreGauge extends StatelessWidget {
  final double score;
  const _UserScoreGauge({required this.score});

  @override
  Widget build(BuildContext context) {
    Color scoreColor;
    if (score >= 7.0) {
      scoreColor = Colors.greenAccent.shade400;
    } else if (score >= 5.0) {
      scoreColor = Colors.yellowAccent.shade400;
    } else {
      scoreColor = Colors.redAccent.shade400;
    }

    final double percentage = score / 10.0;

    return SizedBox(
      width: 48,
      height: 48,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(
            value: 1.0,
            strokeWidth: 4,
            valueColor: AlwaysStoppedAnimation<Color>(scoreColor.withValues(alpha: 0.2)),
          ),
          CircularProgressIndicator(
            value: percentage,
            strokeWidth: 4,
            valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
            strokeCap: StrokeCap.round,
          ),
          Center(
            child: Text(
              '${(score * 10).round()}%',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.onSurface,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
