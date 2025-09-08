enum TokenType {
  accessToken('accessToken'),
  refreshToken('refreshToken');

  final String key;
  const TokenType(this.key);
}