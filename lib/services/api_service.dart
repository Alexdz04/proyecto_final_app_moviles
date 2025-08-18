//lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class ApiService {
  final String _baseUrl = 'https://adamix.net/medioambiente';

  Future<dynamic> get(String endpoint, {String? token}) async {
    final url = Uri.parse('$_baseUrl/$endpoint');
    final headers = <String, String>{};
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) return json.decode(response.body);
    } catch (e) {
      debugPrint('Error en GET a $endpoint: $e');
    }
    return null;
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> data, {String? token}) async {
    final url = Uri.parse('$_baseUrl/$endpoint');
    final headers = <String, String>{};
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    try {
      final body = data.map((key, value) => MapEntry(key, value.toString()));
      final response = await http.post(url, headers: headers, body: body);
      final responseBody = json.decode(response.body);
      debugPrint('Respuesta de POST a $endpoint (${response.statusCode}): $responseBody');
      return responseBody;
    } catch (e) {
      debugPrint('Error en POST a $endpoint: $e');
    }
    return {'error': 'Error de conexion!'};
  }

  // --- Funciones de Autenticacion y Registro ---
  // CORREGIDO: Se añade la funcion para el registro completo de usuario.
  Future<Map<String, dynamic>> registrarUsuario(Map<String, dynamic> datos) async {
    return await post('/auth/register', datos);
  }

  Future<Map<String, dynamic>?> solicitarCodigoRecuperacion(String correo) async {
    return await post('/auth/recover', {'correo': correo});
  }

  Future<Map<String, dynamic>?> resetearContrasena(String correo, String codigo, String nuevaPassword) async {
    return await post('/auth/reset', {
      'correo': correo,
      'codigo': codigo,
      'nueva_password': nuevaPassword,
    });
  }

  Future<List<dynamic>> obtenerServicios() async => await get('servicios') ?? [];
  Future<List<dynamic>> obtenerNoticias() async => await get('noticias') ?? [];
  Future<List<dynamic>> obtenerVideos() async => await get('videos') ?? [];
  Future<List<dynamic>> obtenerAreasProtegidas() async => await get('areas_protegidas') ?? [];
  Future<List<dynamic>> obtenerMedidas() async => await get('medidas') ?? [];
  Future<List<dynamic>> obtenerEquipo() async => await get('equipo') ?? [];

  Future<List<dynamic>> obtenerNormativas(String token) async => await get('normativas', token: token) ?? [];
  Future<List<dynamic>> obtenerMisReportes(String token) async => await get('reportes', token: token) ?? [];

  Future<Map<String, dynamic>> enviarReporte(String token, Map<String, dynamic> datos) async {
    return await post('reportes', datos, token: token);
  }

  Future<Map<String, dynamic>> cambiarContrasena(String token, Map<String, dynamic> datos) async {
    final url = Uri.parse('$_baseUrl/usuarios');
    try {
      final response = await http.put(
        url,
        headers: {'Authorization': 'Bearer $token'},
        body: datos.map((key, value) => MapEntry(key, value.toString())),
      );
      if (response.statusCode == 200) return json.decode(response.body);
    } catch (e) {
      debugPrint('Error en PUT a /usuarios: $e');
    }
    return {'error': 'No se pudo actualizar!'};
  }
}
