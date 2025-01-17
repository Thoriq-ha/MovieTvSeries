import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movietvseries/common/failure.dart';
import 'package:movietvseries/domain/usecases/get_now_playing_movies.dart';
import 'package:movietvseries/presentation/bloc/movie/now_playing_movie_bloc.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'now_playing_movie_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingMovies])
void main() {
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;
  late NowPlayingMovieBloc bloc;

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    bloc = NowPlayingMovieBloc(
      mockGetNowPlayingMovies,
    );
  });

  const tMessage = 'Success';

  group('WatchListMovieEvent Equality Test', () {
    test('FetchNowPlayingMovie props should include id', () {
      final event1 = FetchNowPlayingMovie();
      final event2 = FetchNowPlayingMovie();

      expect(event1, equals(event2)); // Should be true
    });
  });

  group('FetchNowPlayingMovie', () {
    blocTest<NowPlayingMovieBloc, NowPlayingMovieState>(
      'emits [NowPlayingMovieIsLoading, NowPlayingMovieIsLoaded] when data is fetched successfully',
      build: () {
        when(mockGetNowPlayingMovies.execute())
            .thenAnswer((_) async => Right(testMovieList));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchNowPlayingMovie()),
      expect: () => [
        NowPlayingMovieIsLoading(),
        NowPlayingMovieIsLoaded(testMovieList),
      ],
      verify: (_) {
        verify(mockGetNowPlayingMovies.execute());
      },
    );

    blocTest<NowPlayingMovieBloc, NowPlayingMovieState>(
      'emits [NowPlayingMovieIsLoading, NowPlayingMovieIsError] when fetching fails',
      build: () {
        when(mockGetNowPlayingMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure(tMessage)));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchNowPlayingMovie()),
      expect: () => [
        NowPlayingMovieIsLoading(),
        NowPlayingMovieIsError(tMessage),
      ],
      verify: (_) {
        verify(mockGetNowPlayingMovies.execute());
      },
    );
  });
}
