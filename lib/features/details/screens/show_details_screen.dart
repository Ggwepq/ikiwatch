import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class ShowDetailsScreen extends StatelessWidget {
  final ShowItem show;
  const ShowDetailsScreen({super.key, required this.show});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Collapsing hero app bar
          SliverAppBar(
            expandedHeight: 260,
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
                  Image.network(
                    MockData.imgPetalsHero,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: AppColors.surfaceContainerHigh),
                  ),
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
                ],
              ),
            ),
          ),

          // Info card
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: const Offset(0, -20),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
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
                      Text(
                        'Petals in the Wind',
                        style: AppTextStyles.headlineMedium.copyWith(fontSize: 26),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.star, size: 16, color: AppColors.primary),
                          const SizedBox(width: 4),
                          Text('4.8', style: AppTextStyles.labelMedium.copyWith(color: AppColors.primary)),
                          _dot(),
                          Text('Drama', style: AppTextStyles.labelMedium.copyWith(color: AppColors.onSurfaceVariant)),
                          _dot(),
                          Text('2024', style: AppTextStyles.labelMedium.copyWith(color: AppColors.onSurfaceVariant)),
                          _dot(),
                          Text('12 Episodes', style: AppTextStyles.labelMedium.copyWith(color: AppColors.onSurfaceVariant)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('WATCH LATEST EPISODE'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.add),
                          label: const Text('MY LIST'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Episodes section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Episodes', style: AppTextStyles.headlineSmall),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.outlineVariant),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('SEASON 01', style: AppTextStyles.labelMedium.copyWith(color: AppColors.primary, fontSize: 12)),
                            const SizedBox(width: 4),
                            Icon(Icons.expand_more, size: 16, color: AppColors.primary),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Divider(color: AppColors.outlineVariant),
                ],
              ),
            ),
          ),

          // Episode list
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final ep = MockData.episodes[index];
                return _EpisodeListItem(episode: ep);
              },
              childCount: MockData.episodes.length,
            ),
          ),

          // Synopsis
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Synopsis', style: AppTextStyles.headlineSmall.copyWith(fontSize: 18)),
                  const SizedBox(height: 12),
                  Text(
                    'A gentle tale of serendipity set against the backdrop of a quiet seaside town. When an aspiring artist meets a weary traveler, their worlds collide in a soft symphony of shared dreams and quiet moments.',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    children: ['Romantic', 'Slice of Life'].map((g) => Chip(
                      label: Text(g, style: AppTextStyles.labelSmall.copyWith(fontSize: 11, color: AppColors.onSurfaceVariant)),
                      backgroundColor: AppColors.surfaceContainerHigh,
                      side: BorderSide(color: AppColors.outlineVariant),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    )).toList(),
                  ),
                ],
              ),
            ),
          ),

          // Details section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(color: AppColors.outlineVariant),
                  const SizedBox(height: 16),
                  Text('DETAILS', style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.outline, letterSpacing: 1.5,
                  )),
                  const SizedBox(height: 16),
                  _detailRow('Director', 'Hana Sasaki'),
                  _detailRow('Cast', 'Kenji Sato, Yumi Ito'),
                  _detailRow('Audio', 'Japanese (Stereo)'),
                  _detailRow('Subtitles', 'English, Spanish'),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  Widget _dot() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: Container(
      width: 4, height: 4,
      decoration: BoxDecoration(
        color: AppColors.outlineVariant,
        shape: BoxShape.circle,
      ),
    ),
  );

  Widget _detailRow(String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodyMedium.copyWith(fontSize: 14, color: AppColors.outline)),
        Text(value, style: AppTextStyles.bodyMedium.copyWith(fontSize: 14, fontWeight: FontWeight.w500)),
      ],
    ),
  );
}

class _EpisodeListItem extends StatelessWidget {
  final EpisodeItem episode;
  const _EpisodeListItem({required this.episode});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: episode.locked ? 0.5 : 1.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(episode.imageUrl, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(color: AppColors.surfaceContainerHigh),
                    ),
                    if (episode.locked)
                      Center(child: Icon(Icons.lock, color: Colors.white, size: 28)),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(episode.duration,
                          style: AppTextStyles.labelSmall.copyWith(color: Colors.white, fontSize: 10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '${episode.number}. ${episode.title}',
              style: AppTextStyles.labelMedium.copyWith(fontSize: 15),
            ),
            const SizedBox(height: 4),
            Text(
              episode.description,
              style: AppTextStyles.bodyMedium.copyWith(
                fontSize: 13,
                color: AppColors.onSurfaceVariant,
                fontStyle: episode.locked ? FontStyle.italic : FontStyle.normal,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (episode.progress != null) ...[
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: LinearProgressIndicator(
                  value: episode.progress!,
                  backgroundColor: AppColors.surfaceContainerHighest,
                  color: AppColors.primary,
                  minHeight: 3,
                ),
              ),
            ],
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
