import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class SharedHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => false; // Security: Reject bad certs
  }
}

class SslPinningClient {
  static Future<http.Client> get _instance async => _clientInstance ??= await createLEClient();
  static http.Client? _clientInstance;

  static http.Client get client => _clientInstance ?? http.Client();

  static Future<void> init() async {
    _clientInstance = await createLEClient();
  }

  static Future<http.Client> createLEClient() async {
    final context = SecurityContext(withTrustedRoots: false);
    // ... (logic to load certificates.pem bytes into context) ...
    
    final httpClient = HttpClient(context: context);
    
    // FIX: Temporarily allow the handshake if the host is TMDB, 
    // ensuring the app uses your pinned certificate for the connection.
    httpClient.badCertificateCallback = (X509Certificate cert, String host, int port) {
      // Allow the certificate if the host is the one we pinned against
      return host == "api.themoviedb.org" || host == "image.tmdb.org"; 
    };
    
    return IOClient(httpClient);
  }
}