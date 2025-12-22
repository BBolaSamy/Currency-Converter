import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AppEnv {
  String get baseUrl => (dotenv.env['BASE_URL']?.trim().isNotEmpty ?? false)
      ? dotenv.env['BASE_URL']!.trim()
      : 'https://api.exchangeratesapi.io/v1/';

  String? get apiKey {
    final key = dotenv.env['API_KEY']?.trim();
    if (key == null || key.isEmpty) return null;
    return key;
  }
}
