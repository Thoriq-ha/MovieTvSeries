import 'package:movietvseries/data/datasources/db/database_helper.dart';
import 'package:movietvseries/data/datasources/external/ssl_pinning.dart';
import 'package:movietvseries/data/datasources/movie_local_data_source.dart';
import 'package:movietvseries/data/datasources/movie_remote_data_source.dart';
import 'package:movietvseries/data/datasources/tv_local_data_source.dart';
import 'package:movietvseries/data/datasources/tv_remote_data_source.dart';
import 'package:movietvseries/data/repositories/movie_repository_impl.dart';
import 'package:movietvseries/data/repositories/tv_repository_impl.dart';
import 'package:movietvseries/domain/repositories/movie_repository.dart';
import 'package:movietvseries/domain/repositories/tv_repository.dart';
import 'package:movietvseries/domain/usecases/get_movie_detail.dart';
import 'package:movietvseries/domain/usecases/get_movie_recommendations.dart';
import 'package:movietvseries/domain/usecases/get_now_playing_movies.dart';
import 'package:movietvseries/domain/usecases/get_now_playing_tv.dart';
import 'package:movietvseries/domain/usecases/get_popular_movies.dart';
import 'package:movietvseries/domain/usecases/get_popular_tv.dart';
import 'package:movietvseries/domain/usecases/get_top_rated_movies.dart';
import 'package:movietvseries/domain/usecases/get_top_rated_tv.dart';
import 'package:movietvseries/domain/usecases/get_tv_detail.dart';
import 'package:movietvseries/domain/usecases/get_tv_recommendations.dart';
import 'package:movietvseries/domain/usecases/get_watchlist_movies.dart';
import 'package:movietvseries/domain/usecases/get_watchlist_status_movie.dart';
import 'package:movietvseries/domain/usecases/get_watchlist_status_tv.dart';
import 'package:movietvseries/domain/usecases/get_watchlist_tv.dart';
import 'package:movietvseries/domain/usecases/remove_watchlist_movie.dart';
import 'package:movietvseries/domain/usecases/remove_watchlist_tv.dart';
import 'package:movietvseries/domain/usecases/save_watchlist_movie.dart';
import 'package:movietvseries/domain/usecases/save_watchlist_tv.dart';
import 'package:movietvseries/domain/usecases/search_movies.dart';
import 'package:movietvseries/domain/usecases/search_tv.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';
import 'package:movietvseries/presentation/bloc/movie/detail_movie_bloc.dart';
import 'package:movietvseries/presentation/bloc/movie/now_playing_movie_bloc.dart';
import 'package:movietvseries/presentation/bloc/movie/popular_movie_bloc.dart';
import 'package:movietvseries/presentation/bloc/movie/recomendations_movie_bloc.dart';
import 'package:movietvseries/presentation/bloc/movie/search_movie_bloc.dart';
import 'package:movietvseries/presentation/bloc/movie/top_rated_movie_bloc.dart';
import 'package:movietvseries/presentation/bloc/tv/detail_tv_bloc.dart';
import 'package:movietvseries/presentation/bloc/tv/now_playing_tv_bloc.dart';
import 'package:movietvseries/presentation/bloc/tv/popular_tv_bloc.dart';
import 'package:movietvseries/presentation/bloc/tv/recomendations_tv_bloc.dart';
import 'package:movietvseries/presentation/bloc/tv/search_tv_bloc.dart';
import 'package:movietvseries/presentation/bloc/tv/top_rated_tv_bloc.dart';
import 'package:movietvseries/presentation/bloc/watchlist/watchlist_movie_bloc.dart';
import 'package:movietvseries/presentation/bloc/watchlist/watchlist_tv_bloc.dart';

final locator = GetIt.instance;

Future<void> init() async {
  // external
  final client = await SslPinning.createClient();
  locator.registerLazySingleton<http.Client>(() => client);

  // BLOC
  locator.registerLazySingleton(
    () => DetailMovieBloc(locator()),
  );
  locator.registerLazySingleton(
    () => SearchMovieBloc(locator()),
  );
  locator.registerLazySingleton(
    () => NowPlayingMovieBloc(locator()),
  );
  locator.registerLazySingleton(
    () => PopularMoviesBloc(locator()),
  );
  locator.registerLazySingleton(
    () => TopRatedMoviesBloc(locator()),
  );
  locator.registerLazySingleton(
    () => WatchListMovieBloc(locator(), locator(), locator(), locator()),
  );
  locator.registerLazySingleton(
    () => MovieRecomendationsBloc(locator()),
  );

  locator.registerLazySingleton(
    () => DetailTVBloc(locator()),
  );
  locator.registerLazySingleton(
    () => SearchTVBloc(locator()),
  );
  locator.registerLazySingleton(
    () => NowPlayingTVBloc(locator()),
  );
  locator.registerLazySingleton(
    () => PopularTVBloc(locator()),
  );
  locator.registerLazySingleton(
    () => TopRatedTVBloc(locator()),
  );
  locator.registerLazySingleton(
    () => WatchListTVBloc(locator(), locator(), locator(), locator()),
  );
  locator.registerLazySingleton(
    () => TVRecomendationsBloc(locator()),
  );

  // use case
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => GetWatchListStatusMovie(locator()));
  locator.registerLazySingleton(() => SaveWatchlistMovie(locator()));
  locator.registerLazySingleton(() => RemoveWatchlistMovie(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));

  locator.registerLazySingleton(() => GetTvRecommendations(locator()));
  locator.registerLazySingleton(() => GetTopRatedTv(locator()));
  locator.registerLazySingleton(() => GetNowPlayingTv(locator()));
  locator.registerLazySingleton(() => GetPopularTv(locator()));
  locator.registerLazySingleton(() => GetTvDetail(locator()));
  locator.registerLazySingleton(() => SearchTv(locator()));
  locator.registerLazySingleton(() => GetWatchlistTv(locator()));
  locator.registerLazySingleton(() => GetWatchListStatusTv(locator()));
  locator.registerLazySingleton(() => SaveWatchlistTv(locator()));
  locator.registerLazySingleton(() => RemoveWatchlistTv(locator()));

  // repository
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );
  locator.registerLazySingleton<TvRepository>(
    () => TvRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  // data sources
  locator.registerLazySingleton<MovieRemoteDataSource>(
      () => MovieRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<MovieLocalDataSource>(
      () => MovieLocalDataSourceImpl(databaseHelper: locator()));
  locator.registerLazySingleton<TvRemoteDataSource>(
      () => TvRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<TvLocalDataSource>(
      () => TvLocalDataSourceImpl(databaseHelper: locator()));

  // helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());
}
