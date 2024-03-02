import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

String urlApi = 'http://192.168.0.108';

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
    String url = '$urlApi/system-PAMSIMAS/api/checkToken';

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
      // print('Error verifying token: $e');
      return false;
    }
  }

  static Future getUserDetail(String token) async {
    Dio dio = Dio();
    String url = '$urlApi/system-PAMSIMAS/api/checkToken';

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
      // print('Error verifying token: $e');
      return false;
    }
  }

  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    try {
      Dio dio = Dio();
      String url = '$urlApi/system-PAMSIMAS/api/login';
      Response response = await dio.post(
        url,
        data: {'email': email, 'password': password},
        options: Options(
          sendTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 60),
        ),
      );

      return response.data;
    } catch (error) {
      // print('Error logging in: $error');
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

  static Future<Map<String, dynamic>> storeData(
      String resultScan, String dataPemakaian) async {
    String? token = await getToken();

    if (token != null) {
      Dio dio = Dio();
      String url = '$urlApi/system-PAMSIMAS/api/penggunaan/store';

      try {
        Response response = await dio.post(
          url,
          data: {
            'nomor_meteran': resultScan,
            'pemakaian': dataPemakaian,
          },
          options: Options(
            headers: {'Authorization': 'Bearer $token'},
          ),
        );

        if (response.statusCode == 200) {
          // Check response status
          return response.data;
        } else {
          // Handle non-200 status codes
          return {
            'status': 'error',
            'msg': 'Failed to store data. Status code: ${response.statusCode}'
          };
        }
      } catch (error) {
        // Handle error
        // print('Error storing data: $error');
        return {'status': 'error', 'msg': 'Error storing data: $error'};
      }
    } else {
      // Handle token not found
      // print('Token not found. User is not logged in.');
      return {
        'status': 'error',
        'msg': 'Token not found. User is not logged in.'
      };
    }
  }
}
