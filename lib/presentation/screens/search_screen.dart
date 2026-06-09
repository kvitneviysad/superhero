// lib/presentation/screens/search_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_theme.dart';
import '../blocs/search/search_bloc.dart';
import '../widgets/error_view.dart';
import '../widgets/hero_card.dart';
import '../widgets/shimmer_card.dart';
import 'detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SUPERHERO ARCHIVE'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Рядок пошуку
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              style: AppTheme.bodyMedium.copyWith(color: AppTheme.textPrimary),
              onChanged: (query) {
                context.read<SearchBloc>().add(SearchQueryChanged(query));
              },
              decoration: InputDecoration(
                hintText: 'Search heroes (e.g., Batman, Yoda)...',
                hintStyle: AppTheme.bodyMedium,
                prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.textSecondary),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear_rounded, color: AppTheme.textSecondary),
                  onPressed: () {
                    _searchController.clear();
                    context.read<SearchBloc>().add(const SearchQueryChanged(''));
                  },
                ),
                filled: true,
                fillColor: AppTheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppTheme.accent, width: 1.5),
                ),
              ),
            ),
          ),

          Expanded(
            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                if (state is SearchLoading) {
                  return const ShimmerGrid();
                } else if (state is SearchLoaded) {
                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: 0.72,
                    ),
                    itemCount: state.heroes.length,
                    itemBuilder: (context, index) {
                      final hero = state.heroes[index];
                      return HeroCard(
                        hero: hero,
                        index: index,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailScreen(
                                heroId: hero.id,
                                heroName: hero.name,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                } else if (state is SearchEmpty) {
                  return Center(
                    child: Text(
                      'No heroes found for "${state.query}"',
                      style: AppTheme.bodyMedium,
                    ),
                  );
                } else if (state is SearchError) {
                  return ErrorView(
                    message: state.message,
                    onRetry: () {
                      context.read<SearchBloc>().add(SearchRetry(state.lastQuery));
                    },
                  );
                }
                return const Center(child: Text('Type to explore the archive...'));
              },
            ),
          ),
        ],
      ),
    );
  }
}