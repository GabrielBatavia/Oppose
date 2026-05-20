import '../../types/domain_models.dart';

OpposeUser opposeUserFromJson(Map<String, dynamic> json) {
  return OpposeUser(
    id: json['id'] as String,
    username: json['username'] as String,
    displayName: json['displayName'] as String,
    avatarAsset: json['avatarUrl'] as String?,
    language: json['language'] as String? ?? 'en',
    interests: [
      for (final interest in (json['interests'] as List<dynamic>? ?? const []))
        interest as String,
    ],
  );
}
