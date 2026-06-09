// lib/presentation/blocs/search/search_event.dart

part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

/// Fired whenever the user types in the search bar.
class SearchQueryChanged extends SearchEvent {
  final String query;
  const SearchQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}

/// Fired on app start to load a default hero list.
class SearchInitialLoad extends SearchEvent {
  const SearchInitialLoad();
}

/// Fired when user taps the Retry button.
class SearchRetry extends SearchEvent {
  final String query;
  const SearchRetry(this.query);

  @override
  List<Object?> get props => [query];
}
