// lib/presentation/blocs/detail/detail_bloc.dart

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/superhero_repository.dart';
import '../../../domain/models/superhero_model.dart';

part 'detail_event.dart';
part 'detail_state.dart';

class DetailBloc extends Bloc<DetailEvent, DetailState> {
  final SuperheroRepository _repository;

  DetailBloc({required SuperheroRepository repository})
      : _repository = repository,
        super(const DetailInitial()) {
    on<LoadHeroDetail>(_onLoad);
    on<RetryHeroDetail>(_onRetry);
  }

  Future<void> _onLoad(
      LoadHeroDetail event, Emitter<DetailState> emit) async {
    emit(const DetailLoading());
    await _fetch(event.id, emit);
  }

  Future<void> _onRetry(
      RetryHeroDetail event, Emitter<DetailState> emit) async {
    emit(const DetailLoading());
    await _fetch(event.id, emit);
  }

  Future<void> _fetch(int id, Emitter<DetailState> emit) async {
    final result = await _repository.getHeroDetail(id);
    if (result.isRight) {
      emit(DetailLoaded(hero: result.right!));
    } else {
      emit(DetailError(message: result.left!.message, heroId: id));
    }
  }
}
