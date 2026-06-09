// lib/presentation/blocs/search/search_bloc.dart

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/superhero_repository.dart';
import '../../../domain/models/superhero_model.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SuperheroRepository _repository;

  String _lastQuery = 'man';

  SearchBloc({required SuperheroRepository repository})
      : _repository = repository,
        super(const SearchInitial()) {
    on<SearchInitialLoad>(_onInitialLoad);
    on<SearchQueryChanged>(_onQueryChanged);
    on<SearchRetry>(_onRetry);
  }

  // ── Handlers ──────────────────────────────────────────────

  Future<void> _onInitialLoad(
      SearchInitialLoad event, Emitter<SearchState> emit) async {
    await _fetchHeroes('man', emit);
  }

  Future<void> _onQueryChanged(
      SearchQueryChanged event, Emitter<SearchState> emit) async {
    final query = event.query.trim();
    if (query.isEmpty) {
      await _fetchHeroes('man', emit);
      return;
    }
    await _fetchHeroes(query, emit);
  }

  Future<void> _onRetry(
      SearchRetry event, Emitter<SearchState> emit) async {
    await _fetchHeroes(event.query, emit);
  }

  // ── Core fetch ────────────────────────────────────────────
  Future<void> _fetchHeroes(
      String query, Emitter<SearchState> emit) async {
    _lastQuery = query;
    emit(const SearchLoading());

    final result = await _repository.searchHeroes(query);

    if (result.isRight) {
      final heroes = result.right!;
      if (heroes.isEmpty) {
        emit(SearchEmpty(query));
      } else {
        emit(SearchLoaded(heroes: heroes));
      }
    } else {
      final failure = result.left!;
      emit(SearchError(message: failure.message, lastQuery: query));
    }
  }

  String get lastQuery => _lastQuery;
}
