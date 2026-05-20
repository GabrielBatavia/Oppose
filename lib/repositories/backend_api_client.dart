class BackendApiClient {
  const BackendApiClient({
    this.baseUrl = 'http://localhost:4000',
    this.devUserId,
  });

  final String baseUrl;
  final String? devUserId;

  Map<String, String> get devAuthHeaders {
    final userId = devUserId;
    if (userId == null || userId.isEmpty) return const {};
    return {'x-dev-user-id': userId};
  }
}
