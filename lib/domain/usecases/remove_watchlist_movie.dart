import 'package:dartz/dartz.dart';
import 'package:movietvseries/common/failure.dart';
import 'package:movietvseries/domain/entities/movie_detail.dart';
import 'package:movietvseries/domain/repositories/movie_repository.dart';

class RemoveWatchlistMovie {
  final MovieRepository repository;

  RemoveWatchlistMovie(this.repository);

  Future<Either<Failure, String>> execute(MovieDetail movie) {
    return repository.removeWatchlist(movie);
  }
}
