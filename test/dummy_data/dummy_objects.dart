import 'package:movietvseries/data/models/movie_table.dart';
import 'package:movietvseries/data/models/tv_table.dart';
import 'package:movietvseries/domain/entities/genre.dart';
import 'package:movietvseries/domain/entities/movie.dart';
import 'package:movietvseries/domain/entities/movie_detail.dart';
import 'package:movietvseries/domain/entities/tv.dart';
import 'package:movietvseries/domain/entities/tv_detail.dart';

final testMovie = Movie(
  adult: false,
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: [14, 28],
  id: 557,
  originalTitle: 'Spider-Man',
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  popularity: 60.441,
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  releaseDate: '2002-05-01',
  title: 'Spider-Man',
  video: false,
  voteAverage: 7.2,
  voteCount: 13507,
);

final testMovieList = [testMovie];

final testMovieDetail = MovieDetail(
  adult: false,
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  originalTitle: 'originalTitle',
  overview: 'overview',
  posterPath: 'posterPath',
  releaseDate: 'releaseDate',
  runtime: 120,
  title: 'title',
  voteAverage: 1,
  voteCount: 1,
);

final testWatchlistMovie = Movie.watchlist(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieTable = MovieTable(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'title': 'title',
};

final testTvTable = TvTable(
  id: 1,
  name: 'Name',
  posterPath: '/path.jpg',
  overview: 'Overview',
);

final testTvMap = {
  'id': 1,
  'overview': 'Overview',
  'poster_path': '/path.jpg',
  'name': 'Name',
};

final testTvDetail = TvDetail(
    adult: false,
    backdropPath: 'backdropPath',
    episodeRunTime: [1, 2, 3],
    firstAirDate: "1985-12-30",
    genres: [Genre(id: 1, name: "Action")],
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

final testTv = Tv(
  backdropPath: "backdropPath",
  firstAirDate: "firstAirDate",
  genreIds: [1, 2, 3],
  id: 1,
  name: "name",
  originCountry: ["originCountry1", "originCountry1", "originCountry1"],
  originalLanguage: "originalLanguage",
  originalName: "originalName",
  overview: "overview",
  popularity: 1.0,
  posterPath: "posterPath",
  voteAverage: 1.0,
  voteCount: 1,
);
final testTvList = [testTv];

final testWatchlistTv = Tv.watchlist(
  id: 1,
  name: 'Name',
  posterPath: '/path.jpg',
  overview: 'Overview',
);
