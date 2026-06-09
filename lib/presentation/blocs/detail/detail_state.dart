// lib/presentation/blocs/detail/detail_state.dart

part of 'detail_bloc.dart';

abstract class DetailState extends Equatable {
  const DetailState();
  @override
  List<Object?> get props => [];
}

class DetailInitial extends DetailState {
  const DetailInitial();
}

class DetailLoading extends DetailState {
  const DetailLoading();
}

class DetailLoaded extends DetailState {
  final SuperheroModel hero;
  const DetailLoaded({required this.hero});
  @override
  List<Object?> get props => [hero];
}

class DetailError extends DetailState {
  final String message;
  final int heroId;
  const DetailError({required this.message, required this.heroId});
  @override
  List<Object?> get props => [message, heroId];
}
