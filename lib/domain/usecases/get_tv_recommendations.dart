import 'package:dartz/dartz.dart';
import 'package:movietvseries/domain/entities/tv.dart';
import 'package:movietvseries/common/failure.dart';
import 'package:movietvseries/domain/repositories/tv_repository.dart';

class GetTvRecommendations {
  final TvRepository repository;

  GetTvRecommendations(this.repository);

  Future<Either<Failure, List<Tv>>> execute(id) {
    return repository.getTvRecommendations(id);
  }
}
