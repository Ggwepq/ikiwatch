import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../details/screens/show_details_screen.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  void _openDetails(BuildContext context, ShowItem item) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ShowDetailsScreen(show: item)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'IKIWATCH',
          style: AppTextStyles.brandTitle.copyWith(color: AppColors.primary),
        ),
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
            const SizedBox(height: 32),

            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search for originals, movies, or shows...',
                  prefixIcon: Icon(Icons.search, color: AppColors.outline),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Trending chips
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text('Trending:', style: AppTextStyles.labelMedium.copyWith(color: AppColors.outline)),
                  ...MockData.trendingChips.map((chip) => ActionChip(
                    label: Text(chip),
                    onPressed: () {},
                  )),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Content Categories
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Content\nCategories',
                    style: AppTextStyles.headlineMedium.copyWith(
                      color: AppColors.primary,
                      fontSize: 28,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      'All Genres',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.secondary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Divider(color: AppColors.outlineVariant),
            ),
            const SizedBox(height: 16),

            // Category cards
            ...MockData.categories.map((cat) => Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              child: _CategoryCard(category: cat),
            )),

            const SizedBox(height: 32),

            // Popular Right Now
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Popular Right Now',
                style: AppTextStyles.headlineMedium.copyWith(
                  color: AppColors.primary,
                  fontSize: 28,
                ),
              ),
            ),
            const SizedBox(height: 16),

            ...MockData.popularNow.map((item) => _PopularItem(
              item: item,
              onTap: () => _openDetails(context, item),
            )),
          ],
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final CategoryItem category;
  const _CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: AspectRatio(
        aspectRatio: 16 / 7,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (category.imageUrl != null)
              Image.network(category.imageUrl!, fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: AppColors.surfaceContainerHigh),
              )
            else
              Container(color: AppColors.secondaryContainer),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withValues(alpha: 0.6)],
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 20,
              child: Text(
                category.title,
                style: AppTextStyles.headlineSmall.copyWith(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PopularItem extends StatelessWidget {
  final ShowItem item;
  final VoidCallback? onTap;
  const _PopularItem({required this.item, this.onTap});

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
                width: 80,
                height: 80,
                child: Image.network(item.imageUrl, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(color: AppColors.surfaceContainerHigh),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title, style: AppTextStyles.headlineSmall.copyWith(fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(item.subtitle, style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 14,
                  )),
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
