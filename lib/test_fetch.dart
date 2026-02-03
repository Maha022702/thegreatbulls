import 'dart:convert';
import 'dart:js_util' as js_util;
import 'package:http/http.dart' as http;

Future<void> testFetch() async {
  try {
    print('Starting fetch test...');
    var fetch = js_util.getProperty(js_util.globalThis, 'fetch');
    if (fetch == null) {
      print('fetch is not available, falling back to http');
      await fallbackHttp();
      return;
    }
    var promise = js_util.callMethod(js_util.globalThis, 'fetch', ['https://api.github.com/zen']);
    var response = await js_util.promiseToFuture(promise);
    print('Response received: $response');
    try {
      var ok = js_util.getProperty(response, 'ok');
      var status = js_util.getProperty(response, 'status');
      print('ok: $ok, status: $status');
      if (ok == true) {
        var textPromise = js_util.callMethod(response, 'text', []);
        var textData = await js_util.promiseToFuture(textPromise);
        print('Text data: $textData');
      }
    } catch (e) {
      print('Error getting property: $e');
      // Fallback to http if getProperty fails
      await fallbackHttp();
      return;
    }
  } catch (e) {
    print('Error during fetch test: $e');
    // Fallback to http
    await fallbackHttp();
  }
}

Future<void> fallbackHttp() async {
  try {
    print('Using http package fallback');
    var response = await http.get(Uri.parse('https://api.github.com/zen'));
    print('Http response: ${response.statusCode}');
    if (response.statusCode == 200) {
      var decoded = utf8.decode(response.bodyBytes);
      print('Decoded response: $decoded');
    }
  } catch (e) {
    print('Http also failed: $e');
  }
}