//lib/services/auth_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class AuthProvider with ChangeNotifier {
  final String _baseUrl = 'https://adamix.net/medioambiente';
  bool _estainiciadasesion = false;
  String? _token;
  Map<String, dynamic>? _datosusuario;

  bool get estainiciadasesion => _estainiciadasesion;
  String? get token => _token;
  Map<String, dynamic>? get datosusuario => _datosusuario;

  Future<void> cargarsesion() async {
    final prefs = await SharedPreferences.getInstance();
    final datosguardados = prefs.getString('datosdesesion');
    if (datosguardados != null) {
      final datosdecodificados = json.decode(datosguardados);
      _token = datosdecodificados['token'];
      _datosusuario = datosdecodificados['usuario'];
      _estainiciadasesion = true;
      notifyListeners();
    }
  }

  Future<void> _guardarsesion(String token, Map<String, dynamic> usuario) async {
    final prefs = await SharedPreferences.getInstance();
    final datosparaguardar = json.encode({'token': token, 'usuario': usuario});
    await prefs.setString('datosdesesion', datosparaguardar);
  }

  Future<bool> iniciarsesion(String correo, String contrasena) async {
    final url = Uri.parse('$_baseUrl/auth/login');
    try {
      final response = await http.post(
        url,
        body: {
          'correo': correo,
          'password': contrasena,
        },
      );

      debugPrint('Respuesta del login: ${response.statusCode} -> ${response.body}');

      if (response.statusCode == 200) {
        final datos = json.decode(response.body);
        if (datos.containsKey('token')) {
          _token = datos['token'];
          _datosusuario = datos['usuario'];
          _estainiciadasesion = true;
          await _guardarsesion(_token!, _datosusuario!);
          notifyListeners();
          return true;
        }
      }
    } catch (e) {
      debugPrint('Error al iniciar sesion....: $e');
    }
    return false;
  }

  Future<void> cerrarsesion() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('datosdesesion');
    _estainiciadasesion = false;
    _token = null;
    _datosusuario = null;
    notifyListeners();
  }
}
