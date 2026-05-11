import 'package:flutter/material.dart';
import '../../../core/models/media_item.dart';
import '../../../core/widgets/content_card.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/services/peachify_service.dart';

class ContentCarousel extends StatelessWidget {
  final String title;
  final List<MediaItem> items;
  final void Function(MediaItem item)? onItemTap;
  final VoidCallback? onSeeAll;

  const ContentCarousel({
    super.key,
    required this.title,
    required this.items,
    this.onItemTap,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: title, onSeeAll: onSeeAll ?? () {}),
        const SizedBox(height: 16),
        SizedBox(
          height: 260,
          child: AnimatedBuilder(
            animation: PeachifyService.instance,
            builder: (context, _) {
              return ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: items.length > 8 ? 8 : items.length,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final item = items[index];
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

                  return ContentCard(
                    imageUrl: item.posterUrl,
                    title: item.title,
                    subtitle: item.subtitle,
                    progress: progressValue,
                    onTap: () => onItemTap?.call(item),
                  );
                },
              );
            }
          ),
        ),
      ],
    );
  }
}
