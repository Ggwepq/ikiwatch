import 'package:flutter/material.dart';
import '../../../core/models/media_item.dart';
import '../../../core/widgets/content_card.dart';
import '../../../core/widgets/section_header.dart';

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
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final item = items[index];
              return ContentCard(
                imageUrl: item.posterUrl,
                title: item.title,
                subtitle: item.subtitle,
                onTap: () => onItemTap?.call(item),
              );
            },
          ),
        ),
      ],
    );
  }
}
