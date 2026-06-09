// lib/presentation/widgets/stat_bar.dart
// Animated progress bar used on the Detail screen for each powerstat.

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_theme.dart';

class StatBar extends StatelessWidget {
  final String label;
  final int value;   // 0–100
  final Color color;

  const StatBar({
    super.key,
    required this.label,
    required this.value,
    this.color = AppTheme.accent,
  });

  @override
  Widget build(BuildContext context) {
    final clamped = value.clamp(0, 100);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label.toUpperCase(), style: AppTheme.labelSmall),
              Text(
                '$clamped',
                style: AppTheme.statValue.copyWith(fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: clamped / 100,
              minHeight: 7,
              backgroundColor: AppTheme.divider,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ).animate().scaleX(
            alignment: Alignment.centerLeft,
            duration: 700.ms,
            curve: Curves.easeOut,
          ),
        ],
      ),
    );
  }
}
