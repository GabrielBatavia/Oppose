import 'dart:async';
import 'dart:convert';
import 'dart:io';

typedef BackendTransport =
    Future<BackendApiResponse> Function(BackendApiRequest request);

class BackendApiClient {
  const BackendApiClient({
    this.baseUrl = 'http://localhost:4000',
    this.devUserId,
    this.transport,
  });

  final String baseUrl;
  final String? devUserId;
  final BackendTransport? transport;

  Map<String, String> get devAuthHeaders {
    final userId = devUserId;
    if (userId == null || userId.isEmpty) return const {};
    return {'x-dev-user-id': userId};
  }

  Future<Map<String, dynamic>> get(
    String path, {
    bool requiresDevAuth = false,
  }) {
    return request('GET', path, requiresDevAuth: requiresDevAuth);
  }

  Future<Map<String, dynamic>> patch(
    String path, {
    required Map<String, dynamic> body,
    bool requiresDevAuth = false,
  }) {
    return request('PATCH', path, body: body, requiresDevAuth: requiresDevAuth);
  }

  Future<Map<String, dynamic>> post(
    String path, {
    required Map<String, dynamic> body,
    bool requiresDevAuth = false,
  }) {
    return request('POST', path, body: body, requiresDevAuth: requiresDevAuth);
  }

  Future<Map<String, dynamic>> request(
    String method,
    String path, {
    Map<String, dynamic>? body,
    bool requiresDevAuth = false,
  }) async {
    final headers = <String, String>{
      'accept': 'application/json',
      if (body != null) 'content-type': 'application/json',
      if (requiresDevAuth) ...devAuthHeaders,
    };
    final request = BackendApiRequest(
      method: method,
      uri: Uri.parse('${baseUrl.replaceFirst(RegExp(r'/$'), '')}$path'),
      headers: headers,
      body: body,
    );

    final response = await (transport ?? _ioTransport).call(request);
    final decoded = response.body.isEmpty
        ? <String, dynamic>{}
        : jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final error = decoded['error'];
      if (error is Map<String, dynamic>) {
        throw BackendApiException(
          statusCode: response.statusCode,
          code: error['code'] as String? ?? 'BACKEND_ERROR',
          message: error['message'] as String? ?? 'Backend request failed.',
          details: error['details'],
        );
      }
      throw BackendApiException(
        statusCode: response.statusCode,
        code: 'BACKEND_ERROR',
        message: 'Backend request failed.',
      );
    }

    return decoded;
  }

  static Future<BackendApiResponse> _ioTransport(
    BackendApiRequest request,
  ) async {
    final client = HttpClient();
    try {
      final httpRequest = await client
          .openUrl(request.method, request.uri)
          .timeout(const Duration(seconds: 10));
      for (final entry in request.headers.entries) {
        httpRequest.headers.set(entry.key, entry.value);
      }
      final body = request.body;
      if (body != null) {
        httpRequest.write(jsonEncode(body));
      }

      final response = await httpRequest.close().timeout(
        const Duration(seconds: 10),
      );
      final responseBody = await response.transform(utf8.decoder).join();
      return BackendApiResponse(
        statusCode: response.statusCode,
        body: responseBody,
      );
    } on TimeoutException {
      throw const BackendApiException(
        statusCode: 0,
        code: 'NETWORK_TIMEOUT',
        message: 'Could not connect. Try again.',
      );
    } on SocketException {
      throw const BackendApiException(
        statusCode: 0,
        code: 'NETWORK_UNAVAILABLE',
        message: 'Could not connect. Try again.',
      );
    } finally {
      client.close(force: true);
    }
  }
}

class BackendApiRequest {
  const BackendApiRequest({
    required this.method,
    required this.uri,
    required this.headers,
    this.body,
  });

  final String method;
  final Uri uri;
  final Map<String, String> headers;
  final Map<String, dynamic>? body;
}

class BackendApiResponse {
  const BackendApiResponse({required this.statusCode, required this.body});

  final int statusCode;
  final String body;
}

class BackendApiException implements Exception {
  const BackendApiException({
    required this.statusCode,
    required this.code,
    required this.message,
    this.details,
  });

  final int statusCode;
  final String code;
  final String message;
  final Object? details;

  @override
  String toString() => 'BackendApiException($statusCode, $code, $message)';
}
