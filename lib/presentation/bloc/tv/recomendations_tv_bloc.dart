import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movietvseries/domain/entities/tv.dart';
import 'package:movietvseries/domain/usecases/get_tv_recommendations.dart';

abstract class TVRecomendationsEvent extends Equatable {}

class FetchTVRecomendations extends TVRecomendationsEvent {
  final int id;

  FetchTVRecomendations(this.id);

  @override
  List<Object?> get props => [id];
}

abstract class TVRecomendationsState extends Equatable {}

class TVRecomendationsIsLoading extends TVRecomendationsState {
  @override
  List<Object> get props => [];
}

class TVRecomendationsIsLoaded extends TVRecomendationsState {
  final List<Tv> tvs;

  TVRecomendationsIsLoaded(this.tvs);

  @override
  List<Object> get props => [];
}

class TVRecomendationsIsError extends TVRecomendationsState {
  final String message;

  TVRecomendationsIsError(this.message);

  @override
  List<Object> get props => [];
}

class TVRecomendationsBloc
    extends Bloc<TVRecomendationsEvent, TVRecomendationsState> {
  final GetTvRecommendations getTVRecommendations;

  TVRecomendationsBloc(this.getTVRecommendations)
      : super(TVRecomendationsIsLoading()) {
    on<FetchTVRecomendations>((event, emit) async {
      emit(TVRecomendationsIsLoading());
      final result = await getTVRecommendations.execute(event.id);
      result.fold(
        (failure) => emit(TVRecomendationsIsError(failure.message)),
        (tvsData) => emit(TVRecomendationsIsLoaded(tvsData)),
      );
    });
  }
}
