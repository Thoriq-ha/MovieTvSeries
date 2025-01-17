import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movietvseries/domain/usecases/get_popular_tv.dart';

import '../../../domain/entities/tv.dart';

abstract class PopularTVEvent extends Equatable {}

class FetchPopularTV extends PopularTVEvent {
  @override
  List<Object?> get props => [];
}

abstract class PopularTVState extends Equatable {}

class PopularTVIsLoading extends PopularTVState {
  @override
  List<Object> get props => [];
}

class PopularTVIsLoaded extends PopularTVState {
  final List<Tv> tvs;

  PopularTVIsLoaded(this.tvs);

  @override
  List<Object> get props => [];
}

class PopularTVIsError extends PopularTVState {
  final String message;

  PopularTVIsError(this.message);

  @override
  List<Object> get props => [];
}

class PopularTVBloc extends Bloc<PopularTVEvent, PopularTVState> {
  final GetPopularTv getPopularTVs;

  PopularTVBloc(this.getPopularTVs) : super(PopularTVIsLoading()) {
    on<FetchPopularTV>((event, emit) async {
      emit(PopularTVIsLoading());
      final result = await getPopularTVs.execute();
      result.fold(
        (failure) => emit(PopularTVIsError(failure.message)),
        (tVsData) => emit(PopularTVIsLoaded(tVsData)),
      );
    });
  }
}
