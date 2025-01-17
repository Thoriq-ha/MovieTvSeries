import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movietvseries/common/failure.dart';
import 'package:movietvseries/domain/usecases/get_movie_recommendations.dart';
import 'package:movietvseries/presentation/bloc/movie/recomendations_movie_bloc.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'recomendations_movie_bloc_test.mocks.dart';

@GenerateMocks([GetMovieRecommendations])
void main() {
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MovieRecomendationsBloc bloc;

  setUp(() {
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    bloc = MovieRecomendationsBloc(
      mockGetMovieRecommendations,
    );
  });

  const tId = 1;
  const tMessage = 'Success';

  group('WatchListMovieEvent Equality Test', () {
    test('FetchMovieRecomendations props should include id', () {
      final event1 = FetchMovieRecomendations(1);
      final event2 = FetchMovieRecomendations(1);
      final event3 = FetchMovieRecomendations(2);

      expect(event1, equals(event2)); // Should be true
      expect(event1, isNot(event3)); // Should be false
    });
  });

  group('FetchMovieRecomendations', () {
    blocTest<MovieRecomendationsBloc, MovieRecomendationsState>(
      'emits [MovieRecomendationsIsLoading, MovieRecomendationsIsLoaded] when data is fetched successfully',
      build: () {
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => Right(testMovieList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchMovieRecomendations(tId)),
      expect: () => [
        MovieRecomendationsIsLoading(),
        MovieRecomendationsIsLoaded(testMovieList),
      ],
      verify: (_) {
        verify(mockGetMovieRecommendations.execute(tId));
      },
    );

    blocTest<MovieRecomendationsBloc, MovieRecomendationsState>(
      'emits [MovieRecomendationsIsLoading, MovieRecomendationsIsError] when fetching fails',
      build: () {
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure(tMessage)));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchMovieRecomendations(tId)),
      expect: () => [
        MovieRecomendationsIsLoading(),
        MovieRecomendationsIsError(tMessage),
      ],
      verify: (_) {
        verify(mockGetMovieRecommendations.execute(tId));
      },
    );
  });
}
