import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movietvseries/common/failure.dart';
import 'package:movietvseries/domain/usecases/get_tv_recommendations.dart';
import 'package:movietvseries/presentation/bloc/tv/recomendations_tv_bloc.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'recomendations_tv_bloc_test.mocks.dart';

@GenerateMocks([GetTvRecommendations])
void main() {
  late MockGetTvRecommendations mockGetTVRecommendations;
  late TVRecomendationsBloc bloc;

  setUp(() {
    mockGetTVRecommendations = MockGetTvRecommendations();
    bloc = TVRecomendationsBloc(
      mockGetTVRecommendations,
    );
  });

  const tId = 1;
  const tMessage = 'Success';

  group('WatchListTVEvent Equality Test', () {
    test('FetchTVRecomendations props should include id', () {
      final event1 = FetchTVRecomendations(1);
      final event2 = FetchTVRecomendations(1);
      final event3 = FetchTVRecomendations(2);

      expect(event1, equals(event2)); // Should be true
      expect(event1, isNot(event3)); // Should be false
    });
  });

  group('FetchTVRecomendations', () {
    blocTest<TVRecomendationsBloc, TVRecomendationsState>(
      'emits [TVRecomendationsIsLoading, TVRecomendationsIsLoaded] when data is fetched successfully',
      build: () {
        when(mockGetTVRecommendations.execute(tId))
            .thenAnswer((_) async => Right(testTvList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchTVRecomendations(tId)),
      expect: () => [
        TVRecomendationsIsLoading(),
        TVRecomendationsIsLoaded(testTvList),
      ],
      verify: (_) {
        verify(mockGetTVRecommendations.execute(tId));
      },
    );

    blocTest<TVRecomendationsBloc, TVRecomendationsState>(
      'emits [TVRecomendationsIsLoading, TVRecomendationsIsError] when fetching fails',
      build: () {
        when(mockGetTVRecommendations.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure(tMessage)));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchTVRecomendations(tId)),
      expect: () => [
        TVRecomendationsIsLoading(),
        TVRecomendationsIsError(tMessage),
      ],
      verify: (_) {
        verify(mockGetTVRecommendations.execute(tId));
      },
    );
  });
}
