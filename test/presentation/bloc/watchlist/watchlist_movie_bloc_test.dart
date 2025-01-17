import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movietvseries/common/failure.dart';
import 'package:movietvseries/domain/usecases/get_watchlist_movies.dart';
import 'package:movietvseries/domain/usecases/get_watchlist_status_movie.dart';
import 'package:movietvseries/domain/usecases/remove_watchlist_movie.dart';
import 'package:movietvseries/domain/usecases/save_watchlist_movie.dart';
import 'package:movietvseries/presentation/bloc/watchlist/watchlist_movie_bloc.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'watchlist_movie_bloc_test.mocks.dart';

@GenerateMocks([
  GetWatchlistMovies,
  GetWatchListStatusMovie,
  SaveWatchlistMovie,
  RemoveWatchlistMovie
])
void main() {
  late MockGetWatchlistMovies mockGetWatchlistMovies;
  late MockGetWatchListStatusMovie mockGetWatchListStatusMovie;
  late MockSaveWatchlistMovie mockSaveWatchlistMovie;
  late MockRemoveWatchlistMovie mockRemoveWatchlistMovie;
  late WatchListMovieBloc bloc;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    mockGetWatchListStatusMovie = MockGetWatchListStatusMovie();
    mockSaveWatchlistMovie = MockSaveWatchlistMovie();
    mockRemoveWatchlistMovie = MockRemoveWatchlistMovie();
    bloc = WatchListMovieBloc(
      mockGetWatchlistMovies,
      mockGetWatchListStatusMovie,
      mockSaveWatchlistMovie,
      mockRemoveWatchlistMovie,
    );
  });

  const tId = 1;
  const tMessage = 'Success';

  group('WatchListMovieEvent Equality Test', () {
    test('FetchWatchListMovieStatus props should include id', () {
      final event1 = FetchWatchListMovieStatus(1);
      final event2 = FetchWatchListMovieStatus(1);
      final event3 = FetchWatchListMovieStatus(2);

      expect(event1, equals(event2)); // Should be true
      expect(event1, isNot(event3)); // Should be false
    });
    test('FetchWatchListMovieStatus props should include id', () {
      final event1 = FetchWatchListMovies();
      final event2 = FetchWatchListMovies();

      expect(event1, equals(event2)); // Should be true
    });

    test(
        'UpdateWatchListMovieStatus props should include movieDetail and isAddedToWatchlist',
        () {
      final event1 = UpdateWatchListMovieStatus(testMovieDetail, true);
      final event2 = UpdateWatchListMovieStatus(testMovieDetail, true);
      final event3 = UpdateWatchListMovieStatus(testMovieDetail, false);

      expect(event1, equals(event2)); // Should be true
      expect(event1, isNot(event3)); // Should be false
    });
  });

  group('FetchWatchListMovies', () {
    blocTest<WatchListMovieBloc, WatchListMovieState>(
      'emits [WatchListMovieIsLoading, WatchListMovieIsLoaded] when data is fetched successfully',
      build: () {
        when(mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => Right(testMovieList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchWatchListMovies()),
      expect: () => [
        WatchListMovieIsLoading(),
        WatchListMovieIsLoaded(testMovieList),
      ],
      verify: (_) {
        verify(mockGetWatchlistMovies.execute());
      },
    );

    blocTest<WatchListMovieBloc, WatchListMovieState>(
      'emits [WatchListMovieIsLoading, WatchListMovieIsError] when fetching fails',
      build: () {
        when(mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Error')));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchWatchListMovies()),
      expect: () => [
        WatchListMovieIsLoading(),
        WatchListMovieIsError('Server Error'),
      ],
      verify: (_) {
        verify(mockGetWatchlistMovies.execute());
      },
    );
  });

  group('FetchWatchListMovieStatus', () {
    blocTest<WatchListMovieBloc, WatchListMovieState>(
      'emits [WatchListMovieIsLoading, WatchListMovieStatusIsLoaded] when status is fetched successfully',
      build: () {
        when(mockGetWatchListStatusMovie.execute(tId))
            .thenAnswer((_) async => true);
        return bloc;
      },
      act: (bloc) => bloc.add(FetchWatchListMovieStatus(tId)),
      expect: () => [
        WatchListMovieIsLoading(),
        WatchListMovieStatusIsLoaded(true),
      ],
      verify: (_) {
        verify(mockGetWatchListStatusMovie.execute(tId));
      },
    );
  });

  group('UpdateWatchListMovieStatus', () {
    blocTest<WatchListMovieBloc, WatchListMovieState>(
      'emits [WatchListMovieIsLoading, WatchListMovieIsSaved] when adding to watchlist is successful',
      build: () {
        when(mockSaveWatchlistMovie.execute(testMovieDetail))
            .thenAnswer((_) async => Right(tMessage));
        return bloc;
      },
      act: (bloc) =>
          bloc.add(UpdateWatchListMovieStatus(testMovieDetail, false)),
      expect: () => [
        WatchListMovieIsLoading(),
        WatchListMovieIsSaved(tMessage),
      ],
      verify: (_) {
        verify(mockSaveWatchlistMovie.execute(testMovieDetail));
      },
    );

    blocTest<WatchListMovieBloc, WatchListMovieState>(
      'emits [WatchListMovieIsLoading, WatchListMovieIsSaved] when remove from watchlist is successful',
      build: () {
        when(mockRemoveWatchlistMovie.execute(testMovieDetail))
            .thenAnswer((_) async => Right(tMessage));
        return bloc;
      },
      act: (bloc) =>
          bloc.add(UpdateWatchListMovieStatus(testMovieDetail, true)),
      expect: () => [
        WatchListMovieIsLoading(),
        WatchListMovieIsSaved(tMessage),
      ],
      verify: (_) {
        verify(mockRemoveWatchlistMovie.execute(testMovieDetail));
      },
    );

    blocTest<WatchListMovieBloc, WatchListMovieState>(
      'emits [WatchListMovieIsLoading, WatchListMovieIsError] when removing from watchlist fails',
      build: () {
        when(mockRemoveWatchlistMovie.execute(testMovieDetail))
            .thenAnswer((_) async => Left(ServerFailure('Server Error')));
        return bloc;
      },
      act: (bloc) =>
          bloc.add(UpdateWatchListMovieStatus(testMovieDetail, true)),
      expect: () => [
        WatchListMovieIsLoading(),
        WatchListMovieIsError('Server Error'),
      ],
      verify: (_) {
        verify(mockRemoveWatchlistMovie.execute(testMovieDetail));
      },
    );
  });
}
