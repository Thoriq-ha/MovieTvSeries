import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movietvseries/common/failure.dart';
import 'package:movietvseries/domain/entities/tv.dart';
import 'package:movietvseries/domain/entities/tv_detail.dart';
import 'package:movietvseries/domain/usecases/get_watchlist_status_tv.dart';
import 'package:movietvseries/domain/usecases/get_watchlist_tv.dart';
import 'package:movietvseries/domain/usecases/remove_watchlist_tv.dart';
import 'package:movietvseries/domain/usecases/save_watchlist_tv.dart';

abstract class WatchListTVEvent extends Equatable {}

class FetchWatchListTVStatus extends WatchListTVEvent {
  final int id;
  FetchWatchListTVStatus(this.id);

  @override
  List<Object?> get props => [id];
}

class FetchWatchListTVs extends WatchListTVEvent {
  @override
  List<Object?> get props => [];
}

class UpdateWatchListTVStatus extends WatchListTVEvent {
  final TvDetail tvDetail;
  final bool isAddedToWatchlist;

  UpdateWatchListTVStatus(this.tvDetail, this.isAddedToWatchlist);

  @override
  List<Object?> get props => [tvDetail, isAddedToWatchlist];
}

abstract class WatchListTVState extends Equatable {}

class WatchListTVIsLoading extends WatchListTVState {
  @override
  List<Object> get props => [];
}

class WatchListTVStatusIsLoaded extends WatchListTVState {
  final bool isAddedToWatchlist;
  WatchListTVStatusIsLoaded(this.isAddedToWatchlist);

  @override
  List<Object> get props => [isAddedToWatchlist];
}

class WatchListTVIsLoaded extends WatchListTVState {
  final List<Tv> tvs;
  WatchListTVIsLoaded(this.tvs);

  @override
  List<Object> get props => [tvs];
}

class WatchListTVIsError extends WatchListTVState {
  final String message;

  WatchListTVIsError(this.message);

  @override
  List<Object> get props => [message];
}

class WatchListTVIsSaved extends WatchListTVState {
  final String message;

  WatchListTVIsSaved(this.message);

  @override
  List<Object> get props => [message];
}

class WatchListTVBloc extends Bloc<WatchListTVEvent, WatchListTVState> {
  final GetWatchlistTv getWatchlistTVs;
  final GetWatchListStatusTv getWatchListStatusTV;
  final SaveWatchlistTv saveWatchlistTV;
  final RemoveWatchlistTv removeWatchlistTV;

  WatchListTVBloc(this.getWatchlistTVs, this.getWatchListStatusTV,
      this.saveWatchlistTV, this.removeWatchlistTV)
      : super(WatchListTVIsLoading()) {
    on<FetchWatchListTVs>((event, emit) async {
      emit(WatchListTVIsLoading());
      final result = await getWatchlistTVs.execute();
      result.fold(
        (failure) => emit(WatchListTVIsError(failure.message)),
        (tvs) => emit(WatchListTVIsLoaded(tvs)),
      );
    });
    on<FetchWatchListTVStatus>((event, emit) async {
      emit(WatchListTVIsLoading());
      final resultDetail = await getWatchListStatusTV.execute(event.id);
      emit(WatchListTVStatusIsLoaded(resultDetail));
    });
    on<UpdateWatchListTVStatus>((event, emit) async {
      emit(WatchListTVIsLoading());
      Either<Failure, String> result;
      if (event.isAddedToWatchlist) {
        result = await removeWatchlistTV.execute(event.tvDetail);
      } else {
        result = await saveWatchlistTV.execute(event.tvDetail);
      }

      result.fold(
        (failure) => emit(WatchListTVIsError(failure.message)),
        (message) => emit(WatchListTVIsSaved(message)),
      );
    });
  }
}
