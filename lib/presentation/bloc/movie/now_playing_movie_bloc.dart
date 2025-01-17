import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movietvseries/domain/usecases/get_now_playing_movies.dart';

import '../../../domain/entities/movie.dart';

abstract class NowPlayingMovieEvent extends Equatable {}

class FetchNowPlayingMovie extends NowPlayingMovieEvent {
  @override
  List<Object> get props => [];
}

abstract class NowPlayingMovieState extends Equatable {}

class NowPlayingMovieIsLoading extends NowPlayingMovieState {
  @override
  List<Object> get props => [];
}

class NowPlayingMovieIsLoaded extends NowPlayingMovieState {
  final List<Movie> movies;

  NowPlayingMovieIsLoaded(this.movies);

  @override
  List<Object> get props => [];
}

class NowPlayingMovieIsError extends NowPlayingMovieState {
  final String message;

  NowPlayingMovieIsError(this.message);

  @override
  List<Object> get props => [];
}

class NowPlayingMovieBloc
    extends Bloc<NowPlayingMovieEvent, NowPlayingMovieState> {
  final GetNowPlayingMovies getNowPlayingMovies;

  NowPlayingMovieBloc(this.getNowPlayingMovies)
      : super(NowPlayingMovieIsLoading()) {
    on<FetchNowPlayingMovie>((event, emit) async {
      emit(NowPlayingMovieIsLoading());
      final result = await getNowPlayingMovies.execute();
      result.fold(
        (failure) => emit(NowPlayingMovieIsError(failure.message)),
        (moviesData) => emit(NowPlayingMovieIsLoaded(moviesData)),
      );
    });
  }
}
