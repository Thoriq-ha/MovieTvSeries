import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movietvseries/domain/usecases/get_top_rated_tv.dart';

import '../../../domain/entities/tv.dart';

abstract class TopRatedTVEvent extends Equatable {}

class FetchTopRatedTV extends TopRatedTVEvent {
  @override
  List<Object?> get props => [];
}

abstract class TopRatedTVState extends Equatable {}

class TopRatedTVIsLoading extends TopRatedTVState {
  @override
  List<Object> get props => [];
}

class TopRatedTVIsLoaded extends TopRatedTVState {
  final List<Tv> tvs;

  TopRatedTVIsLoaded(this.tvs);

  @override
  List<Object> get props => [];
}

class TopRatedTVIsError extends TopRatedTVState {
  final String message;

  TopRatedTVIsError(this.message);

  @override
  List<Object> get props => [];
}

class TopRatedTVBloc extends Bloc<TopRatedTVEvent, TopRatedTVState> {
  final GetTopRatedTv getTopRatedTVs;

  TopRatedTVBloc(this.getTopRatedTVs) : super(TopRatedTVIsLoading()) {
    on<FetchTopRatedTV>((event, emit) async {
      emit(TopRatedTVIsLoading());
      final result = await getTopRatedTVs.execute();
      result.fold(
        (failure) => emit(TopRatedTVIsError(failure.message)),
        (tVsData) => emit(TopRatedTVIsLoaded(tVsData)),
      );
    });
  }
}
