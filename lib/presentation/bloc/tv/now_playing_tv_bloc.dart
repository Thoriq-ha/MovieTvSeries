import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movietvseries/domain/usecases/get_now_playing_tv.dart';

import '../../../domain/entities/tv.dart';

abstract class NowPlayingTVEvent extends Equatable {}

class FetchNowPlayingTV extends NowPlayingTVEvent {
  @override
  List<Object?> get props => [];
}

abstract class NowPlayingTVState extends Equatable {}

class NowPlayingTVIsLoading extends NowPlayingTVState {
  @override
  List<Object> get props => [];
}

class NowPlayingTVIsLoaded extends NowPlayingTVState {
  final List<Tv> tvs;

  NowPlayingTVIsLoaded(this.tvs);

  @override
  List<Object> get props => [];
}

class NowPlayingTVIsError extends NowPlayingTVState {
  final String message;

  NowPlayingTVIsError(this.message);

  @override
  List<Object> get props => [];
}

class NowPlayingTVBloc extends Bloc<NowPlayingTVEvent, NowPlayingTVState> {
  final GetNowPlayingTv getNowPlayingTVs;

  NowPlayingTVBloc(this.getNowPlayingTVs) : super(NowPlayingTVIsLoading()) {
    on<FetchNowPlayingTV>((event, emit) async {
      emit(NowPlayingTVIsLoading());
      final result = await getNowPlayingTVs.execute();
      result.fold(
        (failure) => emit(NowPlayingTVIsError(failure.message)),
        (tVsData) => emit(NowPlayingTVIsLoaded(tVsData)),
      );
    });
  }
}
