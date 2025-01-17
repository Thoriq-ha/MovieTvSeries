import 'package:dartz/dartz.dart';
import 'package:movietvseries/domain/entities/movie.dart';
import 'package:movietvseries/domain/repositories/movie_repository.dart';
import 'package:movietvseries/common/failure.dart';

class GetWatchlistMovies {
  final MovieRepository _repository;

  GetWatchlistMovies(this._repository);

  Future<Either<Failure, List<Movie>>> execute() {
    return _repository.getWatchlistMovies();
  }
}
