import 'package:dartz/dartz.dart';
import 'package:movietvseries/common/failure.dart';
import 'package:movietvseries/domain/entities/tv_detail.dart';
import 'package:movietvseries/domain/repositories/tv_repository.dart';

class RemoveWatchlistTv {
  final TvRepository repository;

  RemoveWatchlistTv(this.repository);

  Future<Either<Failure, String>> execute(TvDetail tv) {
    return repository.removeWatchlistTv(tv);
  }
}
