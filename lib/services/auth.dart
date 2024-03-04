import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

String urlApi = 'http://192.168.0.108';

class AuthService {
  static Future<bool> checkToken() async {
    String? token = await getToken();
    if (token != null && token.isNotEmpty) {
      return await verifyTokenValidity(token);
    } else {
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
        return true;
      } else {
        return false;
      }
    } catch (e) {
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
        return response;
      } else {
        return response;
      }
    } catch (e) {
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
          return response.data;
        } else {
          return {
            'status': 'error',
            'msg': 'Failed to store data. Status code: ${response.statusCode}'
          };
        }
      } catch (error) {
        return {'status': 'error', 'msg': 'Error storing data: $error'};
      }
    } else {
      return {
        'status': 'error',
        'msg': 'Token not found. User is not logged in.'
      };
    }
  }
}
