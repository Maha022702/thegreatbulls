import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KiteConfig {
  static const String apiKey = '04iqs9xlhundtdyd';
  static const String apiSecret = 'gcpzn0tiet9mfh833c4pat2ibcb5wgce';
  static const String kiteApiUrl = 'https://api.kite.trade';
}

class KiteService {
  static const String _accessTokenKey = 'access_token';
  static const String _publicTokenKey = 'public_token';

  // Direct login with username and password
  static Future<Map<String, dynamic>?> login(String username, String password, String pin) async {
    try {
      print('🔐 Starting direct login for user: $username');

      // Step 1: Get login session
      final sessionResponse = await http.post(
        Uri.parse('${KiteConfig.kiteApiUrl}/session/token'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'X-Kite-Version': '3',
        },
        body: 'api_key=${KiteConfig.apiKey}&user_id=$username&password=$password&pin=$pin',
      );

      print('Session response status: ${sessionResponse.statusCode}');
      print('Session response body: ${sessionResponse.body}');

      if (sessionResponse.statusCode == 200) {
        final sessionData = json.decode(sessionResponse.body);
        if (sessionData['status'] == 'success') {
          final requestToken = sessionData['data']['request_token'];

          // Step 2: Exchange request token for access token
          final checksum = _generateChecksum(requestToken);
          print('Generated checksum: $checksum');

          final tokenResponse = await http.post(
            Uri.parse('${KiteConfig.kiteApiUrl}/session/token'),
            headers: {
              'Content-Type': 'application/x-www-form-urlencoded',
              'X-Kite-Version': '3',
            },
            body: 'api_key=${KiteConfig.apiKey}&request_token=$requestToken&checksum=$checksum',
          );

          print('Token exchange status: ${tokenResponse.statusCode}');
          print('Token exchange body: ${tokenResponse.body}');

          if (tokenResponse.statusCode == 200) {
            final tokenData = json.decode(tokenResponse.body);
            if (tokenData['status'] == 'success') {
              final accessToken = tokenData['data']['access_token'];
              final publicToken = tokenData['data']['public_token'];

              // Store tokens
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString(_accessTokenKey, accessToken);
              await prefs.setString(_publicTokenKey, publicToken);

              print('✅ Login successful! Access token stored.');
              return tokenData['data'];
            }
          }
        }
      }

      print('❌ Login failed');
      return null;
    } catch (e) {
      print('❌ Login error: $e');
      return null;
    }
  }

  // Generate SHA256 checksum
  static String _generateChecksum(String requestToken) {
    final data = '${KiteConfig.apiKey}$requestToken${KiteConfig.apiSecret}';
    final bytes = utf8.encode(data);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Get stored access token
  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null;
  }

  // Logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_publicTokenKey);
  }

  // Get user profile
  static Future<Map<String, dynamic>?> getUserProfile() async {
    final accessToken = await getAccessToken();
    if (accessToken == null) return null;

    try {
      print('getUserProfile: Making API call');
      final response = await http.get(
        Uri.parse('${KiteConfig.kiteApiUrl}/user/profile'),
        headers: {
          'Authorization': 'token ${KiteConfig.apiKey}:$accessToken',
          'X-Kite-Version': '3',
        },
      );

      print('getUserProfile: Response status: ${response.statusCode}');
      print('getUserProfile: Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('getUserProfile: Successfully parsed data');
        return data;
      } else {
        print('Error getting user profile: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error in getUserProfile: $e');
      return null;
    }
  }

  // Get orders
  static Future<Map<String, dynamic>?> getOrders() async {
    final accessToken = await getAccessToken();
    if (accessToken == null) return null;

    try {
      print('getOrders: Making API call');
      final response = await http.get(
        Uri.parse('${KiteConfig.kiteApiUrl}/orders'),
        headers: {
          'Authorization': 'token ${KiteConfig.apiKey}:$accessToken',
          'X-Kite-Version': '3',
        },
      );

      print('getOrders: Response status: ${response.statusCode}');
      print('getOrders: Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('getOrders: Successfully parsed data');
        return data;
      } else {
        print('Error getting orders: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error in getOrders: $e');
      return null;
    }
  }

  // Get positions
  static Future<Map<String, dynamic>?> getPositions() async {
    final accessToken = await getAccessToken();
    if (accessToken == null) return null;

    try {
      print('getPositions: Making API call');
      final response = await http.get(
        Uri.parse('${KiteConfig.kiteApiUrl}/portfolio/positions'),
        headers: {
          'Authorization': 'token ${KiteConfig.apiKey}:$accessToken',
          'X-Kite-Version': '3',
        },
      );

      print('getPositions: Response status: ${response.statusCode}');
      print('getPositions: Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('getPositions: Successfully parsed data');
        return data;
      } else {
        print('Error getting positions: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error in getPositions: $e');
      return null;
    }
  }

  // Get holdings
  static Future<Map<String, dynamic>?> getHoldings() async {
    final accessToken = await getAccessToken();
    if (accessToken == null) return null;

    try {
      print('getHoldings: Making API call');
      final response = await http.get(
        Uri.parse('${KiteConfig.kiteApiUrl}/portfolio/holdings'),
        headers: {
          'Authorization': 'token ${KiteConfig.apiKey}:$accessToken',
          'X-Kite-Version': '3',
        },
      );

      print('getHoldings: Response status: ${response.statusCode}');
      print('getHoldings: Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('getHoldings: Successfully parsed data');
        return data;
      } else {
        print('Error getting holdings: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error in getHoldings: $e');
      return null;
    }
  }

  // Get margins
  static Future<Map<String, dynamic>?> getMargins() async {
    final accessToken = await getAccessToken();
    if (accessToken == null) return null;

    try {
      print('getMargins: Making API call');
      final response = await http.get(
        Uri.parse('${KiteConfig.kiteApiUrl}/user/margins'),
        headers: {
          'Authorization': 'token ${KiteConfig.apiKey}:$accessToken',
          'X-Kite-Version': '3',
        },
      );

      print('getMargins: Response status: ${response.statusCode}');
      print('getMargins: Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('getMargins: Successfully parsed data');
        return data;
      } else {
        print('Error getting margins: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error in getMargins: $e');
      return null;
    }
  }

  // Get instruments
  static Future<Map<String, dynamic>?> getInstruments([String exchange = 'NSE']) async {
    try {
      print('getInstruments: Making API call for $exchange');
      final response = await http.get(
        Uri.parse('${KiteConfig.kiteApiUrl}/instruments/$exchange'),
        headers: {
          'X-Kite-Version': '3',
        },
      );

      print('getInstruments: Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        // This returns CSV data, not JSON
        print('getInstruments: Successfully got instruments data');
        return {'data': response.body, 'exchange': exchange};
      } else {
        print('Error getting instruments: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error in getInstruments: $e');
      return null;
    }
  }

  // Get market data (quote)
  static Future<Map<String, dynamic>?> getQuote(String instrument) async {
    final accessToken = await getAccessToken();
    if (accessToken == null) return null;

    try {
      print('getQuote: Making API call for $instrument');
      final response = await http.get(
        Uri.parse('${KiteConfig.kiteApiUrl}/quote?i=$instrument'),
        headers: {
          'Authorization': 'token ${KiteConfig.apiKey}:$accessToken',
          'X-Kite-Version': '3',
        },
      );

      print('getQuote: Response status: ${response.statusCode}');
      print('getQuote: Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('getQuote: Successfully parsed data');
        return data;
      } else {
        print('Error getting quote: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error in getQuote: $e');
      return null;
    }
  }
}