import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/models/content_filter.dart';
import '../../../core/models/media_item.dart';
import '../../../core/services/tmdb_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../details/screens/show_details_screen.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final _searchController = TextEditingController();
  Timer? _debounce;
  ContentFilter _filter = ContentFilter.all;

  List<MediaItem> _searchResults = [];
  List<MediaItem> _popular = [];
  bool _loading = true;
  bool _searching = false;

  @override
  void initState() {
    super.initState();
    _loadPopular();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _loadPopular() async {
    setState(() => _loading = true);
    List<MediaItem> results;
    if (_filter == ContentFilter.kdrama) {
      results = await TmdbService.getKdramas();
    } else {
      final mt = _filter.mediaType;
      results = await TmdbService.getPopular(mediaType: mt == 'all' ? 'movie' : mt);
    }
    if (!mounted) return;
    setState(() {
      _popular = results;
      _loading = false;
    });
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _searching = false;
      });
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      setState(() => _searching = true);
      final results = await TmdbService.search(query);
      if (!mounted) return;
      setState(() {
        _searchResults = results;
        _searching = false;
      });
    });
  }

  void _openDetails(MediaItem item) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ShowDetailsScreen(media: item)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSearching = _searchController.text.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('IKIWATCH',
            style: AppTextStyles.brandTitle.copyWith(color: AppColors.primary)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(height: 0.5, color: AppColors.outlineVariant),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),

          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search movies, shows, K-dramas...',
                prefixIcon: Icon(Icons.search, color: AppColors.outline),
                suffixIcon: isSearching
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged('');
                        },
                      )
                    : null,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Filter chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
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
                        _loadPopular();
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
          const SizedBox(height: 16),

          // Content
          Expanded(
            child: isSearching
                ? _buildSearchResults()
                : _buildPopularSection(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_searching) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }
    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off, size: 48, color: AppColors.outlineVariant),
            const SizedBox(height: 12),
            Text('No results found',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.outline)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final item = _searchResults[index];
        return _SearchResultTile(item: item, onTap: () => _openDetails(item));
      },
    );
  }

  Widget _buildPopularSection() {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }
    return ListView(
      padding: const EdgeInsets.only(bottom: 100),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text('Popular Right Now',
              style: AppTextStyles.headlineMedium
                  .copyWith(color: AppColors.primary, fontSize: 28)),
        ),
        const SizedBox(height: 16),
        ...List.generate(_popular.length.clamp(0, 15), (i) {
          final item = _popular[i];
          return _SearchResultTile(item: item, onTap: () => _openDetails(item));
        }),
      ],
    );
  }
}

class _SearchResultTile extends StatelessWidget {
  final MediaItem item;
  final VoidCallback? onTap;
  const _SearchResultTile({required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 60,
                height: 85,
                child: item.posterUrl.isNotEmpty
                    ? Image.network(item.posterUrl, fit: BoxFit.cover,
                        errorBuilder: (_, _a, _b) =>
                            Container(color: AppColors.surfaceContainerHigh))
                    : Container(
                        color: AppColors.surfaceContainerHigh,
                        child: Icon(Icons.movie, color: AppColors.outlineVariant)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title,
                      style: AppTextStyles.labelMedium.copyWith(fontSize: 15),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(item.subtitle,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.onSurfaceVariant, fontSize: 13)),
                  if (item.voteAverage > 0) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.star, size: 14, color: AppColors.primary),
                        const SizedBox(width: 4),
                        Text(item.voteAverage.toStringAsFixed(1),
                            style: AppTextStyles.labelSmall
                                .copyWith(color: AppColors.primary)),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.outline),
          ],
        ),
      ),
    );
  }
}
