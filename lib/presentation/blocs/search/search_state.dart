// lib/presentation/blocs/search/search_state.dart

part of 'search_bloc.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {
  const SearchInitial();
}

class SearchLoading extends SearchState {
  const SearchLoading();
}

class SearchLoaded extends SearchState {
  final List<SuperheroModel> heroes;
  final bool isFromCache;

  const SearchLoaded({required this.heroes, this.isFromCache = false});

  @override
  List<Object?> get props => [heroes, isFromCache];
}

class SearchEmpty extends SearchState {
  final String query;
  const SearchEmpty(this.query);

  @override
  List<Object?> get props => [query];
}

class SearchError extends SearchState {
  final String message;
  final String lastQuery;

  const SearchError({required this.message, required this.lastQuery});

  @override
  List<Object?> get props => [message, lastQuery];
}
