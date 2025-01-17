import 'package:dartz/dartz.dart';
import 'package:movietvseries/domain/entities/tv.dart';
import 'package:movietvseries/common/failure.dart';
import 'package:movietvseries/domain/repositories/tv_repository.dart';

class GetPopularTv {
  final TvRepository repository;

  GetPopularTv(this.repository);

  Future<Either<Failure, List<Tv>>> execute() {
    return repository.getPopularTv();
  }
}
