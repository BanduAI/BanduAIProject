import 'package:dio/dio.dart';
import 'dart:convert';

class GeminiClient {
  final Dio dio;
  final String apiKey;

  GeminiClient(this.dio, this.apiKey);

  String _getEndpointMethod(String model,
      {bool isStream = false, bool isPredict = false}) {
    if (isPredict) return ':predict';
    if (isStream) return ':streamGenerateContent';
    return ':generateContent';
  }

  Future<Completion> createChat({
    required List<Message> messages,
    String model = 'gemini-2.5-flash',
    int maxTokens = 1024,
    double temperature = 1.0,
    String? selectedLanguage,
    CancelToken? cancelToken,
  }) async {
    try {
      final contents = messages
          .map((m) => {
                'role': m.role,
                'parts': m.content is String
                    ? [
                        {'text': m.content}
                      ]
                    : m.content,
              })
          .toList();

      // Add language instruction if provided
      if (selectedLanguage != null && selectedLanguage.isNotEmpty) {
        final languagePrompt = _getLanguagePrompt(selectedLanguage);
        contents.insert(0, {
          'role': 'system',
          'parts': [
            {'text': languagePrompt}
          ]
        });
      }

      final endpoint = _getEndpointMethod(model);

      final response = await dio.post(
        '/models/$model$endpoint',
        data: {
          'contents': contents,
          'generationConfig': {
            'maxOutputTokens': maxTokens,
            'temperature': temperature,
          },
          'safetySettings': _getSafetySettings(),
        },
        cancelToken: cancelToken,
      );

      if (response.data['candidates'] != null &&
          response.data['candidates'].isNotEmpty &&
          response.data['candidates'][0]['content'] != null) {
        final parts = response.data['candidates'][0]['content']['parts'];
        final text = parts.isNotEmpty ? parts[0]['text'] : '';
        return Completion(text: text);
      } else {
        throw GeminiException(
          statusCode: response.statusCode ?? 500,
          message: 'Failed to parse response or empty response',
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        throw GeminiException(
          statusCode: 499,
          message: 'Request was cancelled by user',
        );
      }
      throw GeminiException(
        statusCode: e.response?.statusCode ?? 500,
        message: e.response?.data?['error']?['message'] ?? e.message,
      );
    }
  }

  Stream<String> streamChat({
    required List<Message> messages,
    String model = 'gemini-2.5-flash',
    int maxTokens = 1024,
    double temperature = 1.0,
    String? selectedLanguage,
    CancelToken? cancelToken,
  }) async* {
    try {
      final contents = messages
          .map((m) => {
                'role': m.role,
                'parts': m.content is String
                    ? [
                        {'text': m.content}
                      ]
                    : m.content,
              })
          .toList();

      if (selectedLanguage != null && selectedLanguage.isNotEmpty) {
        final languagePrompt = _getLanguagePrompt(selectedLanguage);
        contents.insert(0, {
          'role': 'system',
          'parts': [
            {'text': languagePrompt}
          ]
        });
      }

      final endpoint = _getEndpointMethod(model, isStream: true);

      final response = await dio.post(
        '/models/$model$endpoint',
        data: {
          'contents': contents,
          'generationConfig': {
            'maxOutputTokens': maxTokens,
            'temperature': temperature,
          },
          'safetySettings': _getSafetySettings(),
        },
        options: Options(responseType: ResponseType.stream),
        cancelToken: cancelToken,
      );

      final stream = response.data as ResponseBody;
      await for (var line
          in LineSplitter().bind(utf8.decoder.bind(stream.stream))) {
        if (line.startsWith('data: ')) {
          final data = line.substring(6);
          if (data == '[DONE]') break;

          try {
            final json = jsonDecode(data) as Map<String, dynamic>;
            if (json.containsKey('candidates') &&
                json['candidates'].isNotEmpty &&
                json['candidates'][0].containsKey('content') &&
                json['candidates'][0]['content'].containsKey('parts') &&
                json['candidates'][0]['content']['parts'].isNotEmpty) {
              final text = json['candidates'][0]['content']['parts'][0]['text'];
              if (text != null && text.isNotEmpty) {
                yield text;
              }
            }
          } catch (e) {
            // Skip malformed data
          }
        }
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        throw GeminiException(
          statusCode: 499,
          message: 'Request was cancelled by user',
        );
      }
      throw GeminiException(
        statusCode: e.response?.statusCode ?? 500,
        message: e.response?.data?['error']?['message'] ?? e.message,
      );
    }
  }

  String _getLanguagePrompt(String languageCode) {
    switch (languageCode.toLowerCase()) {
      case 'hi':
      case 'hindi':
        return 'Please respond in Hindi language (हिंदी में जवाब दें). Use Devanagari script and maintain cultural context appropriate for Indian users.';
      case 'en':
      case 'english':
        return 'Please respond in English language. Maintain clear and professional communication.';
      default:
        return 'Please respond in the requested language: $languageCode';
    }
  }

  List<Map<String, dynamic>> _getSafetySettings() {
    return [
      {
        'category': 'HARM_CATEGORY_HARASSMENT',
        'threshold': 'BLOCK_LOW_AND_ABOVE'
      },
      {
        'category': 'HARM_CATEGORY_HATE_SPEECH',
        'threshold': 'BLOCK_LOW_AND_ABOVE'
      },
      {
        'category': 'HARM_CATEGORY_SEXUALLY_EXPLICIT',
        'threshold': 'BLOCK_LOW_AND_ABOVE'
      },
      {
        'category': 'HARM_CATEGORY_DANGEROUS_CONTENT',
        'threshold': 'BLOCK_LOW_AND_ABOVE'
      }
    ];
  }
}

// Data Classes
class Message {
  final String role;
  final dynamic content;

  Message({required this.role, required this.content});
}

class Completion {
  final String text;
  Completion({required this.text});
}

class GeminiException implements Exception {
  final int statusCode;
  final String message;

  GeminiException({required this.statusCode, required this.message});

  @override
  String toString() => 'GeminiException: $statusCode - $message';
}




