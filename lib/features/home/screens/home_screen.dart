import 'package:flutter/material.dart';
import '../../../core/models/content_filter.dart';
import '../../../core/models/media_item.dart';
import '../../../core/services/tmdb_service.dart';
import '../../../core/services/peachify_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/continue_watching_card.dart';
import '../../common/screens/see_all_screen.dart';
import '../../details/screens/show_details_screen.dart';
import '../../player/screens/player_screen.dart';
import '../widgets/hero_banner.dart';
import '../widgets/content_carousel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ContentFilter _filter = ContentFilter.all;
  bool _loading = true;

  List<MediaItem> _trending = [];
  List<MediaItem> _topRated = [];
  List<MediaItem> _newReleases = [];
  List<MediaItem> _upcoming = [];
  List<MediaItem> _airingToday = [];
  List<MediaItem> _popularKdramas = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);

    if (_filter == ContentFilter.kdrama) {
      final results = await Future.wait([
        TmdbService.getKdramas(),
        TmdbService.getKdramas(sortBy: 'vote_average.desc'),
        TmdbService.getKdramas(sortBy: 'first_air_date.desc'),
        TmdbService.getKdramas(sortBy: 'popularity.asc'), // As "upcoming" fallback
        TmdbService.getKdramasAiringToday(),
      ]);
      if (!mounted) return;
      setState(() {
        _trending = results[0];
        _topRated = results[1];
        _newReleases = results[2];
        _upcoming = results[3];
        _airingToday = results[4];
        _popularKdramas = []; // Already showing kdramas
        _loading = false;
      });
    } else {
      final mt = _filter.mediaType;
      final results = await Future.wait([
        TmdbService.getTrending(mediaType: mt),
        TmdbService.getTopRated(mediaType: mt == 'all' ? 'movie' : mt),
        TmdbService.getNowPlaying(mediaType: mt == 'all' ? 'movie' : mt),
        mt != 'tv' ? TmdbService.getUpcoming() : Future.value(<MediaItem>[]),
        mt != 'movie' ? TmdbService.getAiringToday() : Future.value(<MediaItem>[]),
        TmdbService.getKdramas(),
      ]);
      if (!mounted) return;
      setState(() {
        _trending = results[0];
        _topRated = results[1];
        _newReleases = results[2];
        _upcoming = results[3];
        _airingToday = results[4];
        _popularKdramas = results[5];
        _loading = false;
      });
    }
  }

  void _openDetails(MediaItem item) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ShowDetailsScreen(media: item)),
    );
  }

  void _openPlayer(MediaItem item) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => PlayerScreen(
        tmdbId: item.id,
        title: item.title,
        mediaType: item.mediaType,
        isKdrama: item.isKdrama || _filter == ContentFilter.kdrama,
      )),
    );
  }

  void _openSeeAll(String title, List<MediaItem> items) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => SeeAllScreen(title: title, items: items)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App bar
          SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: AppColors.surface.withValues(alpha: 0.95),
            title: Text('IKIWATCH',
                style: AppTextStyles.brandTitle.copyWith(color: AppColors.primary)),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(0.5),
              child: Container(height: 0.5, color: AppColors.outlineVariant),
            ),
          ),

          // Filter chips
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ContentFilter.values.map((f) {
                    final isActive = f == _filter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(f.label),
                        selected: isActive,
                        onSelected: (_) {
                          setState(() => _filter = f);
                          _loadData();
                        },
                        selectedColor: AppColors.primary,
                        checkmarkColor: AppColors.onPrimary,
                        labelStyle: AppTextStyles.labelMedium.copyWith(
                          color: isActive ? AppColors.onPrimary : AppColors.onSurfaceVariant,
                        ),
                        backgroundColor: AppColors.surfaceContainer,
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),

          if (_loading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
            )
          else ...[
            // Hero banner
            if (_trending.isNotEmpty)
              SliverToBoxAdapter(
                child: HeroBanner(
                  items: _trending,
                  onWatch: _openPlayer,
                  onTapItem: _openDetails,
                ),
              ),

            // Continue Watching section
            SliverToBoxAdapter(
              child: AnimatedBuilder(
                animation: PeachifyService.instance,
                builder: (context, _) {
                  var progressList = PeachifyService.instance.getAllProgress();
                  
                  // Filter based on active tab
                  if (_filter == ContentFilter.movie) {
                    progressList = progressList.where((p) => p['type'] == 'movie').toList();
                  } else if (_filter == ContentFilter.tv) {
                    progressList = progressList.where((p) => p['type'] == 'tv').toList();
                  } else if (_filter == ContentFilter.kdrama) {
                    progressList = progressList.where((p) => p['type'] == 'tv' && p['is_kdrama'] == true).toList();
                  }

                  if (progressList.isEmpty) return const SizedBox.shrink();

                  final continueWatchingItems = progressList.map((p) {
                    return MediaItem(
                      id: p['id'] ?? 0,
                      title: p['title'] ?? 'Unknown',
                      overview: '',
                      posterPath: p['poster_path'] ?? '',
                      backdropPath: p['backdrop_path'] ?? p['poster_path'] ?? '',
                      mediaType: p['type'] == 'tv' ? 'tv' : 'movie',
                      voteAverage: 0.0,
                      isExplicitKdrama: p['is_kdrama'] == true,
                    );
                  }).toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 32),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text('Continue Watching',
                            style: AppTextStyles.headlineMedium
                                .copyWith(color: AppColors.primary, fontSize: 28)),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 190,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          itemCount: continueWatchingItems.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 16),
                          itemBuilder: (context, index) {
                            final item = continueWatchingItems[index];
                            String subtitle = item.mediaType == 'movie' ? 'Movie' : 'TV Series';
                            final p = progressList[index];
                            double progressValue = 0.0;
                            
                            if (p['type'] == 'tv' && p['last_season_watched'] != null) {
                              subtitle = 'S${p['last_season_watched']} E${p['last_episode_watched']}';
                              final epKey = 's${p['last_season_watched']}e${p['last_episode_watched']}';
                              if (p['show_progress'] != null && p['show_progress'][epKey] != null) {
                                 final epProg = p['show_progress'][epKey]['progress'];
                                 if (epProg != null) {
                                   final w = epProg['watched'] ?? 0;
                                   final d = epProg['duration'] ?? 1;
                                   progressValue = (w / d).clamp(0.0, 1.0);
                                 }
                              }
                            } else if (p['type'] == 'movie' && p['progress'] != null) {
                              final w = p['progress']['watched'] ?? 0;
                              final d = p['progress']['duration'] ?? 1;
                              progressValue = (w / d).clamp(0.0, 1.0);
                              subtitle = '${(progressValue * 100).toInt()}% watched';
                            }

                            return ContinueWatchingCard(
                              item: item, 
                              subtitle: subtitle,
                              progress: progressValue,
                              onTap: () => _openDetails(item)
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),

            // Trending Now
            if (_trending.isNotEmpty)
              SliverToBoxAdapter(
                child: ContentCarousel(
                  title: 'Trending Now',
                  items: _trending,
                  onItemTap: _openDetails,
                  onSeeAll: () => _openSeeAll('Trending Now', _trending),
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),

            // Top Rated
            if (_topRated.isNotEmpty)
              SliverToBoxAdapter(
                child: ContentCarousel(
                  title: 'Top Rated',
                  items: _topRated,
                  onItemTap: _openDetails,
                  onSeeAll: () => _openSeeAll('Top Rated', _topRated),
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),

            // New Releases
            if (_newReleases.isNotEmpty)
              SliverToBoxAdapter(
                child: ContentCarousel(
                  title: 'New Releases',
                  items: _newReleases,
                  onItemTap: _openDetails,
                  onSeeAll: () => _openSeeAll('New Releases', _newReleases),
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),

            // Upcoming
            if (_upcoming.isNotEmpty)
              SliverToBoxAdapter(
                child: ContentCarousel(
                  title: 'Upcoming',
                  items: _upcoming,
                  onItemTap: _openDetails,
                  onSeeAll: () => _openSeeAll('Upcoming', _upcoming),
                ),
              ),

            // Airing Today (TV only or Kdrama)
            if (_airingToday.isNotEmpty && (_filter == ContentFilter.tv || _filter == ContentFilter.kdrama)) ...[
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
              SliverToBoxAdapter(
                child: ContentCarousel(
                  title: 'Airing Today',
                  items: _airingToday,
                  onItemTap: _openDetails,
                  onSeeAll: () => _openSeeAll('Airing Today', _airingToday),
                ),
              ),
            ],

            // Popular K-Dramas Spotlight
            if (_popularKdramas.isNotEmpty && _filter != ContentFilter.kdrama) ...[
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
              SliverToBoxAdapter(
                child: ContentCarousel(
                  title: 'Popular K-Dramas',
                  items: _popularKdramas,
                  onItemTap: _openDetails,
                  onSeeAll: () => _openSeeAll('Popular K-Dramas', _popularKdramas),
                ),
              ),
            ],

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ],
      ),
    );
  }
}
