import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movietvseries/common/failure.dart';
import 'package:movietvseries/domain/usecases/get_popular_movies.dart';
import 'package:movietvseries/presentation/bloc/movie/popular_movie_bloc.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'popular_movie_bloc_test.mocks.dart';

@GenerateMocks([GetPopularMovies])
void main() {
  late MockGetPopularMovies mockGetPopularMovies;
  late PopularMoviesBloc bloc;

  setUp(() {
    mockGetPopularMovies = MockGetPopularMovies();
    bloc = PopularMoviesBloc(
      mockGetPopularMovies,
    );
  });

  const tMessage = 'Success';

  group('WatchListMovieEvent Equality Test', () {
    test('FetchPopularMovies props should include id', () {
      final event1 = FetchPopularMovies();
      final event2 = FetchPopularMovies();

      expect(event1, equals(event2)); // Should be true
    });
  });

  group('FetchPopularMovies', () {
    blocTest<PopularMoviesBloc, PopularMoviesState>(
      'emits [PopularMovieIsLoading, PopularMovieIsLoaded] when data is fetched successfully',
      build: () {
        when(mockGetPopularMovies.execute())
            .thenAnswer((_) async => Right(testMovieList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchPopularMovies()),
      expect: () => [
        PopularMovieIsLoading(),
        PopularMovieIsLoaded(testMovieList),
      ],
      verify: (_) {
        verify(mockGetPopularMovies.execute());
      },
    );

    blocTest<PopularMoviesBloc, PopularMoviesState>(
      'emits [PopularMovieIsLoading, PopularMovieIsError] when fetching fails',
      build: () {
        when(mockGetPopularMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure(tMessage)));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchPopularMovies()),
      expect: () => [
        PopularMovieIsLoading(),
        PopularMovieIsError(tMessage),
      ],
      verify: (_) {
        verify(mockGetPopularMovies.execute());
      },
    );
  });
}
