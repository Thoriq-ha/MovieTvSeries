import 'package:dartz/dartz.dart';
import 'package:movietvseries/common/failure.dart';
import 'package:movietvseries/domain/entities/movie.dart';
import 'package:movietvseries/domain/repositories/movie_repository.dart';

class SearchMovies {
  final MovieRepository repository;

  SearchMovies(this.repository);

  Future<Either<Failure, List<Movie>>> execute(String query) {
    return repository.searchMovies(query);
  }
}
