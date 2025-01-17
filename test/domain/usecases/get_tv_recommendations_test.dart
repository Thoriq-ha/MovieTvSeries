import 'package:dartz/dartz.dart';
import 'package:movietvseries/domain/entities/tv.dart';
import 'package:movietvseries/domain/usecases/get_tv_recommendations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvRecommendations usecase;
  late MockTvRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockTvRepository();
    usecase = GetTvRecommendations(mockMovieRepository);
  });

  final tId = 1;
  final tTv = <Tv>[];

  test('should get list of tv recommendations from the repository', () async {
    // arrange
    when(mockMovieRepository.getTvRecommendations(tId))
        .thenAnswer((_) async => Right(tTv));
    // act
    final result = await usecase.execute(tId);
    // assert
    expect(result, Right(tTv));
  });
}
