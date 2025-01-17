import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movietvseries/domain/entities/movie_detail.dart';
import 'package:movietvseries/domain/usecases/get_movie_detail.dart';

abstract class DetailMovieEvent extends Equatable {}

class FetchDetailMovie extends DetailMovieEvent {
  final int id;

  FetchDetailMovie(this.id);

  @override
  List<Object?> get props => [id];
}

abstract class DetailMovieState extends Equatable {}

class DetailMovieIsLoading extends DetailMovieState {
  @override
  List<Object> get props => [];
}

class DetailMovieIsLoaded extends DetailMovieState {
  final MovieDetail movie;

  DetailMovieIsLoaded(this.movie);

  @override
  List<Object> get props => [];
}

class DetailMovieIsError extends DetailMovieState {
  final String message;

  DetailMovieIsError(this.message);

  @override
  List<Object> get props => [];
}

class DetailMovieBloc extends Bloc<DetailMovieEvent, DetailMovieState> {
  final GetMovieDetail getDetailMovie;

  DetailMovieBloc(this.getDetailMovie) : super(DetailMovieIsLoading()) {
    on<FetchDetailMovie>((event, emit) async {
      emit(DetailMovieIsLoading());
      final resultDetail = await getDetailMovie.execute(event.id);
      resultDetail.fold((failure) => emit(DetailMovieIsError(failure.message)),
          (movieData) => emit(DetailMovieIsLoaded(movieData)));
    });
  }
}
