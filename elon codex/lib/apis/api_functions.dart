import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> customPostRequest({
  required String url,
  required Map<String, dynamic> body,
  Map<String, String>? headers,
}) async {
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: headers ??
          {
            'Content-Type': 'application/json',
          },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return {
        'status': 'success',
        'data': jsonDecode(response.body),
      };
    } else {
      return {
        'status': 'error',
        'message': 'Failed with status code ${response.statusCode}',
        'body': jsonDecode(response.body),
      };
    }
  } on SocketException {
    return {
      'status': 'error',
      'message': 'No internet connection. Please check your connection.',
    };
  } on HttpException catch (e) {
    return {
      'status': 'error',
      'message': 'HTTP exception occurred: ${e.message}',
    };
  } catch (e) {
    return {
      'status': 'error',
      'message': 'An unexpected error occurred: $e',
    };
  }
}
