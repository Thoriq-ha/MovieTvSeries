import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movietvseries/domain/usecases/search_movies.dart';

import '../../../domain/entities/movie.dart';

abstract class SearchMovieEvent extends Equatable {}

class FetchSearchMovie extends SearchMovieEvent {
  final String? query;

  FetchSearchMovie({this.query});

  @override
  List<Object?> get props => [query];
}

abstract class SearchMovieState extends Equatable {}

class SearchMovieIsLoading extends SearchMovieState {
  @override
  List<Object> get props => [];
}

class SearchMovieIsEmpty extends SearchMovieState {
  final String message;

  SearchMovieIsEmpty(this.message);

  @override
  List<Object> get props => [message];
}

class SearchMovieIsLoaded extends SearchMovieState {
  final List<Movie> movies;

  SearchMovieIsLoaded(this.movies);

  @override
  List<Object> get props => [movies];
}

class SearchMovieIsError extends SearchMovieState {
  final String message;

  SearchMovieIsError(this.message);

  @override
  List<Object> get props => [message];
}

class SearchMovieBloc extends Bloc<SearchMovieEvent, SearchMovieState> {
  final SearchMovies getSearchMovies;

  SearchMovieBloc(this.getSearchMovies) : super(SearchMovieIsLoading()) {
    on<FetchSearchMovie>((event, emit) async {
      emit(SearchMovieIsLoading());
      if (event.query == null) {
        emit(SearchMovieIsEmpty('Empty Data'));
        return;
      }
      final result = await getSearchMovies.execute(event.query!);
      result.fold((failure) => emit(SearchMovieIsError(failure.message)),
          (moviesData) {
        if (moviesData.isEmpty) {
          emit(SearchMovieIsEmpty('Empty Data'));
          return;
        }
        emit(SearchMovieIsLoaded(moviesData));
      });
    });
  }
}
