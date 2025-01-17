import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movietvseries/domain/usecases/get_popular_movies.dart';

import '../../../domain/entities/movie.dart';

abstract class PopularMoviesEvent extends Equatable {}

class FetchPopularMovies extends PopularMoviesEvent {
  @override
  List<Object> get props => [];
}

abstract class PopularMoviesState extends Equatable {}

class PopularMovieIsLoading extends PopularMoviesState {
  @override
  List<Object> get props => [];
}

class PopularMovieIsLoaded extends PopularMoviesState {
  final List<Movie> movies;

  PopularMovieIsLoaded(this.movies);

  @override
  List<Object> get props => [movies];
}

class PopularMovieIsError extends PopularMoviesState {
  final String message;

  PopularMovieIsError(this.message);

  @override
  List<Object> get props => [message];
}

class PopularMoviesBloc extends Bloc<PopularMoviesEvent, PopularMoviesState> {
  final GetPopularMovies getPopularMovies;

  PopularMoviesBloc(this.getPopularMovies) : super(PopularMovieIsLoading()) {
    on<FetchPopularMovies>((event, emit) async {
      emit(PopularMovieIsLoading());
      final result = await getPopularMovies.execute();
      result.fold(
        (failure) => emit(PopularMovieIsError(failure.message)),
        (moviesData) => emit(PopularMovieIsLoaded(moviesData)),
      );
    });
  }
}
