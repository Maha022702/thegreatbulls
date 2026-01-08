// Kite API Configuration
class KiteConfig {
  static const String apiKey = 'j3xfcw2nl5v4lx3v';
  static const String apiSecret = 'd2jx1v3z138wb51njixjy4vtq55otooj';
  
  // Redirect URI for OAuth callback - use custom domain
  static const String redirectUri = 'https://www.thegreatbulls.in/auth/callback';
  
  static const String kiteLoginUrl = 'https://kite.zerodha.com/connect/login';
  static const String kiteApiUrl = 'https://api.kite.trade';
  static const String appName = 'TheGreatbulls';
  static const String clientId = 'ZLE384';
  
  // AWS API Gateway for token exchange
  static const String tokenExchangeUrl = 'https://s23gqm7047.execute-api.ap-south-1.amazonaws.com/prod/token';
}