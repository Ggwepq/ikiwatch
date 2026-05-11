import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../details/screens/show_details_screen.dart';
import '../widgets/content_carousel.dart';
import '../widgets/hero_banner.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openDetails(BuildContext context, ShowItem item) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ShowDetailsScreen(show: item)),
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
            title: Text(
              'IKIWATCH',
              style: AppTextStyles.brandTitle.copyWith(color: AppColors.primary),
            ),
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

          // Hero banner
          SliverToBoxAdapter(
            child: HeroBanner(
              imageUrl: MockData.heroImage,
              title: 'The Marshmallow Heart',
              description: 'A gentle exploration of love, loss, and the sweetness found in quiet, shared moments at dusk.',
              onWatch: () {},
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 32)),

          // Trending Now
          SliverToBoxAdapter(
            child: ContentCarousel(
              title: 'Trending Now',
              items: MockData.trendingNow,
              onItemTap: (item) => _openDetails(context, item),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 32)),

          // Top Rated
          SliverToBoxAdapter(
            child: ContentCarousel(
              title: 'Top Rated',
              items: MockData.topRated,
              onItemTap: (item) => _openDetails(context, item),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 32)),

          // New Releases
          SliverToBoxAdapter(
            child: ContentCarousel(
              title: 'New Releases',
              items: MockData.newReleases,
              onItemTap: (item) => _openDetails(context, item),
            ),
          ),

          // Bottom padding for nav bar
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}
