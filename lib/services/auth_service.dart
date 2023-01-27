import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService extends ChangeNotifier {
  final String _baseUrl = 'identitytoolkit.googleapis.com';
  final String _firebaseToken = 'AIzaSyC9wK29em2PLlEop4WnjLPWRSePG7iBC_4';

  final storage = FlutterSecureStorage();

  // Únicamente retorna algo si hubo algún error, de lo contrario se almacena el token pero no retorna nada.
  Future<String?> createUser(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true,
    };

    final url = Uri.https(_baseUrl, '/v1/accounts:signUp', {
      'key': _firebaseToken,
    });

    final response = await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> decodedData = json.decode(response.body);

    if (decodedData.containsKey('idToken')) {
      // El token hay que guardarlo en un lugar seguro
      storage.write(key: 'token', value: decodedData['idToken']);
      return null;
    }

    return decodedData['error']['message'];
  }

  // Únicamente retorna algo si hubo algún error, de lo contrario se almacena el token pero no retorna nada.
  Future<String?> login(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true,
    };

    final url = Uri.https(_baseUrl, '/v1/accounts:signInWithPassword', {
      'key': _firebaseToken,
    });

    final response = await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> decodedData = json.decode(response.body);

    if (decodedData.containsKey('idToken')) {
      // El token hay que guardarlo en un lugar seguro
      storage.write(key: 'token', value: decodedData['idToken']);
      return null;
    }

    return decodedData['error']['message'];
  }

  Future logout() async {
    storage.delete(key: 'token');
    return;
  }

  Future<String> readToken() async {
    return await storage.read(key: 'token') ?? '';
  }
}
