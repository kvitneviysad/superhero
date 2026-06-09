// lib/presentation/blocs/detail/detail_event.dart

part of 'detail_bloc.dart';

abstract class DetailEvent extends Equatable {
  const DetailEvent();
  @override
  List<Object?> get props => [];
}

class LoadHeroDetail extends DetailEvent {
  final int id;
  const LoadHeroDetail(this.id);
  @override
  List<Object?> get props => [id];
}

class RetryHeroDetail extends DetailEvent {
  final int id;
  const RetryHeroDetail(this.id);
  @override
  List<Object?> get props => [id];
}
