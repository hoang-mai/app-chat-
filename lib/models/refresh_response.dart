class RefreshResponse {
  late final String accessToken;
  late final int expiresIn;
  late final String refreshToken;
  late final int refreshExpiresIn;
  late final String tokenType;
  late final String sessionState;
  late final String scope;
  RefreshResponse({
    required this.accessToken,
    required this.expiresIn,
    required this.refreshToken,
    required this.refreshExpiresIn,
    required this.tokenType,
    required this.sessionState,
    required this.scope,
  });
  factory RefreshResponse.fromJson(Map<String, dynamic> json) {
    return RefreshResponse(
      accessToken: json['accessToken'] as String,
      expiresIn: json['expiresIn'] as int,
      refreshToken: json['refreshToken'] as String,
      refreshExpiresIn: json['refreshExpiresIn'] as int,
      tokenType: json['tokenType'] as String,
      sessionState: json['sessionState'] as String,
      scope: json['scope'] as String,
    );
  }
}
