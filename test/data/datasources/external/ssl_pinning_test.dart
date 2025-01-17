import 'package:flutter_test/flutter_test.dart';
import 'package:http/io_client.dart';
import 'package:movietvseries/data/datasources/external/ssl_pinning.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SslPinning.createClient', () {
    test('should load certificate and create a valid IOClient', () async {
      // Act
      final client = await SslPinning.createClient();

      // Assert
      expect(client, isA<IOClient>());
    });
  });
}
