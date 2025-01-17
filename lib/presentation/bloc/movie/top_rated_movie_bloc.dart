import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movietvseries/domain/entities/movie.dart';
import 'package:movietvseries/domain/usecases/get_top_rated_movies.dart';

abstract class TopRatedMoviesEvent extends Equatable {}

class FetchTopRatedMovies extends TopRatedMoviesEvent {
  @override
  List<Object> get props => [];
}

abstract class TopRatedMoviesState extends Equatable {}

class TopRatedMovieIsLoading extends TopRatedMoviesState {
  @override
  List<Object> get props => [];
}

class TopRatedMovieIsLoaded extends TopRatedMoviesState {
  final List<Movie> movies;

  TopRatedMovieIsLoaded(this.movies);

  @override
  List<Object> get props => [];
}

class TopRatedMovieIsError extends TopRatedMoviesState {
  final String message;

  TopRatedMovieIsError(this.message);

  @override
  List<Object> get props => [];
}

class TopRatedMoviesBloc
    extends Bloc<TopRatedMoviesEvent, TopRatedMoviesState> {
  final GetTopRatedMovies getTopRatedMovies;

  TopRatedMoviesBloc(this.getTopRatedMovies) : super(TopRatedMovieIsLoading()) {
    on<FetchTopRatedMovies>((event, emit) async {
      emit(TopRatedMovieIsLoading());
      final result = await getTopRatedMovies.execute();
      result.fold(
        (failure) => emit(TopRatedMovieIsError(failure.message)),
        (moviesData) => emit(TopRatedMovieIsLoaded(moviesData)),
      );
    });
  }
}
