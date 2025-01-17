import 'package:dartz/dartz.dart';
import 'package:movietvseries/domain/entities/tv.dart';
import 'package:movietvseries/common/failure.dart';
import 'package:movietvseries/domain/repositories/tv_repository.dart';

class GetTopRatedTv {
  final TvRepository repository;

  GetTopRatedTv(this.repository);

  Future<Either<Failure, List<Tv>>> execute() {
    return repository.getTopRatedTv();
  }
}
