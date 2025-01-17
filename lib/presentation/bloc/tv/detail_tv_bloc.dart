import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movietvseries/domain/entities/tv_detail.dart';
import 'package:movietvseries/domain/usecases/get_tv_detail.dart';

abstract class DetailTVEvent extends Equatable {}

class FetchDetailTV extends DetailTVEvent {
  final int id;

  FetchDetailTV(this.id);

  @override
  List<Object?> get props => [id];
}

abstract class DetailTVState extends Equatable {}

class DetailTVIsLoading extends DetailTVState {
  @override
  List<Object> get props => [];
}

class DetailTVIsLoaded extends DetailTVState {
  final TvDetail tv;

  DetailTVIsLoaded(this.tv);

  @override
  List<Object> get props => [];
}

class DetailTVIsError extends DetailTVState {
  final String message;

  DetailTVIsError(this.message);

  @override
  List<Object> get props => [];
}

class DetailTVBloc extends Bloc<DetailTVEvent, DetailTVState> {
  final GetTvDetail getDetailTV;

  DetailTVBloc(this.getDetailTV) : super(DetailTVIsLoading()) {
    on<FetchDetailTV>((event, emit) async {
      emit(DetailTVIsLoading());
      final resultDetail = await getDetailTV.execute(event.id);
      resultDetail.fold((failure) => emit(DetailTVIsError(failure.message)),
          (tvData) => emit(DetailTVIsLoaded(tvData)));
    });
  }
}
