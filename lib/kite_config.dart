// Kite API Configuration
class KiteConfig {
  // Inject at build time via --dart-define to avoid exposing secrets in the bundle.
  static const String apiKey = String.fromEnvironment('KITE_API_KEY', defaultValue: '');
  static const String apiSecret = String.fromEnvironment('KITE_API_SECRET', defaultValue: '');

  // Redirect URI for OAuth callback - use custom domain
  static const String redirectUri = 'https://www.thegreatbulls.in/auth/callback';

  static const String kiteLoginUrl = 'https://kite.zerodha.com/connect/login';
  static const String kiteApiUrl = 'https://api.kite.trade';
  static const String appName = 'TheGreatbulls';
  static const String clientId = 'ZLE384';

  // AWS API Gateway for token exchange
  static const String tokenExchangeUrl = 'https://s23gqm7047.execute-api.ap-south-1.amazonaws.com/prod/token';
}