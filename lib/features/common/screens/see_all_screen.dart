import 'package:flutter/material.dart';
import '../../../core/models/media_item.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/content_card.dart';
import '../../details/screens/show_details_screen.dart';

class SeeAllScreen extends StatelessWidget {
  final String title;
  final List<MediaItem> items;

  const SeeAllScreen({
    super.key,
    required this.title,
    required this.items,
  });

  void _openDetails(BuildContext context, MediaItem item) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ShowDetailsScreen(media: item)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(title, style: AppTextStyles.headlineSmall),
        backgroundColor: AppColors.surface,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(height: 0.5, color: AppColors.outlineVariant),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.55,
          crossAxisSpacing: 16,
          mainAxisSpacing: 20,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return ContentCard(
            imageUrl: item.posterUrl,
            title: item.title,
            subtitle: item.subtitle,
            width: double.infinity,
            onTap: () => _openDetails(context, item),
          );
        },
      ),
    );
  }
}
