[![Codemagic build status](https://api.codemagic.io/apps/678a103b94bef0cca0addf06/build-movie-tv-series/status_badge.svg)](https://codemagic.io/app/678a103b94bef0cca0addf06/build-movie-tv-series/latest_build)

# MovieTVSeries - Flutter Developer Expert Project

## Table of Contents
- [MovieTVSeries - Flutter Developer Expert Project](#movietvseries---flutter-developer-expert-project)
  - [Table of Contents](#table-of-contents)
  - [About](#about)
  - [Features](#features)
  - [Installation](#installation)
  - [Usage](#usage)
  - [Technologies Used](#technologies-used)
  - [Contributing](#contributing)
  - [License](#license)

---

## About
MovieTVSeries is a Flutter project developed as part of the **Become a Flutter Developer Expert** program at Dicoding. This application serves as a platform for managing and exploring movies and TV shows, providing users with detailed information and watchlist features.

## Features
- Browse popular movies and TV shows
- View detailed information for each title
- Search for movies and TV shows
- Add and manage your watchlist

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/Thoriq-ha/movietvseries.git
   ```

2. Navigate to the project directory:
   ```bash
   cd movietvseries
   ```

3. Install dependencies:
   ```bash
   flutter pub get
   ```

4. Create an `.env` file in the root directory by copying the example file:
   ```bash
   cp .env.example .env
   ```

5. Edit the `.env` file with your API key and base URL:
   ```env
   API_KEY='api_key_here'
   BASE_URL='https://api.themoviedb.org/3'
   ```

6. Run the app:
   ```bash
   flutter run
   ```

## Usage
- Open the app to browse popular movies and TV shows.
- Use the search feature to find specific titles.
- Add movies or TV shows to your watchlist for later viewing.

## Technologies Used
- [Flutter](https://flutter.dev/)
- [Bloc](https://pub.dev/packages/bloc) for state management
- [GetIt](https://pub.dev/packages/get_it) for dependency injection
- [HTTP](https://pub.dev/packages/http) for API requests
- [SQLite](https://pub.dev/packages/sqflite) for local storage

## Contributing
Contributions are welcome! Follow these steps to contribute:

1. Fork the repository.
2. Create a new branch:
   ```bash
   git checkout -b feature-name
   ```
3. Commit your changes:
   ```bash
   git commit -m 'Add some feature'
   ```
4. Push to the branch:
   ```bash
   git push origin feature-name
   ```
5. Open a pull request.

## License
This project is licensed under the [MIT License](LICENSE).

---
