import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movietvseries/common/failure.dart';
import 'package:movietvseries/domain/usecases/get_now_playing_tv.dart';
import 'package:movietvseries/presentation/bloc/tv/now_playing_tv_bloc.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'now_playing_tv_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingTv])
void main() {
  late MockGetNowPlayingTv mockGetNowPlayingTV;
  late NowPlayingTVBloc bloc;

  setUp(() {
    mockGetNowPlayingTV = MockGetNowPlayingTv();
    bloc = NowPlayingTVBloc(
      mockGetNowPlayingTV,
    );
  });

  const tMessage = 'Success';

  group('WatchListMovieEvent Equality Test', () {
    test('FetchNowPlayingTV props should include id', () {
      final event1 = FetchNowPlayingTV();
      final event2 = FetchNowPlayingTV();

      expect(event1, equals(event2)); // Should be true
    });
  });

  group('FetchNowPlayingTV', () {
    blocTest<NowPlayingTVBloc, NowPlayingTVState>(
      'emits [NowPlayingTVIsLoading, NowPlayingTVIsLoaded] when data is fetched successfully',
      build: () {
        when(mockGetNowPlayingTV.execute())
            .thenAnswer((_) async => Right(testTvList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchNowPlayingTV()),
      expect: () => [
        NowPlayingTVIsLoading(),
        NowPlayingTVIsLoaded(testTvList),
      ],
      verify: (_) {
        verify(mockGetNowPlayingTV.execute());
      },
    );

    blocTest<NowPlayingTVBloc, NowPlayingTVState>(
      'emits [NowPlayingTVIsLoading, NowPlayingTVIsError] when fetching fails',
      build: () {
        when(mockGetNowPlayingTV.execute())
            .thenAnswer((_) async => Left(ServerFailure(tMessage)));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchNowPlayingTV()),
      expect: () => [
        NowPlayingTVIsLoading(),
        NowPlayingTVIsError(tMessage),
      ],
      verify: (_) {
        verify(mockGetNowPlayingTV.execute());
      },
    );
  });
}
