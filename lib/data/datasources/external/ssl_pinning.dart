import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class SslPinning {
  static Future<http.Client> createClient() async {
    final certBytes =
        await rootBundle.load('assets/certificates/themoviedb.org.crt');

    SecurityContext context = SecurityContext(withTrustedRoots: false);
    context.setTrustedCertificatesBytes(certBytes.buffer.asUint8List());

    final httpClient = HttpClient(context: context)
      ..badCertificateCallback = (cert, host, port) => false;

    return IOClient(httpClient);
  }
}
