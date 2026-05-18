abstract class AnalyticsService {
  Future<void> track(String eventName, Map<String, Object?> properties);
}

class NoopAnalyticsService implements AnalyticsService {
  const NoopAnalyticsService();

  @override
  Future<void> track(String eventName, Map<String, Object?> properties) async {}
}
