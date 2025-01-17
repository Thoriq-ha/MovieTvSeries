import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movietvseries/domain/entities/tv.dart';
import 'package:movietvseries/domain/usecases/search_tv.dart';

abstract class SearchTVEvent extends Equatable {}

class FetchSearchTV extends SearchTVEvent {
  final String? query;

  FetchSearchTV({this.query});

  @override
  List<Object?> get props => [query];
}

abstract class SearchTVState extends Equatable {}

class SearchTVIsLoading extends SearchTVState {
  @override
  List<Object> get props => [];
}

class SearchTVIsEmpty extends SearchTVState {
  final String message;

  SearchTVIsEmpty(this.message);

  @override
  List<Object> get props => [];
}

class SearchTVIsLoaded extends SearchTVState {
  final List<Tv> tvs;

  SearchTVIsLoaded(this.tvs);

  @override
  List<Object> get props => [];
}

class SearchTVIsError extends SearchTVState {
  final String message;

  SearchTVIsError(this.message);

  @override
  List<Object> get props => [];
}

class SearchTVBloc extends Bloc<SearchTVEvent, SearchTVState> {
  final SearchTv getSearchTVs;

  SearchTVBloc(this.getSearchTVs) : super(SearchTVIsLoading()) {
    on<FetchSearchTV>((event, emit) async {
      emit(SearchTVIsLoading());
      if (event.query == null) {
        emit(SearchTVIsEmpty('Empty Data'));
        return;
      }
      final result = await getSearchTVs.execute(event.query!);
      result.fold((failure) => emit(SearchTVIsError(failure.message)),
          (tvsData) {
        if (tvsData.isEmpty) {
          emit(SearchTVIsEmpty('Empty Data'));
          return;
        }
        emit(SearchTVIsLoaded(tvsData));
      });
    });
  }
}
