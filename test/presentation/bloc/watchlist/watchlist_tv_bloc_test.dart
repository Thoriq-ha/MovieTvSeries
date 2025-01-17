import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movietvseries/common/failure.dart';
import 'package:movietvseries/domain/usecases/get_watchlist_status_tv.dart';
import 'package:movietvseries/domain/usecases/get_watchlist_tv.dart';
import 'package:movietvseries/domain/usecases/remove_watchlist_tv.dart';
import 'package:movietvseries/domain/usecases/save_watchlist_tv.dart';
import 'package:movietvseries/presentation/bloc/watchlist/watchlist_tv_bloc.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'watchlist_tv_bloc_test.mocks.dart';

@GenerateMocks(
    [GetWatchlistTv, GetWatchListStatusTv, SaveWatchlistTv, RemoveWatchlistTv])
void main() {
  late MockGetWatchlistTv mockGetWatchlistTv;
  late MockGetWatchListStatusTv mockGetWatchListStatusTv;
  late MockSaveWatchlistTv mockSaveWatchlistTv;
  late MockRemoveWatchlistTv mockRemoveWatchlistTv;
  late WatchListTVBloc bloc;

  setUp(() {
    mockGetWatchlistTv = MockGetWatchlistTv();
    mockGetWatchListStatusTv = MockGetWatchListStatusTv();
    mockSaveWatchlistTv = MockSaveWatchlistTv();
    mockRemoveWatchlistTv = MockRemoveWatchlistTv();
    bloc = WatchListTVBloc(
      mockGetWatchlistTv,
      mockGetWatchListStatusTv,
      mockSaveWatchlistTv,
      mockRemoveWatchlistTv,
    );
  });

  const tId = 1;
  const tMessage = 'Success';

  group('WatchListTVEvent Equality Test', () {
    test('FetchWatchListTVStatus props should include id', () {
      final event1 = FetchWatchListTVStatus(1);
      final event2 = FetchWatchListTVStatus(1);
      final event3 = FetchWatchListTVStatus(2);

      expect(event1, equals(event2)); // Should be true
      expect(event1, isNot(event3)); // Should be false
    });
    test('FetchWatchListTVStatus props should include id', () {
      final event1 = FetchWatchListTVs();
      final event2 = FetchWatchListTVs();

      expect(event1, equals(event2)); // Should be true
    });

    test(
        'UpdateWatchListTVStatus props should include tvDetail and isAddedToWatchlist',
        () {
      final event1 = UpdateWatchListTVStatus(testTvDetail, true);
      final event2 = UpdateWatchListTVStatus(testTvDetail, true);
      final event3 = UpdateWatchListTVStatus(testTvDetail, false);

      expect(event1, equals(event2)); // Should be true
      expect(event1, isNot(event3)); // Should be false
    });
  });

  group('FetchWatchListTVs', () {
    blocTest<WatchListTVBloc, WatchListTVState>(
      'emits [WatchListTVIsLoading, WatchListTVIsLoaded] when data is fetched successfully',
      build: () {
        when(mockGetWatchlistTv.execute())
            .thenAnswer((_) async => Right(testTvList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchWatchListTVs()),
      expect: () => [
        WatchListTVIsLoading(),
        WatchListTVIsLoaded(testTvList),
      ],
      verify: (_) {
        verify(mockGetWatchlistTv.execute());
      },
    );

    blocTest<WatchListTVBloc, WatchListTVState>(
      'emits [WatchListTVIsLoading, WatchListTVIsError] when fetching fails',
      build: () {
        when(mockGetWatchlistTv.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Error')));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchWatchListTVs()),
      expect: () => [
        WatchListTVIsLoading(),
        WatchListTVIsError('Server Error'),
      ],
      verify: (_) {
        verify(mockGetWatchlistTv.execute());
      },
    );
  });

  group('FetchWatchListTVStatus', () {
    blocTest<WatchListTVBloc, WatchListTVState>(
      'emits [WatchListTVIsLoading, WatchListTVStatusIsLoaded] when status is fetched successfully',
      build: () {
        when(mockGetWatchListStatusTv.execute(tId))
            .thenAnswer((_) async => true);
        return bloc;
      },
      act: (bloc) => bloc.add(FetchWatchListTVStatus(tId)),
      expect: () => [
        WatchListTVIsLoading(),
        WatchListTVStatusIsLoaded(true),
      ],
      verify: (_) {
        verify(mockGetWatchListStatusTv.execute(tId));
      },
    );
  });

  group('UpdateWatchListTVStatus', () {
    blocTest<WatchListTVBloc, WatchListTVState>(
      'emits [WatchListTVIsLoading, WatchListTVIsSaved] when adding to watchlist is successful',
      build: () {
        when(mockSaveWatchlistTv.execute(testTvDetail))
            .thenAnswer((_) async => Right(tMessage));
        return bloc;
      },
      act: (bloc) => bloc.add(UpdateWatchListTVStatus(testTvDetail, false)),
      expect: () => [
        WatchListTVIsLoading(),
        WatchListTVIsSaved(tMessage),
      ],
      verify: (_) {
        verify(mockSaveWatchlistTv.execute(testTvDetail));
      },
    );

    blocTest<WatchListTVBloc, WatchListTVState>(
      'emits [WatchListTVIsLoading, WatchListTVIsSaved] when remove from watchlist is successful',
      build: () {
        when(mockRemoveWatchlistTv.execute(testTvDetail))
            .thenAnswer((_) async => Right(tMessage));
        return bloc;
      },
      act: (bloc) => bloc.add(UpdateWatchListTVStatus(testTvDetail, true)),
      expect: () => [
        WatchListTVIsLoading(),
        WatchListTVIsSaved(tMessage),
      ],
      verify: (_) {
        verify(mockRemoveWatchlistTv.execute(testTvDetail));
      },
    );

    blocTest<WatchListTVBloc, WatchListTVState>(
      'emits [WatchListTVIsLoading, WatchListTVIsError] when removing from watchlist fails',
      build: () {
        when(mockRemoveWatchlistTv.execute(testTvDetail))
            .thenAnswer((_) async => Left(ServerFailure('Server Error')));
        return bloc;
      },
      act: (bloc) => bloc.add(UpdateWatchListTVStatus(testTvDetail, true)),
      expect: () => [
        WatchListTVIsLoading(),
        WatchListTVIsError('Server Error'),
      ],
      verify: (_) {
        verify(mockRemoveWatchlistTv.execute(testTvDetail));
      },
    );
  });
}
