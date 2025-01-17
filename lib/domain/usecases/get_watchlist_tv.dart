import 'package:dartz/dartz.dart';
import 'package:movietvseries/domain/entities/tv.dart';
import 'package:movietvseries/common/failure.dart';
import 'package:movietvseries/domain/repositories/tv_repository.dart';

class GetWatchlistTv {
  final TvRepository _repository;

  GetWatchlistTv(this._repository);

  Future<Either<Failure, List<Tv>>> execute() {
    return _repository.getWatchlistTv();
  }
}
