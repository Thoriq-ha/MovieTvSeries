import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movietvseries/common/failure.dart';
import 'package:movietvseries/domain/usecases/get_popular_tv.dart';
import 'package:movietvseries/presentation/bloc/tv/popular_tv_bloc.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'popular_tv_bloc_test.mocks.dart';

@GenerateMocks([GetPopularTv])
void main() {
  late MockGetPopularTv mockGetPopularTV;
  late PopularTVBloc bloc;

  setUp(() {
    mockGetPopularTV = MockGetPopularTv();
    bloc = PopularTVBloc(
      mockGetPopularTV,
    );
  });

  const tMessage = 'Success';

  group('WatchListMovieEvent Equality Test', () {
    test('FetchPopularTV props should include id', () {
      final event1 = FetchPopularTV();
      final event2 = FetchPopularTV();

      expect(event1, equals(event2)); // Should be true
    });
  });

  group('FetchPopularTV', () {
    blocTest<PopularTVBloc, PopularTVState>(
      'emits [PopularTVIsLoading, PopularTVIsLoaded] when data is fetched successfully',
      build: () {
        when(mockGetPopularTV.execute())
            .thenAnswer((_) async => Right(testTvList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchPopularTV()),
      expect: () => [
        PopularTVIsLoading(),
        PopularTVIsLoaded(testTvList),
      ],
      verify: (_) {
        verify(mockGetPopularTV.execute());
      },
    );

    blocTest<PopularTVBloc, PopularTVState>(
      'emits [PopularTVIsLoading, PopularTVIsError] when fetching fails',
      build: () {
        when(mockGetPopularTV.execute())
            .thenAnswer((_) async => Left(ServerFailure(tMessage)));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchPopularTV()),
      expect: () => [
        PopularTVIsLoading(),
        PopularTVIsError(tMessage),
      ],
      verify: (_) {
        verify(mockGetPopularTV.execute());
      },
    );
  });
}
