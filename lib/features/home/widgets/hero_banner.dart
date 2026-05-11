import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/models/media_item.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/services/peachify_service.dart';

class HeroBanner extends StatefulWidget {
  final List<MediaItem> items;
  final void Function(MediaItem item)? onWatch;
  final void Function(MediaItem item)? onTapItem;

  const HeroBanner({
    super.key,
    required this.items,
    this.onWatch,
    this.onTapItem,
  });

  @override
  State<HeroBanner> createState() => _HeroBannerState();
}

class _HeroBannerState extends State<HeroBanner> {
  late final PageController _pageController;
  Timer? _autoScrollTimer;
  int _currentPage = 0;

  List<MediaItem> get _displayItems =>
      widget.items.take(5).toList();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted || _displayItems.isEmpty) return;
      final nextPage = (_currentPage + 1) % _displayItems.length;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_displayItems.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        // Carousel
        SizedBox(
          height: 450,
          child: AnimatedBuilder(
            animation: PeachifyService.instance,
            builder: (context, _) {
              return PageView.builder(
                controller: _pageController,
                itemCount: _displayItems.length,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (context, index) {
                  final item = _displayItems[index];
                  final progData = PeachifyService.instance.getProgress(item.id.toString());
                  double? progressValue;
                  
                  if (progData != null) {
                    if (item.mediaType == 'movie' && progData['progress'] != null) {
                      double w = (progData['progress']['watched'] as num?)?.toDouble() ?? 0.0;
                      double d = (progData['progress']['duration'] as num?)?.toDouble() ?? 1.0;
                      if (d <= 0 || d.isNaN) d = 1.0;
                      if (w.isNaN || w.isInfinite) w = 0.0;
                      progressValue = (w / d).clamp(0.0, 1.0);
                    } else if (item.mediaType == 'tv' && progData['last_season_watched'] != null) {
                      final epKey = 's${progData['last_season_watched']}e${progData['last_episode_watched']}';
                      if (progData['show_progress'] != null && progData['show_progress'][epKey] != null) {
                        final epProg = progData['show_progress'][epKey]['progress'];
                        if (epProg != null) {
                          double w = (epProg['watched'] as num?)?.toDouble() ?? 0.0;
                          double d = (epProg['duration'] as num?)?.toDouble() ?? 1.0;
                          if (d <= 0 || d.isNaN) d = 1.0;
                          if (w.isNaN || w.isInfinite) w = 0.0;
                          progressValue = (w / d).clamp(0.0, 1.0);
                        }
                      }
                    }
                  }

                  return _HeroSlide(
                    item: item,
                    progress: progressValue,
                    onWatch: () => widget.onWatch?.call(item),
                    onTapItem: () => widget.onTapItem?.call(item),
                  );
                },
              );
            }
          ),
        ),

        // Dot indicators
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_displayItems.length, (i) {
            final isActive = i == _currentPage;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: isActive ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : AppColors.outlineVariant,
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _HeroSlide extends StatelessWidget {
  final MediaItem item;
  final double? progress;
  final VoidCallback? onWatch;
  final VoidCallback? onTapItem;

  const _HeroSlide({required this.item, this.progress, this.onWatch, this.onTapItem});

  @override
  Widget build(BuildContext context) {
    final imageUrl = item.backdropUrl.isNotEmpty
        ? item.backdropUrl
        : item.posterUrl;

    return GestureDetector(
      onTap: onTapItem,
      child: Stack(
        fit: StackFit.expand,
        children: [
        if (imageUrl.isNotEmpty)
          Image.network(imageUrl, fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                Container(color: AppColors.surfaceContainerHigh),
          ),
        // Gradient overlay
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Color(0x33000000),
                Color(0xCC000000),
              ],
              stops: [0.0, 0.5, 1.0],
            ),
          ),
        ),
        // Content
        Positioned(
          left: 24,
          right: 24,
          bottom: 24,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.tertiary.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  item.mediaType == 'movie' ? 'FEATURED FILM' : 'FEATURED SERIES',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.onTertiary,
                    fontSize: 10,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              if (progress != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.white24,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                    minHeight: 4,
                  ),
                ),
                const SizedBox(height: 10),
              ],
              Text(
                item.title,
                style: AppTextStyles.displayLargeMobile
                    .copyWith(color: Colors.white),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (item.overview != null && item.overview!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  item.overview!,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onWatch,
                      icon: const Icon(Icons.play_arrow, size: 20),
                      label: const Text('WATCH NOW'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add, size: 20),
                    label: const Text('MY LIST'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: BorderSide(
                          color: Colors.white.withValues(alpha: 0.3)),
                      backgroundColor: Colors.white.withValues(alpha: 0.1),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
      ),
    );
  }
}
