import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/content_card.dart';
import '../../../core/widgets/section_header.dart';

class ContentCarousel extends StatelessWidget {
  final String title;
  final List<ShowItem> items;
  final void Function(ShowItem item)? onItemTap;

  const ContentCarousel({
    super.key,
    required this.title,
    required this.items,
    this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: title, onSeeAll: () {}),
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
                imageUrl: item.imageUrl,
                title: item.title,
                subtitle: item.subtitle,
                badge: item.badge,
                onTap: () => onItemTap?.call(item),
              );
            },
          ),
        ),
      ],
    );
  }
}
