import 'package:dio/dio.dart';

class GeminiService {
  static final GeminiService _instance = GeminiService._internal();
  late final Dio _dio;
  static const String apiKey = String.fromEnvironment('AIzaSyAV9jOKymcRgdm_onz89HkI4zU3fBy0tV8');

  factory GeminiService() => _instance;

  GeminiService._internal() {
    _initializeService();
  }

  void _initializeService() {
    if (apiKey.isEmpty) {
      throw Exception('AIzaSyAV9jOKymcRgdm_onz89HkI4zU3fBy0tV8');
    }

    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://generativelanguage.googleapis.com/v1',
        headers: {'Content-Type': 'application/json'},
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 60),
      ),
    );

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        final pathSegments = options.path.split('/');
        final model =
            pathSegments.length > 2 ? pathSegments[2].split(':')[0] : null;
        if (model != null && _requiresV1Beta(model)) {
          options.baseUrl = 'https://generativelanguage.googleapis.com/v1beta';
        }
        if (!options.queryParameters.containsKey('key')) {
          options.queryParameters['key'] = apiKey;
        }
        handler.next(options);
      },
    ));
  }

  bool _requiresV1Beta(String modelId) {
    return modelId.contains('preview') ||
        modelId.contains('exp') ||
        modelId.contains('thinking') ||
        modelId.startsWith('imagen-') ||
        modelId.contains('image-preview') ||
        modelId.contains('tts') ||
        modelId.contains('live');
  }

  Dio get dio => _dio;
  String get authApiKey => apiKey;
}




