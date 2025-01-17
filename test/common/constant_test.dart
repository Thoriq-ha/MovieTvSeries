import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movietvseries/common/constants.dart';

void main() {
  setUp(() {
    WidgetsFlutterBinding.ensureInitialized();
  });

  group('Theme Configuration Tests', () {
    test('should verify base color constants', () {
      expect(const Color(0xFF000814), kRichBlack);
      expect(const Color(0xFF001D3D), kOxfordBlue);
      expect(const Color(0xFF003566), kPrussianBlue);
      expect(const Color(0xFFffc300), kMikadoYellow);
      expect(const Color(0xFF4B5358), kDavysGrey);
      expect(const Color(0xFF303030), kGrey);
    });

    test('should verify text styles', () {
      final headlineSmall =
          GoogleFonts.poppins(fontSize: 23, fontWeight: FontWeight.w400);
      final titleLarge = GoogleFonts.poppins(
          fontSize: 19, fontWeight: FontWeight.w500, letterSpacing: 0.15);
      final titleMedium = GoogleFonts.poppins(
          fontSize: 15, fontWeight: FontWeight.w400, letterSpacing: 0.15);
      final bodyMedium = GoogleFonts.poppins(
          fontSize: 13, fontWeight: FontWeight.w400, letterSpacing: 0.25);

      expect(kTextTheme.headlineSmall, headlineSmall);
      expect(kTextTheme.titleLarge, titleLarge);
      expect(kTextTheme.titleMedium, titleMedium);
      expect(kTextTheme.bodyMedium, bodyMedium);
    });

    test('should verify color scheme', () {
      const expectedColorScheme = ColorScheme(
        primary: kMikadoYellow,
        primaryContainer: kMikadoYellow,
        secondary: kPrussianBlue,
        secondaryContainer: kPrussianBlue,
        surface: kRichBlack,
        error: Colors.red,
        onPrimary: kRichBlack,
        onSecondary: Colors.white,
        onSurface: Colors.white,
        onError: Colors.white,
        brightness: Brightness.dark,
      );

      expect(kColorScheme.primary, expectedColorScheme.primary);
      expect(kColorScheme.secondary, expectedColorScheme.secondary);
      expect(kColorScheme.surface, expectedColorScheme.surface);
      expect(kColorScheme.error, expectedColorScheme.error);
      expect(kColorScheme.onPrimary, expectedColorScheme.onPrimary);
      expect(kColorScheme.onSecondary, expectedColorScheme.onSecondary);
      expect(kColorScheme.onSurface, expectedColorScheme.onSurface);
      expect(kColorScheme.onError, expectedColorScheme.onError);
      expect(kColorScheme.brightness, expectedColorScheme.brightness);
    });
  });
}
