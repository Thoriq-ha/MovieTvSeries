import 'package:dartz/dartz.dart';
import 'package:movietvseries/common/failure.dart';
import 'package:movietvseries/domain/entities/movie.dart';
import 'package:movietvseries/domain/repositories/movie_repository.dart';

class GetPopularMovies {
  final MovieRepository repository;

  GetPopularMovies(this.repository);

  Future<Either<Failure, List<Movie>>> execute() {
    return repository.getPopularMovies();
  }
}
