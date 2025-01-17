import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movietvseries/common/failure.dart';
import 'package:movietvseries/domain/usecases/get_movie_detail.dart';
import 'package:movietvseries/presentation/bloc/movie/detail_movie_bloc.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'detail_movie_bloc_test.mocks.dart';

@GenerateMocks([GetMovieDetail])
void main() {
  late MockGetMovieDetail mockGetMovieDetail;
  late DetailMovieBloc bloc;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    bloc = DetailMovieBloc(
      mockGetMovieDetail,
    );
  });

  const tId = 1;
  const tMessage = 'Success';

  group('WatchListMovieEvent Equality Test', () {
    test('FetchDetailMovie props should include id', () {
      final event1 = FetchDetailMovie(1);
      final event2 = FetchDetailMovie(1);
      final event3 = FetchDetailMovie(2);

      expect(event1, equals(event2)); // Should be true
      expect(event1, isNot(event3)); // Should be false
    });
  });

  group('FetchDetailMovie', () {
    blocTest<DetailMovieBloc, DetailMovieState>(
      'emits [DetailMovieIsLoading, DetailMovieIsLoaded] when data is fetched successfully',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => Right(testMovieDetail));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchDetailMovie(tId)),
      expect: () => [
        DetailMovieIsLoading(),
        DetailMovieIsLoaded(testMovieDetail),
      ],
      verify: (_) {
        verify(mockGetMovieDetail.execute(tId));
      },
    );

    blocTest<DetailMovieBloc, DetailMovieState>(
      'emits [DetailMovieIsLoading, DetailMovieIsError] when fetching fails',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure(tMessage)));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchDetailMovie(tId)),
      expect: () => [
        DetailMovieIsLoading(),
        DetailMovieIsError(tMessage),
      ],
      verify: (_) {
        verify(mockGetMovieDetail.execute(tId));
      },
    );
  });
}
