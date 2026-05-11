import 'package:flutter/material.dart';
import '../models/media_item.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class ContinueWatchingCard extends StatelessWidget {
  final MediaItem item;
  final VoidCallback? onTap;
  final String subtitle;
  final double progress; // 0.0 to 1.0

  const ContinueWatchingCard({
    super.key,
    required this.item,
    this.onTap,
    required this.subtitle,
    required this.progress,
  });

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
            // Progress Bar
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: AppColors.surfaceContainerHigh,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                minHeight: 4,
              ),
            ),
            const SizedBox(height: 8),
            Text(item.title,
                style: AppTextStyles.labelMedium.copyWith(fontSize: 15),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            Text(subtitle,
                style: AppTextStyles.bodyMedium
                    .copyWith(fontSize: 13, color: AppColors.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}
