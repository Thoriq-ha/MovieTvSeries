import 'package:movietvseries/data/models/genre_model.dart';
import 'package:movietvseries/data/models/tv_detail_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tMovieDetailResponse = TvDetailResponse(
      adult: false,
      backdropPath: 'backdropPath',
      episodeRunTime: [1, 2, 3],
      firstAirDate: "1985-12-30",
      genres: [GenreModel(id: 1, name: "Action")],
      homepage: "homepage",
      id: 1,
      inProduction: false,
      languages: ["en"],
      lastAirDate: "1988-05-23",
      name: "Name",
      numberOfEpisodes: 1,
      numberOfSeasons: 1,
      originCountry: ["US"],
      originalLanguage: "en",
      originalName: "Original Name",
      overview: "Overview",
      popularity: 1.0,
      posterPath: "/path.jpg",
      status: "Status",
      tagline: "tagline",
      type: "type",
      voteAverage: 1.0,
      voteCount: 1);

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tMovieDetailResponse.toJson();
      // assert
      final expectedJsonMap = {
        'adult': false,
        'backdrop_path': 'backdropPath',
        'episode_run_time': [1, 2, 3],
        'first_air_date': "1985-12-30",
        'genres': [
          {"id": 1, "name": "Action"}
        ],
        'homepage': "homepage",
        'id': 1,
        'in_production': false,
        'languages': ["en"],
        'last_air_date': "1988-05-23",
        'name': "Name",
        'number_of_episodes': 1,
        'number_of_seasons': 1,
        'origin_country': ["US"],
        'original_language': "en",
        'original_name': "Original Name",
        'overview': "Overview",
        'popularity': 1,
        'poster_path': "/path.jpg",
        'status': "Status",
        'tagline': "tagline",
        'type': "type",
        'vote_average': 1,
        'vote_count': 1,
      };
      expect(result, expectedJsonMap);
    });
  });
}
