// lib/presentation/widgets/hero_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_theme.dart';
import '../../domain/models/superhero_model.dart';
import 'hero_image_widget.dart'; // ← імпорт нового віджета

class HeroCard extends StatelessWidget {
  final SuperheroModel hero;
  final VoidCallback onTap;
  final int index;

  const HeroCard({
    super.key,
    required this.hero,
    required this.onTap,
    this.index = 0,
  });

  static String _sanitizeUrl(String raw) {
    if (raw.isEmpty) return '';
    return raw.startsWith('http://')
        ? raw.replaceFirst('http://', 'https://')
        : raw;
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = _sanitizeUrl(hero.image.url);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [AppTheme.surface, AppTheme.surfaceAlt],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.accentGlow.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // ← тільки це, більше нічого
                    HeroNetworkImage(url: imageUrl),
                    Positioned(
                      bottom: 0, left: 0, right: 0,
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              AppTheme.surface.withOpacity(0.9),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8, right: 8,
                      child: _AlignmentBadge(
                        alignment: hero.biography.alignment,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hero.name,
                      style: AppTheme.titleMedium.copyWith(fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (hero.biography.publisher.isNotEmpty &&
                        hero.biography.publisher != '-')
                      Text(
                        hero.biography.publisher,
                        style: AppTheme.labelSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: 60 * index))
        .fadeIn(duration: 350.ms)
        .slideY(begin: 0.15, end: 0, duration: 350.ms, curve: Curves.easeOut);
  }
}

class _AlignmentBadge extends StatelessWidget {
  final String alignment;
  const _AlignmentBadge({required this.alignment});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (alignment.toLowerCase()) {
      case 'good':
        color = const Color(0xFF4ECDC4);
        break;
      case 'bad':
        color = AppTheme.error;
        break;
      default:
        color = AppTheme.textSecondary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.85),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        alignment.toUpperCase(),
        style: AppTheme.labelSmall.copyWith(
          color: Colors.white,
          fontSize: 9,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}