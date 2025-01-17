import 'package:dartz/dartz.dart';
import 'package:movietvseries/domain/entities/movie.dart';
import 'package:movietvseries/domain/repositories/movie_repository.dart';
import 'package:movietvseries/common/failure.dart';

class GetNowPlayingMovies {
  final MovieRepository repository;

  GetNowPlayingMovies(this.repository);

  Future<Either<Failure, List<Movie>>> execute() {
    return repository.getNowPlayingMovies();
  }
}
