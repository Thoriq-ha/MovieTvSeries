import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movietvseries/common/failure.dart';
import 'package:movietvseries/domain/entities/movie.dart';
import 'package:movietvseries/domain/entities/movie_detail.dart';
import 'package:movietvseries/domain/usecases/get_watchlist_movies.dart';
import 'package:movietvseries/domain/usecases/get_watchlist_status_movie.dart';
import 'package:movietvseries/domain/usecases/remove_watchlist_movie.dart';
import 'package:movietvseries/domain/usecases/save_watchlist_movie.dart';

abstract class WatchListMovieEvent extends Equatable {}

class FetchWatchListMovieStatus extends WatchListMovieEvent {
  final int id;
  FetchWatchListMovieStatus(this.id);

  @override
  List<Object?> get props => [id];
}

class FetchWatchListMovies extends WatchListMovieEvent {
  @override
  List<Object?> get props => [];
}

class UpdateWatchListMovieStatus extends WatchListMovieEvent {
  final MovieDetail movieDetail;
  final bool isAddedToWatchlist;

  UpdateWatchListMovieStatus(this.movieDetail, this.isAddedToWatchlist);

  @override
  List<Object?> get props => [movieDetail, isAddedToWatchlist];
}

abstract class WatchListMovieState extends Equatable {}

class WatchListMovieIsLoading extends WatchListMovieState {
  @override
  List<Object> get props => [];
}

class WatchListMovieStatusIsLoaded extends WatchListMovieState {
  final bool isAddedToWatchlist;
  WatchListMovieStatusIsLoaded(this.isAddedToWatchlist);

  @override
  List<Object> get props => [isAddedToWatchlist];
}

class WatchListMovieIsLoaded extends WatchListMovieState {
  final List<Movie> movies;
  WatchListMovieIsLoaded(this.movies);

  @override
  List<Object> get props => [movies];
}

class WatchListMovieIsError extends WatchListMovieState {
  final String message;

  WatchListMovieIsError(this.message);

  @override
  List<Object> get props => [message];
}

class WatchListMovieIsSaved extends WatchListMovieState {
  final String message;

  WatchListMovieIsSaved(this.message);

  @override
  List<Object> get props => [message];
}

class WatchListMovieBloc
    extends Bloc<WatchListMovieEvent, WatchListMovieState> {
  final GetWatchlistMovies getWatchlistMovies;
  final GetWatchListStatusMovie getWatchListStatusMovie;
  final SaveWatchlistMovie saveWatchlistMovie;
  final RemoveWatchlistMovie removeWatchlistMovie;

  WatchListMovieBloc(this.getWatchlistMovies, this.getWatchListStatusMovie,
      this.saveWatchlistMovie, this.removeWatchlistMovie)
      : super(WatchListMovieIsLoading()) {
    on<FetchWatchListMovies>((event, emit) async {
      emit(WatchListMovieIsLoading());
      final result = await getWatchlistMovies.execute();
      result.fold(
        (failure) => emit(WatchListMovieIsError(failure.message)),
        (movies) => emit(WatchListMovieIsLoaded(movies)),
      );
    });
    on<FetchWatchListMovieStatus>((event, emit) async {
      emit(WatchListMovieIsLoading());
      final resultDetail = await getWatchListStatusMovie.execute(event.id);
      emit(WatchListMovieStatusIsLoaded(resultDetail));
    });
    on<UpdateWatchListMovieStatus>((event, emit) async {
      emit(WatchListMovieIsLoading());
      Either<Failure, String> result;
      if (event.isAddedToWatchlist) {
        result = await removeWatchlistMovie.execute(event.movieDetail);
      } else {
        result = await saveWatchlistMovie.execute(event.movieDetail);
      }

      result.fold(
        (failure) => emit(WatchListMovieIsError(failure.message)),
        (message) => emit(WatchListMovieIsSaved(message)),
      );
    });
  }
}
