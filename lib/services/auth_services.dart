import 'dart:convert';
import 'package:guest_ms/services/api.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {

  Future<Map<String, dynamic>> register(String name, String email, String password, String passwordConfirmation) async {
    final response = await http.post(
      Uri.parse(ApiServices().baseUrl+ApiServices().register),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
      }),
    );

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(ApiServices().baseUrl + ApiServices().login),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    final Map<String, dynamic> responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      // Save user details and token to SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', responseData['token']);
      await prefs.setInt('user_id', responseData['user']['id']);
      await prefs.setString('user_name', responseData['user']['name']);
      await prefs.setString('user_email', responseData['user']['email']);
    }

    return responseData;
  }
  Future<void> logout(String token) async {
    await http.post(
      Uri.parse(ApiServices().baseUrl+ApiServices().logout),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }

    Future<List<dynamic>> fetchUserBookings(String token) async {
    final response = await http.get(Uri.parse(ApiServices().baseUrl+ApiServices().userBookings), 
    headers: <String, String>{
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load user bookings');
    }
  }

}
