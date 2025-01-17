import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movietvseries/common/failure.dart';
import 'package:movietvseries/domain/usecases/get_tv_detail.dart';
import 'package:movietvseries/presentation/bloc/tv/detail_tv_bloc.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'detail_tv_bloc_test.mocks.dart';

@GenerateMocks([GetTvDetail])
void main() {
  late MockGetTvDetail mockGetTvDetail;
  late DetailTVBloc bloc;

  setUp(() {
    mockGetTvDetail = MockGetTvDetail();
    bloc = DetailTVBloc(
      mockGetTvDetail,
    );
  });

  const tId = 1;
  const tMessage = 'Success';

  group('WatchListMovieEvent Equality Test', () {
    test('FetchDetailTV props should include id', () {
      final event1 = FetchDetailTV(1);
      final event2 = FetchDetailTV(1);
      final event3 = FetchDetailTV(2);

      expect(event1, equals(event2)); // Should be true
      expect(event1, isNot(event3)); // Should be false
    });
  });

  group('FetchDetailTV', () {
    blocTest<DetailTVBloc, DetailTVState>(
      'emits [DetailTVIsLoading, DetailTVIsLoaded] when data is fetched successfully',
      build: () {
        when(mockGetTvDetail.execute(tId))
            .thenAnswer((_) async => Right(testTvDetail));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchDetailTV(tId)),
      expect: () => [
        DetailTVIsLoading(),
        DetailTVIsLoaded(testTvDetail),
      ],
      verify: (_) {
        verify(mockGetTvDetail.execute(tId));
      },
    );

    blocTest<DetailTVBloc, DetailTVState>(
      'emits [DetailTVIsLoading, DetailTVIsError] when fetching fails',
      build: () {
        when(mockGetTvDetail.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure(tMessage)));
        return bloc;
      },
      act: (bloc) => bloc.add(FetchDetailTV(tId)),
      expect: () => [
        DetailTVIsLoading(),
        DetailTVIsError(tMessage),
      ],
      verify: (_) {
        verify(mockGetTvDetail.execute(tId));
      },
    );
  });
}
