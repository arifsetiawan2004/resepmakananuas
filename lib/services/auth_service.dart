import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:resepmakanan/Models/response_model.dart';
import 'package:resepmakanan/services/session_service.dart';

const String baseUrl = "https://recipe.incube.id/api";

class AuthService {
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(Uri.parse("$baseUrl/login"),
        body: {'email': email, 'password': password});

    if (response.statusCode == 200) {
      ResponseModel res = ResponseModel.fromJson(jsonDecode(response.body));

      SessionService _sessionService = SessionService();
      _sessionService.saveToken(res.data['token']);
      _sessionService.saveUser("${res.data['user']['id']}",
          res.data['user']['name'], res.data['user']['email']);
      // print(res.data['token']);
      return {'status': true, 'message': res.message};
    } else {
      return {'status': false, 'message': 'GAGAL LOGIN'};
    }
  }

  Future<Map<String, dynamic>> register(
      String name, String email, String password) async {
    final response = await http.post(Uri.parse("$baseUrl/register"),
        body: {'name': name, 'email': email, 'password': password});
    if (response.statusCode == 201) {
      ResponseModel res = ResponseModel.fromJson(jsonDecode(response.body));
      return {'status': true, 'message': res.message};
    } else {
      return {'status': false, 'message': 'GAGAL REGISTER'};
    }
  }
}
