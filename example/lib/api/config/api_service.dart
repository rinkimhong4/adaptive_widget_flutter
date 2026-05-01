import 'dart:convert';
import 'dart:async';
import 'package:example/api/config/function/function.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static final http.Client _httpClient = http.Client();
  final String baseUrl;
  final String? accessToken;

  ApiService({required this.baseUrl, this.accessToken});

  // ---------------------------------------------------------------------------
  // Single-object request
  // ---------------------------------------------------------------------------
  Future<T> callApi<T>({
    required String endpoint,
    Map<String, String>? queryParams,
    Map<String, String>? headers,
    String method = 'GET',
    dynamic body,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final response = await _send(
        endpoint: endpoint,
        queryParams: queryParams,
        headers: headers,
        method: method,
        body: body,
      );
      return _processResponse(response, fromJson);
    } catch (e) {
      debugPrint('Unexpected Error: $e');
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // List request — for endpoints returning arrays.
  // Set [dataKey] when the API wraps the array, e.g. { "products": [...] }
  // The extractor is defensive and falls back to common keys if dataKey misses.
  // ---------------------------------------------------------------------------
  Future<List<T>> callApiList<T>({
    required String endpoint,
    Map<String, String>? queryParams,
    Map<String, String>? headers,
    String method = 'GET',
    dynamic body,
    required T Function(Map<String, dynamic>) fromJson,
    String? dataKey,
  }) async {
    try {
      final response = await _send(
        endpoint: endpoint,
        queryParams: queryParams,
        headers: headers,
        method: method,
        body: body,
      );

      final statusCode = response.statusCode;
      if (statusCode == 200 || statusCode == 201) {
        final decoded = response.bodyBytes.length > 10000
            ? await compute(jsonDecode, response.body)
            : jsonDecode(response.body);

        final List? rawList = _extractList(decoded, dataKey);

        if (rawList == null) {
          debugPrint('Could not find a list in response: $decoded');
          throw ApiException(
            message:
                'Expected a list but could not find one. '
                'Check your API shape or `listDataKey`.',
            statusCode: statusCode,
          );
        }

        return rawList.map((e) => fromJson(e as Map<String, dynamic>)).toList();
      }

      _throwForStatus(response);
      throw ApiException(message: 'Unreachable', statusCode: statusCode);
    } catch (e) {
      debugPrint('Unexpected Error: $e');
      rethrow;
    }
  }

  /// Tries hard to find a List inside any common API response shape.
  List? _extractList(dynamic decoded, String? dataKey) {
    // 1. Already a raw list
    if (decoded is List) return decoded;
    if (decoded is! Map) return null;

    // 2. Caller specified a key — use it (and dive one level if needed)
    // if (dataKey != null) {
    //   final v = decoded[dataKey];
    //   if (v is List) return v;
    //   if (v is Map) {
    //     for (final inner in const ['items', 'results', 'list', 'records']) {
    //       if (v[inner] is List) return v[inner];
    //     }
    //   }
    //   return null;
    // }

    if (dataKey != null) {
      final result = _getByPath(decoded, dataKey);

      if (result is List) return result;

      if (result is Map) {
        for (final inner in const ['items', 'results', 'list', 'records']) {
          if (result[inner] is List) return result[inner];
        }
      }
      return null;
    }

    // 3. No dataKey — try the usual suspects
    for (final key in const [
      'data',
      'items',
      'results',
      'list',
      'records',
      'products',
    ]) {
      if (decoded[key] is List) return decoded[key];
    }
    return null;
  }

  dynamic _getByPath(dynamic json, String path) {
    final keys = path.split('.');
    dynamic current = json;

    for (final key in keys) {
      if (current is Map && current.containsKey(key)) {
        current = current[key];
      } else {
        return null;
      }
    }

    return current;
  }

  // ---------------------------------------------------------------------------
  // Internal: build & send request
  // ---------------------------------------------------------------------------
  Future<http.Response> _send({
    required String endpoint,
    Map<String, String>? queryParams,
    Map<String, String>? headers,
    String method = 'GET',
    dynamic body,
  }) async {
    final base = Uri.parse(baseUrl);
    final uri = base.replace(
      path: base.path + endpoint,
      queryParameters: queryParams,
    );

    final requestHeaders = {
      "Content-Type": 'application/json; charset=UTF-8',
      'Accept': '*/*',
      if (accessToken != null) 'Authorization': 'Bearer $accessToken',
      if (headers != null) ...headers,
    };

    final encodedBody = body != null ? jsonEncode(body) : null;

    switch (method.toUpperCase()) {
      case 'POST':
        return _httpClient.post(
          uri,
          headers: requestHeaders,
          body: encodedBody,
        );
      case 'PUT':
        return _httpClient.put(uri, headers: requestHeaders, body: encodedBody);
      case 'PATCH':
        return _httpClient.patch(
          uri,
          headers: requestHeaders,
          body: encodedBody,
        );
      case 'DELETE':
        return _httpClient.delete(uri, headers: requestHeaders);
      default:
        return _httpClient.get(uri, headers: requestHeaders);
    }
  }

  // ---------------------------------------------------------------------------
  // Internal: success/error handling for single object
  // ---------------------------------------------------------------------------
  Future<T> _processResponse<T>(
    http.Response response,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final statusCode = response.statusCode;

    if (statusCode == 200 || statusCode == 201) {
      if (response.body.isEmpty) {
        return fromJson(<String, dynamic>{});
      }
      if (response.bodyBytes.length > 10000) {
        return await compute(
          jsonDecode,
          response.body,
        ).then((data) => fromJson(data));
      } else {
        return fromJson(jsonDecode(response.body));
      }
    }

    _throwForStatus(response);
    throw ApiException(message: 'Unreachable', statusCode: statusCode);
  }

  void _throwForStatus(http.Response response) {
    final errorMessage = _extractErrorMessage(response);
    final datas = _extractErrorData(response);
    final statusCode = response.statusCode;

    notificationAlert('Status: $statusCode $errorMessage');
    throw ApiException(
      message: errorMessage,
      statusCode: statusCode,
      data: datas,
    );
  }

  String _extractErrorMessage(http.Response response) {
    try {
      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data.containsKey('message')) {
        return data['message'].toString();
      } else if (data['errors'] != null &&
          data['errors'] is Map &&
          data['errors']?['message'] != null) {
        return data['errors']?['message'].toString() ?? '';
      }
      return 'An unknown error occurred.';
    } catch (e) {
      return 'Unable to parse error response.';
    }
  }

  dynamic _extractErrorData(http.Response response) {
    try {
      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data.containsKey('data')) {
        return data['data'];
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  void closeClient() {
    _httpClient.close();
  }
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  ApiException({required this.message, this.statusCode, this.data});

  @override
  String toString() {
    return 'ApiException: $message (Status: ${statusCode ?? 'Unknown'})';
  }
}
