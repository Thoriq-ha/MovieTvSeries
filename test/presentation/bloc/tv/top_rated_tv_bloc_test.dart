import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movietvseries/common/failure.dart';
import 'package:movietvseries/domain/usecases/get_top_rated_tv.dart';
import 'package:movietvseries/presentation/bloc/tv/top_rated_tv_bloc.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'top_rated_tv_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedTv])
void main() {
  late MockGetTopRatedTv mockGetTopRatedTV;
  late TopRatedTVBloc bloc;

  setUp(() {
    mockGetTopRatedTV = MockGetTopRatedTv();
    bloc = TopRatedTVBloc(
      mockGetTopRatedTV,
    );
  });

  const tMessage = 'Success';

  group('WatchListMovieEvent Equality Test', () {
    test('FetchTopRatedTV props should include id', () {
      final event1 = FetchTopRatedTV();
      final event2 = FetchTopRatedTV();

      expect(event1, equals(event2)); // Should be true
    });
  });

  group('FetchTopRatedTV', () {
    blocTest<TopRatedTVBloc, TopRatedTVState>(
      'emits [TopRatedTVIsLoading, TopRatedTVIsLoaded] when data is fetched successfully',
      build: () {
        when(mockGetTopRatedTV.execute())
            .thenAnswer((_) async => Right(testTvList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedTV()),
      expect: () => [
        TopRatedTVIsLoading(),
        TopRatedTVIsLoaded(testTvList),
      ],
      verify: (_) {
        verify(mockGetTopRatedTV.execute());
      },
    );

    blocTest<TopRatedTVBloc, TopRatedTVState>(
      'emits [TopRatedTVIsLoading, TopRatedTVIsError] when fetching fails',
      build: () {
        when(mockGetTopRatedTV.execute())
            .thenAnswer((_) async => Left(ServerFailure(tMessage)));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedTV()),
      expect: () => [
        TopRatedTVIsLoading(),
        TopRatedTVIsError(tMessage),
      ],
      verify: (_) {
        verify(mockGetTopRatedTV.execute());
      },
    );
  });
}
