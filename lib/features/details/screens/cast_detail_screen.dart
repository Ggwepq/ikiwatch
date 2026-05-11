import 'package:flutter/material.dart';
import '../../../core/models/media_item.dart';
import '../../../core/services/tmdb_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/content_card.dart';
import 'show_details_screen.dart';

class CastDetailScreen extends StatefulWidget {
  final int personId;
  final String personName;
  final String? profilePath;

  const CastDetailScreen({
    super.key,
    required this.personId,
    required this.personName,
    this.profilePath,
  });

  @override
  State<CastDetailScreen> createState() => _CastDetailScreenState();
}

class _CastDetailScreenState extends State<CastDetailScreen> {
  Map<String, dynamic>? _person;
  bool _bioExpanded = false;

  @override
  void initState() {
    super.initState();
    _loadPerson();
  }

  Future<void> _loadPerson() async {
    final data = await TmdbService.getPersonDetails(personId: widget.personId);
    if (!mounted) return;
    setState(() => _person = data);
  }

  void _openDetails(MediaItem item) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ShowDetailsScreen(media: item),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileUrl = widget.profilePath != null
        ? 'https://image.tmdb.org/t/p/w500${widget.profilePath}'
        : '';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Hero header with profile photo
          SliverAppBar(
            expandedHeight: 320,
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
                  if (profileUrl.isNotEmpty)
                    Image.network(profileUrl, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Container(color: AppColors.surfaceContainerHigh))
                  else
                    Container(
                      color: AppColors.surfaceContainerHigh,
                      child: Icon(Icons.person, size: 80,
                          color: AppColors.outlineVariant),
                    ),
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0.4, 1.0],
                        colors: [
                          Colors.transparent,
                          AppColors.background.withValues(alpha: 0.95),
                        ],
                      ),
                    ),
                  ),
                  // Name at bottom
                  Positioned(
                    bottom: 16,
                    left: 24,
                    right: 24,
                    child: Text(
                      widget.personName,
                      style: AppTextStyles.headlineMedium.copyWith(
                        fontSize: 28,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Loading state
          if (_person == null)
            const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            )
          else ...[
            // Known for department + personal info
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_person!['known_for_department'] != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _person!['known_for_department'],
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.primary,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                    _buildInfoChips(),
                  ],
                ),
              ),
            ),

            // Biography
            if ((_person!['biography'] ?? '').toString().isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Biography',
                          style: AppTextStyles.headlineSmall
                              .copyWith(fontSize: 18)),
                      const SizedBox(height: 8),
                      AnimatedCrossFade(
                        firstChild: Text(
                          _person!['biography'],
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.onSurfaceVariant,
                            fontSize: 14,
                            height: 1.6,
                          ),
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                        ),
                        secondChild: Text(
                          _person!['biography'],
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.onSurfaceVariant,
                            fontSize: 14,
                            height: 1.6,
                          ),
                        ),
                        crossFadeState: _bioExpanded
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        duration: const Duration(milliseconds: 300),
                      ),
                      const SizedBox(height: 4),
                      GestureDetector(
                        onTap: () =>
                            setState(() => _bioExpanded = !_bioExpanded),
                        child: Text(
                          _bioExpanded ? 'Show less' : 'Read more',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.primary,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Filmography
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 8),
                child: Text('Known For',
                    style: AppTextStyles.headlineSmall.copyWith(fontSize: 18)),
              ),
            ),

            SliverToBoxAdapter(
              child: SizedBox(
                height: 260,
                child: _buildFilmography(),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoChips() {
    final chips = <Widget>[];

    if (_person!['birthday'] != null) {
      chips.add(_infoChip(Icons.cake_outlined, _person!['birthday']));
    }
    if (_person!['place_of_birth'] != null) {
      chips.add(_infoChip(Icons.place_outlined, _person!['place_of_birth']));
    }
    if (_person!['deathday'] != null) {
      chips.add(_infoChip(Icons.event_outlined, 'Died: ${_person!['deathday']}'));
    }

    if (chips.isEmpty) return const SizedBox.shrink();

    return Wrap(spacing: 8, runSpacing: 8, children: chips);
  }

  Widget _infoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.onSurfaceVariant),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              text,
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.onSurfaceVariant,
                fontWeight: FontWeight.w400,
                fontSize: 11,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilmography() {
    final credits = _person?['combined_credits']?['cast'] as List?;
    if (credits == null || credits.isEmpty) {
      return Center(
        child: Text('No credits found',
            style: AppTextStyles.bodyMedium
                .copyWith(color: AppColors.onSurfaceVariant)),
      );
    }

    // Sort by popularity descending, deduplicate by ID
    final seen = <int>{};
    final sorted = List<Map<String, dynamic>>.from(credits)
      ..sort((a, b) => ((b['popularity'] ?? 0) as num)
          .compareTo((a['popularity'] ?? 0) as num));
    final unique = sorted.where((c) {
      final id = c['id'] as int?;
      if (id == null || seen.contains(id)) return false;

      // Filter out guest/talk show appearances
      final character = (c['character'] ?? '').toString().toLowerCase();
      final genreIds = c['genre_ids'] as List?;
      final isGuest = character.contains('self') ||
          character.contains('guest') ||
          character.contains('himself') ||
          character.contains('herself');
      final isTalkShow =
          genreIds != null && (genreIds.contains(10767) || genreIds.contains(10763));

      if (isGuest || isTalkShow) return false;

      seen.add(id);
      return c['poster_path'] != null;
    }).take(20).toList();

    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: unique.length,
      separatorBuilder: (_, __) => const SizedBox(width: 16),
      itemBuilder: (context, index) {
        final c = unique[index];
        final mediaType = c['media_type'] ?? 'movie';
        final isMovie = mediaType == 'movie';
        final title = isMovie ? (c['title'] ?? '') : (c['name'] ?? '');
        final posterPath = c['poster_path'];
        final posterUrl = posterPath != null
            ? 'https://image.tmdb.org/t/p/w500$posterPath'
            : '';
        final year = isMovie
            ? (c['release_date'] ?? '').toString()
            : (c['first_air_date'] ?? '').toString();
        final yearStr = year.length >= 4 ? year.substring(0, 4) : '';
        final character = c['character'] ?? '';
        final subtitle = character.isNotEmpty
            ? character
            : '${isMovie ? 'Movie' : 'TV'}${yearStr.isNotEmpty ? ' • $yearStr' : ''}';

        return ContentCard(
          imageUrl: posterUrl,
          title: title,
          subtitle: subtitle,
          onTap: () {
            final item = MediaItem(
              id: c['id'] ?? 0,
              title: title,
              posterPath: posterPath,
              backdropPath: c['backdrop_path'],
              mediaType: mediaType,
              overview: c['overview'],
              voteAverage: (c['vote_average'] ?? 0).toDouble(),
              releaseDate: isMovie ? c['release_date'] : c['first_air_date'],
            );
            _openDetails(item);
          },
        );
      },
    );
  }
}
