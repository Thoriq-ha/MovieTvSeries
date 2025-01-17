import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movietvseries/domain/usecases/get_movie_recommendations.dart';

import '../../../domain/entities/movie.dart';

abstract class MovieRecomendationsEvent extends Equatable {}

class FetchMovieRecomendations extends MovieRecomendationsEvent {
  final int id;

  FetchMovieRecomendations(this.id);

  @override
  List<Object> get props => [id];
}

abstract class MovieRecomendationsState extends Equatable {}

class MovieRecomendationsIsLoading extends MovieRecomendationsState {
  @override
  List<Object> get props => [];
}

class MovieRecomendationsIsLoaded extends MovieRecomendationsState {
  final List<Movie> movies;

  MovieRecomendationsIsLoaded(this.movies);

  @override
  List<Object> get props => [];
}

class MovieRecomendationsIsError extends MovieRecomendationsState {
  final String message;

  MovieRecomendationsIsError(this.message);

  @override
  List<Object> get props => [];
}

class MovieRecomendationsBloc
    extends Bloc<MovieRecomendationsEvent, MovieRecomendationsState> {
  final GetMovieRecommendations getMovieRecommendations;

  MovieRecomendationsBloc(this.getMovieRecommendations)
      : super(MovieRecomendationsIsLoading()) {
    on<FetchMovieRecomendations>((event, emit) async {
      emit(MovieRecomendationsIsLoading());
      final result = await getMovieRecommendations.execute(event.id);
      result.fold(
        (failure) => emit(MovieRecomendationsIsError(failure.message)),
        (moviesData) => emit(MovieRecomendationsIsLoaded(moviesData)),
      );
    });
  }
}
