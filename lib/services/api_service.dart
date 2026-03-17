import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import '../config/api_config.dart';
import '../models/models.dart';
import 'storage_service.dart';

class SchedulingConflictException implements Exception {
  final SchedulingConflictResponse conflict;
  const SchedulingConflictException(this.conflict);
}

class ApiService {
  late final Dio _dio;
  final StorageService _storageService;
  VoidCallback? onUnauthorized;

  ApiService(this._storageService) {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: ApiConfig.timeout,
      receiveTimeout: ApiConfig.timeout,
      headers: {'Content-Type': 'application/json'},
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        if (!options.path.startsWith('/auth')) {
          final token = await _storageService.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
        }
        handler.next(options);
      },
      onError: (error, handler) {
        if (error.response?.statusCode == 401) {
          _storageService.deleteToken();
          onUnauthorized?.call();
        }
        handler.next(error);
      },
    ));
  }

  // === Auth ===

  Future<UserProfile> register(String email, String password) async {
    final response = await _dio.post(
      ApiConfig.register,
      data: {'email': email, 'password': password},
    );
    return UserProfile.fromJson(response.data);
  }

  Future<Token> login(String email, String password) async {
    final response = await _dio.post(
      ApiConfig.login,
      data: {'username': email, 'password': password},
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
    return Token.fromJson(response.data);
  }

  Future<UserProfile> getMe() async {
    final response = await _dio.get(ApiConfig.me);
    return UserProfile.fromJson(response.data);
  }

  // === Onboarding ===

  Future<UserProfile> submitOnboarding(OnboardingRequest request) async {
    final response = await _dio.post(
      ApiConfig.onboarding,
      data: request.toJson(),
    );
    return UserProfile.fromJson(response.data);
  }

  // === Scheduling ===

  Future<SchedulingResponse> addWithAi(SchedulingRequest request) async {
    try {
      final response = await _dio.post(
        ApiConfig.addWithAi,
        data: request.toJson(),
      );
      return SchedulingResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        final detail = e.response!.data['detail'];
        final conflictData = detail is String ? jsonDecode(detail) : detail;
        throw SchedulingConflictException(
          SchedulingConflictResponse.fromJson(conflictData as Map<String, dynamic>),
        );
      }
      rethrow;
    }
  }

  Future<SchedulingResponse> importFile(File file, List<Event> currentEvents) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path, filename: file.path.split('/').last),
        'current_events_str': jsonEncode(currentEvents.map((e) => e.toJson()).toList()),
      });
      final response = await _dio.post(ApiConfig.importFile, data: formData);
      return SchedulingResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        final detail = e.response!.data['detail'];
        final conflictData = detail is String ? jsonDecode(detail) : detail;
        throw SchedulingConflictException(
          SchedulingConflictResponse.fromJson(conflictData as Map<String, dynamic>),
        );
      }
      rethrow;
    }
  }

  Future<SchedulingResponse> resolveConflict(ResolveConflictRequest request) async {
    final response = await _dio.post(
      ApiConfig.resolveConflict,
      data: request.toJson(),
    );
    return SchedulingResponse.fromJson(response.data);
  }

  // === Suggestions ===

  Future<SuggestionResponse> getSuggestions() async {
    final response = await _dio.get(ApiConfig.suggestions);
    return SuggestionResponse.fromJson(response.data);
  }
}

typedef VoidCallback = void Function();
