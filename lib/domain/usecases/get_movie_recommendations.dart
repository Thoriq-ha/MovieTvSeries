import 'package:dartz/dartz.dart';
import 'package:movietvseries/domain/entities/movie.dart';
import 'package:movietvseries/domain/repositories/movie_repository.dart';
import 'package:movietvseries/common/failure.dart';

class GetMovieRecommendations {
  final MovieRepository repository;

  GetMovieRecommendations(this.repository);

  Future<Either<Failure, List<Movie>>> execute(id) {
    return repository.getMovieRecommendations(id);
  }
}
