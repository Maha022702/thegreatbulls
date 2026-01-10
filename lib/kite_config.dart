// Kite API Configuration
class KiteConfig {
  // Inject at build time via --dart-define to avoid exposing secrets in the bundle.
  // Defaults fall back to existing app keys so login works out of the box; override via --dart-define in prod.
  static const String apiKey = String.fromEnvironment('KITE_API_KEY', defaultValue: 'j3xfcw2nl5v4lx3v');
  static const String apiSecret = String.fromEnvironment('KITE_API_SECRET', defaultValue: 'd2jx1v3z138wb51njixjy4vtq55otooj');
  static const String chartBackendUrl = String.fromEnvironment(
    'KITE_CHART_BACKEND_URL',
    // Default to Vercel function proxy; override with full URL if hosted elsewhere.
    defaultValue: '/api/kite',
  );

  // Redirect URI for OAuth callback - use custom domain
  static const String redirectUri = 'https://www.thegreatbulls.in/auth/callback';

  static const String kiteLoginUrl = 'https://kite.zerodha.com/connect/login';
  static const String kiteApiUrl = 'https://api.kite.trade';
  static const String appName = 'TheGreatbulls';
  static const String clientId = 'ZLE384';

  // AWS API Gateway for token exchange
  static const String tokenExchangeUrl = 'https://s23gqm7047.execute-api.ap-south-1.amazonaws.com/prod/token';
}