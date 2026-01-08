import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'dart:html' as html show window;
import 'package:crypto/crypto.dart';
import 'kite_config.dart';

class KiteOAuthService {
  static const String _accessTokenKey = 'access_token';
  static const String _publicTokenKey = 'public_token';
  static const String _userIdKey = 'user_id';
  static const String _loginTimeKey = 'login_time';
  static const String _apiKeyVersionKey = 'api_key_version';

  // Web storage
  static Map<String, String> _webStorage = {};

  // Initialize web storage from localStorage
  static void _initWebStorage() {
    if (kIsWeb) {
      try {
        final keys = [_accessTokenKey, _publicTokenKey, _userIdKey, _loginTimeKey, _apiKeyVersionKey];
        for (final key in keys) {
          if (html.window.localStorage.containsKey(key)) {
            _webStorage[key] = html.window.localStorage[key]!;
          }
        }
        print('Initialized web storage from localStorage');
      } catch (e) {
        print('Failed to initialize web storage: $e');
      }
    }
  }

  // Save to storage
  static Future<void> _setString(String key, String value) async {
    _webStorage[key] = value;
    if (kIsWeb) {
      try {
        html.window.localStorage[key] = value;
        print('Saved to localStorage: $key');
      } catch (e) {
        print('Failed to save to localStorage: $e');
      }
    }
  }

  // Get from storage
  static Future<String?> _getString(String key) async {
    if (kIsWeb) {
      try {
        if (html.window.localStorage.containsKey(key)) {
          return html.window.localStorage[key];
        }
      } catch (e) {
        print('Failed to read from localStorage: $e');
      }
    }
    return _webStorage[key];
  }

  // Remove from storage
  static Future<void> _remove(String key) async {
    _webStorage.remove(key);
    if (kIsWeb) {
      try {
        html.window.localStorage.remove(key);
      } catch (e) {
        print('Failed to remove from localStorage: $e');
      }
    }
  }

  // Get login URL
  static String getLoginUrl() {
    final state = DateTime.now().millisecondsSinceEpoch.toString();
    final redirectUri = Uri.encodeComponent(KiteConfig.redirectUri);
    return '${KiteConfig.kiteLoginUrl}?v=3&api_key=${KiteConfig.apiKey}&redirect_uri=$redirectUri&state=$state';
  }

  // Exchange request token for access token via AWS Lambda (bypasses CORS)
  static Future<Map<String, dynamic>?> exchangeCodeForToken(String requestToken) async {
    try {
      print('Exchanging request token via AWS Lambda...');
      print('Request Token: $requestToken');
      print('Lambda URL: ${KiteConfig.tokenExchangeUrl}');

      final response = await http.post(
        Uri.parse(KiteConfig.tokenExchangeUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'request_token': requestToken,
        }),
      );

      print('Lambda response: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'success') {
          final accessToken = data['data']['access_token'];
          final publicToken = data['data']['public_token'];
          final userId = data['data']['user_id'];

          print('Token exchange successful!');
          print('User ID: $userId');

          // Save tokens
          await _saveTokens(accessToken, publicToken, userId);

          return {
            'access_token': accessToken,
            'public_token': publicToken,
            'user_id': userId,
          };
        } else {
          print('Token exchange failed: ${data['message']}');
          return null;
        }
      } else {
        print('Token exchange HTTP error: ${response.statusCode}');
        print('Error response: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Token exchange error: $e');
      return null;
    }
  }

  // API call helper - direct to Kite API
  static Future<Map<String, dynamic>?> _apiGet(String endpoint) async {
    final accessToken = await _getAccessToken();
    if (accessToken == null) {
      print('No access token available');
      return null;
    }

    try {
      final url = '${KiteConfig.kiteApiUrl}$endpoint';
      print('Calling Kite API: $url');
      
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'token ${KiteConfig.apiKey}:$accessToken',
          'X-Kite-Version': '3',
        },
      );

      print('API Response: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      print('API Error: ${response.body}');
      return null;
    } catch (e) {
      print('API Error for $endpoint: $e');
      return null;
    }
  }

  // API call helper for POST requests - direct to Kite API
  static Future<Map<String, dynamic>?> _apiPost(String endpoint, Map<String, dynamic> data) async {
    final accessToken = await _getAccessToken();
    if (accessToken == null) {
      print('No access token available');
      return null;
    }

    try {
      final url = '${KiteConfig.kiteApiUrl}$endpoint';
      print('POST to Kite API: $url');
      print('Data: $data');
      
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'token ${KiteConfig.apiKey}:$accessToken',
          'Content-Type': 'application/json',
          'X-Kite-Version': '3',
        },
        body: json.encode(data),
      );

      print('POST Response: ${response.statusCode}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      }
      print('POST Error: ${response.body}');
      return null;
    } catch (e) {
      print('POST Error for $endpoint: $e');
      return null;
    }
  }

  // Get user profile
  static Future<Map<String, dynamic>?> getUserProfile() async {
    return await _apiGet('/user/profile');
  }

  // Get margins
  static Future<Map<String, dynamic>?> getMargins() async {
    return await _apiGet('/user/margins');
  }

  // Get holdings
  static Future<Map<String, dynamic>?> getHoldings() async {
    return await _apiGet('/portfolio/holdings');
  }

  // Get orders
  static Future<Map<String, dynamic>?> getOrders() async {
    return await _apiGet('/orders');
  }

  // Place an order
  static Future<Map<String, dynamic>?> placeOrder({
    required String variety,
    required String exchange,
    required String tradingsymbol,
    required String transactionType, // BUY or SELL
    required String orderType, // MARKET, LIMIT, SL, SL-M
    required String product, // CNC, MIS, NRML
    required int quantity,
    double? price,
    double? triggerPrice,
  }) async {
    final orderData = {
      'variety': variety,
      'exchange': exchange,
      'tradingsymbol': tradingsymbol,
      'transaction_type': transactionType,
      'order_type': orderType,
      'product': product,
      'quantity': quantity,
    };

    if (price != null) orderData['price'] = price;
    if (triggerPrice != null) orderData['trigger_price'] = triggerPrice;

    return await _apiPost('/orders/$variety', orderData);
  }

  // Modify an order
  static Future<Map<String, dynamic>?> modifyOrder({
    required String variety,
    required String orderId,
    int? quantity,
    double? price,
    double? triggerPrice,
    String? orderType,
  }) async {
    final updateData = <String, dynamic>{};
    if (quantity != null) updateData['quantity'] = quantity;
    if (price != null) updateData['price'] = price;
    if (triggerPrice != null) updateData['trigger_price'] = triggerPrice;
    if (orderType != null) updateData['order_type'] = orderType;

    return await _apiPost('/orders/$variety/$orderId', updateData);
  }

  // Cancel an order
  static Future<Map<String, dynamic>?> cancelOrder(String variety, String orderId) async {
    final accessToken = await _getAccessToken();
    if (accessToken == null) return null;

    try {
      final url = '${KiteConfig.kiteApiUrl}/orders/$variety/$orderId';
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Authorization': 'token ${KiteConfig.apiKey}:$accessToken',
          'X-Kite-Version': '3',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      print('Cancel order error: ${response.body}');
      return null;
    } catch (e) {
      print('Cancel order error: $e');
      return null;
    }
  }

  // Get positions
  static Future<Map<String, dynamic>?> getPositions() async {
    return await _apiGet('/portfolio/positions');
  }

  // Get market quotes
  static Future<Map<String, dynamic>?> getQuote(String instruments) async {
    final accessToken = await _getAccessToken();
    if (accessToken == null) return null;

    try {
      final url = '${KiteConfig.kiteApiUrl}/quote?i=$instruments';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'token ${KiteConfig.apiKey}:$accessToken',
          'X-Kite-Version': '3',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      print('Quote error: $e');
      return null;
    }
  }

  // Get instruments
  static Future<String?> getInstruments(String exchange) async {
    try {
      final url = '${KiteConfig.kiteApiUrl}/instruments/$exchange';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return response.body;
      }
      return null;
    } catch (e) {
      print('Instruments error: $e');
      return null;
    }
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    _initWebStorage();
    final accessToken = await _getAccessToken();
    final storedApiKeyVersion = await _getString(_apiKeyVersionKey);
    
    // If no token, not logged in
    if (accessToken == null) {
      print('Login status - Access Token exists: false');
      return false;
    }
    
    // Check if API key has changed - if so, force logout
    if (storedApiKeyVersion != KiteConfig.apiKey) {
      print('⚠️ API KEY CHANGED! Stored: $storedApiKeyVersion, Current: ${KiteConfig.apiKey}');
      print('🔄 AUTO-CLEARING OLD TOKENS...');
      await logout();
      return false;
    }
    
    print('Login status - Access Token exists: true');
    return true;
  }

  // Logout
  static Future<void> logout() async {
    try {
      final accessToken = await _getAccessToken();
      
      // Call Kite API to invalidate token
      if (accessToken != null) {
        final url = '${KiteConfig.kiteApiUrl}/session/token';
        final response = await http.delete(
          Uri.parse(url),
          headers: {
            'Authorization': 'token ${KiteConfig.apiKey}:$accessToken',
            'X-Kite-Version': '3',
          },
        );
        
        if (response.statusCode == 200) {
          print('✅ Session invalidated on Kite');
        } else {
          print('⚠️ Kite logout error: ${response.body}');
        }
      }
    } catch (e) {
      print('⚠️ Logout API call failed: $e');
    } finally {
      // Always clear local storage regardless of API response
      await _remove(_accessTokenKey);
      await _remove(_publicTokenKey);
      await _remove(_userIdKey);
      await _remove(_loginTimeKey);
      await _remove(_apiKeyVersionKey);
      print('🔓 Logged out - all tokens cleared from localStorage');
    }
  }

  // Debug methods
  static Future<void> setTestTokensForDebug(String accessToken, String publicToken) async {
    await _saveTokens(accessToken, publicToken, 'test_user');
  }

  static Future<String?> getAccessTokenForDebug() async {
    return await _getAccessToken();
  }

  static Future<String?> getPublicTokenForDebug() async {
    return await _getString(_publicTokenKey);
  }

  // Private methods
  static Future<void> _saveTokens(String accessToken, String publicToken, String userId) async {
    await _setString(_accessTokenKey, accessToken);
    await _setString(_publicTokenKey, publicToken);
    await _setString(_userIdKey, userId);
    await _setString(_loginTimeKey, DateTime.now().toIso8601String());
    await _setString(_apiKeyVersionKey, KiteConfig.apiKey); // Store which API key was used
    print('Tokens saved successfully with API key: ${KiteConfig.apiKey}');
  }

  static Future<String?> _getAccessToken() async {
    return await _getString(_accessTokenKey);
  }
}
