import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static Future<bool> checkToken() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = await getToken();
    if (token != null && token.isNotEmpty) {
      // Token exists, check its validity
      return await verifyTokenValidity(token);
    } else {
      // No token found, consider it invalid
      return false;
    }
  }

  static Future<bool> verifyTokenValidity(String token) async {
    Dio dio = Dio();
    String url = 'http://10.0.2.2/system-PAMSIMAS/api/checkToken';

    try {
      Response response = await dio.request(
        url,
        options: Options(
          method: 'POST',
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        // Token is valid
        return true;
      } else {
        // Invalid token
        return false;
      }
    } catch (e) {
      // Error occurred during token verification
      print('Error verifying token: $e');
      return false;
    }
  }

  static Future getUserDetail(String token) async {
    Dio dio = Dio();
    String url = 'http://10.0.2.2/system-PAMSIMAS/api/checkToken';

    try {
      Response response = await dio.request(
        url,
        options: Options(
          method: 'POST',
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        // Token is valid
        return response;
      } else {
        // Invalid token
        return response;
      }
    } catch (e) {
      // Error occurred during token verification
      print('Error verifying token: $e');
      return false;
    }
  }

  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      Dio dio = Dio();
      String url = 'http://10.0.2.2/system-PAMSIMAS/api/login';
      Response response = await dio.post(
        url,
        data: {'email': email, 'password': password},
      );

      return response.data;
    } catch (error) {
      print('Error logging in: $error');
      return {'message': 'Failed to login'};
    }
  }

  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    return token;
  }

  static Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  static Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}
