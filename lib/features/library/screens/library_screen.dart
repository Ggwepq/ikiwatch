import 'package:flutter/material.dart';
import '../../../core/models/content_filter.dart';
import '../../../core/models/media_item.dart';
import '../../../core/services/tmdb_service.dart';
import '../../../core/services/peachify_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/content_card.dart';
import '../../details/screens/show_details_screen.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  ContentFilter _filter = ContentFilter.all;
  bool _loading = true;

  List<MediaItem> _trending = [];
  List<MediaItem> _popular = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_onTabChanged);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) {
      final filters = [
        ContentFilter.all,
        ContentFilter.movie,
        ContentFilter.tv,
        ContentFilter.kdrama,
      ];
      setState(() => _filter = filters[_tabController.index]);
      _loadData();
    }
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);

    if (_filter == ContentFilter.kdrama) {
      final results = await Future.wait([
        TmdbService.getKdramas(),
        TmdbService.getKdramas(sortBy: 'vote_average.desc'),
      ]);
      if (!mounted) return;
      setState(() {
        _trending = results[0];
        _popular = results[1];
        _loading = false;
      });
    } else {
      final mt = _filter.mediaType;
      final results = await Future.wait([
        TmdbService.getTrending(mediaType: mt),
        TmdbService.getPopular(mediaType: mt == 'all' ? 'movie' : mt),
      ]);
      if (!mounted) return;
      setState(() {
        _trending = results[0];
        _popular = results[1];
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
      appBar: AppBar(
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),

            // Continue Watching section
            AnimatedBuilder(
              animation: PeachifyService.instance,
              builder: (context, _) {
                final progressList = PeachifyService.instance.getAllProgress();
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
                  );
                }).toList();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                          // Calculate subtitle
                          String subtitle = item.mediaType == 'movie' ? 'Movie' : 'TV Series';
                          final p = progressList[index];
                          if (p['type'] == 'tv' && p['last_season_watched'] != null) {
                            subtitle = 'S${p['last_season_watched']} E${p['last_episode_watched']}';
                          } else if (p['type'] == 'movie' && p['progress'] != null) {
                            final w = p['progress']['watched'] ?? 0;
                            final d = p['progress']['duration'] ?? 1;
                            subtitle = '${((w / d) * 100).toInt()}% watched';
                          }

                          return _WideCard(
                            item: item, 
                            customSubtitle: subtitle,
                            onTap: () => _openDetails(item)
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                );
              },
            ),

            // Recommendations header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text('For You',
                  style: AppTextStyles.headlineMedium
                      .copyWith(color: AppColors.primary, fontSize: 28)),
            ),
            const SizedBox(height: 16),

            // Trending carousel
            if (!_loading && _trending.isNotEmpty) ...[
              SizedBox(
                height: 190,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: _trending.length.clamp(0, 8),
                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    final item = _trending[index];
                    return _WideCard(item: item, onTap: () => _openDetails(item));
                  },
                ),
              ),
            ],
            if (_loading)
              const SizedBox(
                height: 190,
                child: Center(
                    child: CircularProgressIndicator(color: AppColors.primary)),
              ),

            const SizedBox(height: 32),

            // Library header + tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text('Browse',
                  style: AppTextStyles.headlineMedium
                      .copyWith(color: AppColors.primary, fontSize: 28)),
            ),
            const SizedBox(height: 16),

            // Tab bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.onSurfaceVariant,
                labelStyle: AppTextStyles.labelMedium,
                unselectedLabelStyle: AppTextStyles.labelMedium,
                indicatorColor: AppColors.primary,
                indicatorWeight: 2,
                dividerColor: AppColors.outlineVariant,
                tabs: const [
                  Tab(text: 'All'),
                  Tab(text: 'Movies'),
                  Tab(text: 'TV Shows'),
                  Tab(text: 'K-Drama'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Grid
            if (!_loading)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.55,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 20,
                  ),
                  itemCount: _popular.length.clamp(0, 10),
                  itemBuilder: (context, index) {
                    final item = _popular[index];
                    return ContentCard(
                      imageUrl: item.posterUrl,
                      title: item.title,
                      subtitle: item.subtitle,
                      width: double.infinity,
                      onTap: () => _openDetails(item),
                    );
                  },
                ),
              ),
            if (_loading)
              const SizedBox(
                height: 200,
                child: Center(
                    child: CircularProgressIndicator(color: AppColors.primary)),
              ),
          ],
        ),
      ),
    );
  }
}

class _WideCard extends StatelessWidget {
  final MediaItem item;
  final VoidCallback? onTap;
  final String? customSubtitle;
  const _WideCard({required this.item, this.onTap, this.customSubtitle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 260,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: item.backdropUrl.isNotEmpty
                    ? Image.network(item.backdropUrl, fit: BoxFit.cover,
                        errorBuilder: (_, _a, _b) =>
                            Container(color: AppColors.surfaceContainerHigh))
                    : Container(color: AppColors.surfaceContainerHigh),
              ),
            ),
            const SizedBox(height: 10),
            Text(item.title,
                style: AppTextStyles.labelMedium.copyWith(fontSize: 15),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            Text(customSubtitle ?? item.subtitle,
                style: AppTextStyles.bodyMedium
                    .copyWith(fontSize: 13, color: AppColors.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}
