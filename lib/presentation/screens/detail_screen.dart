// lib/presentation/screens/detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_theme.dart';
import '../../domain/models/superhero_model.dart';
import '../blocs/detail/detail_bloc.dart';
import '../widgets/error_view.dart';
import '../widgets/hero_image_widget.dart';
import '../widgets/info_row.dart';
import '../widgets/stat_bar.dart';

class DetailScreen extends StatelessWidget {
  final int heroId;
  final String heroName;

  const DetailScreen({
    super.key,
    required this.heroId,
    required this.heroName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DetailBloc(
        repository: context.read(),
      )..add(LoadHeroDetail(heroId)),
      child: Scaffold(
        body: BlocBuilder<DetailBloc, DetailState>(
          builder: (context, state) {
            if (state is DetailLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppTheme.accent),
              );
            } else if (state is DetailLoaded) {
              final hero = state.hero;
              return DefaultTabController(
                length: 3,
                child: NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                        expandedHeight: 340,
                        floating: false,
                        pinned: true,
                        flexibleSpace: FlexibleSpaceBar(
                          title: Text(
                            hero.name.toUpperCase(),
                            style: AppTheme.displayLarge.copyWith(fontSize: 18),
                          ),
                          background: Stack(
                            fit: StackFit.expand,
                            children: [
                              HeroNetworkImage(url: hero.image.url),
                              const DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [AppTheme.background, Colors.transparent],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: _SliverAppBarDelegate(
                          const TabBar(
                            tabs: [
                              Tab(text: 'Stats'),
                              Tab(text: 'Biography'),
                              Tab(text: 'Appearance'),
                            ],
                            labelColor: AppTheme.gold,
                            unselectedLabelColor: AppTheme.textSecondary,
                            indicatorColor: AppTheme.gold,
                            indicatorWeight: 3,
                          ),
                        ),
                      ),
                    ];
                  },
                  body: TabBarView(
                    children: [
                      _buildStatsTab(hero.powerstats),
                      _buildBiographyTab(hero.biography, hero.work),
                      _buildAppearanceTab(hero.appearance),
                    ],
                  ),
                ),
              );
            } else if (state is DetailError) {
              return Scaffold(
                appBar: AppBar(title: Text(heroName)),
                body: ErrorView(
                  message: state.message,
                  onRetry: () {
                    context.read<DetailBloc>().add(RetryHeroDetail(state.heroId));
                  },
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildStatsTab(Powerstats stats) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SectionCard(
          title: 'Powerstats Highlight',
          children: [
            StatBar(label: 'Intelligence', value: Powerstats.parseStat(stats.intelligence), color: Colors.blue),
            StatBar(label: 'Strength', value: Powerstats.parseStat(stats.strength), color: Colors.red),
            StatBar(label: 'Speed', value: Powerstats.parseStat(stats.speed), color: Colors.amber),
            StatBar(label: 'Durability', value: Powerstats.parseStat(stats.durability), color: Colors.orange),
            StatBar(label: 'Power', value: Powerstats.parseStat(stats.power), color: Colors.purple),
            StatBar(label: 'Combat', value: Powerstats.parseStat(stats.combat), color: Colors.green),
          ],
        ),
      ],
    );
  }

  Widget _buildBiographyTab(Biography bio, Work work) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SectionCard(
          title: 'Identity & Origins',
          children: [
            InfoRow(label: 'Full Name', value: bio.fullName),
            InfoRow(label: 'Alter Egos', value: bio.alterEgos),
            InfoRow(label: 'Place of Birth', value: bio.placeOfBirth),
            InfoRow(label: 'First Appearance', value: bio.firstAppearance),
            InfoRow(label: 'Publisher', value: bio.publisher),
            InfoRow(label: 'Alignment', value: bio.alignment),
          ],
        ),
        SectionCard(
          title: 'Work & Activities',
          children: [
            InfoRow(label: 'Occupation', value: work.occupation),
            InfoRow(label: 'Base of Ops', value: work.base),
          ],
        ),
      ],
    );
  }

  Widget _buildAppearanceTab(Appearance app) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SectionCard(
          title: 'Physical Attributes',
          children: [
            InfoRow(label: 'Gender', value: app.gender),
            InfoRow(label: 'Race', value: app.race),
            InfoRow(label: 'Height', value: app.height.isNotEmpty ? app.height.join(' / ') : '-'),
            InfoRow(label: 'Weight', value: app.weight.isNotEmpty ? app.weight.join(' / ') : '-'),
            InfoRow(label: 'Eye Color', value: app.eyeColor),
            InfoRow(label: 'Hair Color', value: app.hairColor),
          ],
        ),
      ],
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;
  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppTheme.background,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) => false;
}