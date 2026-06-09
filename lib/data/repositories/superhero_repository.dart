// lib/data/repositories/superhero_repository.dart

import 'package:dio/dio.dart';
import '../../core/error/failures.dart';
import '../../core/network/network_info.dart';
import '../../domain/models/superhero_model.dart';
import '../local/hive_service.dart';
import '../remote/superhero_remote_data_source.dart';

class Either<L, R> {
  final L? left;
  final R? right;
  bool get isLeft => left != null;
  bool get isRight => right != null;
  const Either.left(this.left) : right = null;
  const Either.right(this.right) : left = null;
}

class SuperheroRepository {
  final SuperheroRemoteDataSource _remote;
  final HiveService _local;
  final NetworkInfo _network;

  SuperheroRepository({
    required SuperheroRemoteDataSource remote,
    required HiveService local,
    required NetworkInfo network,
  })  : _remote = remote,
        _local = local,
        _network = network;

  // ── Search ────────────────────────────────────────────────
  Future<Either<Failure, List<SuperheroModel>>> searchHeroes(
      String query) async {
    if (await _network.isConnected) {
      try {
        final heroes = await _remote.searchHeroes(query);
        if (heroes.isNotEmpty) {
          await _local.cacheSearchResults(query, heroes);
        }
        return Either.right(heroes);
      } on DioException catch (e) {
        return Either.left(_mapDioError(e));
      } catch (e) {
        return Either.left(ServerFailure(e.toString()));
      }
    } else {
      // ── Offline fallback ──
      final cached = _local.getCachedSearch(query);
      if (cached != null) return Either.right(cached);
      return const Either.left(NetworkFailure());
    }
  }

  // ── Detail ────────────────────────────────────────────────
  Future<Either<Failure, SuperheroModel>> getHeroDetail(int id) async {
    if (await _network.isConnected) {
      try {
        final hero = await _remote.getHeroDetail(id);
        await _local.cacheHeroDetail(hero);
        return Either.right(hero);
      } on DioException catch (e) {
        return Either.left(_mapDioError(e));
      } catch (e) {
        return Either.left(ServerFailure(e.toString()));
      }
    } else {
      final cached = _local.getCachedDetail(id);
      if (cached != null) return Either.right(cached);
      return const Either.left(NetworkFailure());
    }
  }

  // ── Helper ────────────────────────────────────────────────
  Failure _mapDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return const ServerFailure('Request timed out. Check your connection.');
      case DioExceptionType.connectionError:
        return const NetworkFailure();
      default:
        final code = e.response?.statusCode;
        if (code == 401) return const ServerFailure('Invalid API token.');
        if (code == 404) return const NotFoundFailure();
        return ServerFailure(e.message ?? 'Unknown server error.');
    }
  }
}
