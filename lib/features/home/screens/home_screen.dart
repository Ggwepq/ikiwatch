import 'package:flutter/material.dart';
import '../../../core/models/content_filter.dart';
import '../../../core/models/media_item.dart';
import '../../../core/services/tmdb_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../details/screens/show_details_screen.dart';
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
      ]);
      if (!mounted) return;
      setState(() {
        _trending = results[0];
        _topRated = results[1];
        _newReleases = results[2];
        _loading = false;
      });
    } else {
      final mt = _filter.mediaType;
      final results = await Future.wait([
        TmdbService.getTrending(mediaType: mt),
        TmdbService.getTopRated(mediaType: mt == 'all' ? 'movie' : mt),
        TmdbService.getNowPlaying(mediaType: mt == 'all' ? 'movie' : mt),
      ]);
      if (!mounted) return;
      setState(() {
        _trending = results[0];
        _topRated = results[1];
        _newReleases = results[2];
        _loading = false;
      });
    }
  }

  void _openDetails(MediaItem item) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ShowDetailsScreen(media: item)),
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
            actions: [
              IconButton(
                icon: Icon(Icons.search, color: AppColors.onSurfaceVariant),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
            ],
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
                  imageUrl: _trending.first.backdropUrl,
                  title: _trending.first.title,
                  description: _trending.first.overview ?? '',
                  onWatch: () => _openDetails(_trending.first),
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
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ],
      ),
    );
  }
}
