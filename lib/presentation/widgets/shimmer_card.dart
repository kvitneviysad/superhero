// lib/presentation/widgets/shimmer_card.dart

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/constants/app_theme.dart';

class ShimmerHeroCard extends StatelessWidget {
  const ShimmerHeroCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor:  AppTheme.shimmerBase,
      highlightColor: AppTheme.shimmerHigh,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // image placeholder
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: AppTheme.surfaceAlt,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 14, width: double.infinity,
                    color: AppTheme.surfaceAlt,
                  ),
                  const SizedBox(height: 6),
                  Container(height: 10, width: 80, color: AppTheme.surfaceAlt),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A full-screen shimmer grid for the list view.
class ShimmerGrid extends StatelessWidget {
  const ShimmerGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 0.72,
      ),
      itemCount: 6,
      itemBuilder: (_, __) => const ShimmerHeroCard(),
    );
  }
}
