import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/constants.dart';

class ApiService {
  // Método para iniciar sesión
  Future<Map<String, dynamic>> signIn(String username, String password) async {
    final response = await http.post(
      Uri.parse('${Constants.baseUrl}/iniciar_sesion'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'usuario': username, 'contraseña': password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Error: ${response.statusCode}, ${response.body}');
      throw Exception('Error al iniciar sesión');
    }
  }

  // Método para registrarse
  Future<void> register(String username, String password, String firstName, String lastName, String email) async {
    final response = await http.post(
      Uri.parse('${Constants.baseUrl}/registrarte'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'usuario': username,
        'contraseña': password,
        'nombres': firstName,
        'apellidos': lastName,
        'correo': email,
      }),
    );

    if (response.statusCode != 201) {
      print('Error: ${response.statusCode}, ${response.body}');
      throw Exception('Error al registrarse');
    }
  }

  // Método para obtener boletas por banco y tipo de moneda
  Future<Map<String, dynamic>> getBoletasByBankAndCurrency(String bankId, String tipoMoneda) async {
    final response = await http.get(
      Uri.parse('${Constants.baseUrl}/boletas/$bankId/$tipoMoneda'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      print('No se encontraron boletas: ${response.body}');
      return {'boletas': []}; // Retorna lista vacía si no se encuentran boletas
    } else {
      print('Error: ${response.statusCode}, ${response.body}');
      throw Exception('Error al obtener boletas');
    }
  }

  // Método para crear una boleta libre
  Future<void> crearBoletaLibre(Map<String, dynamic> boletaData) async {
    final response = await http.post(
      Uri.parse('${Constants.baseUrl}/crear_boleta_libre'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(boletaData),
    );

    if (response.statusCode != 201) {
      throw Exception('Error al crear boleta libre: ${response.body}');
    }
  }


   // Método para obtener boletas sin asignar
  Future<List<Map<String, dynamic>>> getBoletasLibres() async {
    final response = await http.get(Uri.parse('${Constants.baseUrl}/boletas_libres'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data['boletas_libres']);
    } else {
      print('Error: ${response.statusCode}, ${response.body}');
      throw Exception('Error al obtener boletas sin asignar');
    }
  }

  // Método para asignar boleta a un banco
  Future<void> asignarBoleta(String boletaId, String bancoId) async {
    final response = await http.post(
      Uri.parse('${Constants.baseUrl}/asignar_boleta'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'boleta_id': boletaId, 'banco_id': bancoId}),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al asignar boleta: ${response.body}');
    }
  }

  // Método para obtener boletas por banco
  Future<Map<String, dynamic>> getBoletasByBank(String bankId) async {
    final response = await http.get(Uri.parse('${Constants.baseUrl}/boletas/$bankId'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Error: ${response.statusCode}, ${response.body}');
      throw Exception('Error al obtener boletas');
    }
  }

  // Método para obtener el consolidado por banco y tipo de moneda
  Future<Map<String, dynamic>> getConsolidadoByBank(String bankId, String tipoMoneda, {required String fechaInicio, required String fechaFin}) async {
  final response = await http.post(
    Uri.parse('${Constants.baseUrl}/consolidado_boletas'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'banco_id': bankId,
      'tipo_moneda': tipoMoneda,
      'fecha_inicio': fechaInicio,
      'fecha_fin': fechaFin,
    }),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body)['consolidado'];
  } else {
    print('Error: ${response.statusCode}, ${response.body}');
    throw Exception('Error al obtener el consolidado');
  }
}


  
  Future<void> addBoleta(Map<String, dynamic> boleta) async {
    final url = Uri.parse('${Constants.baseUrl}/procesar_boletas');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'boletas': [boleta]}),
    );

    if (response.statusCode == 200) {
      print('Boleta agregada exitosamente.');
    } else {
      print('Error: ${response.statusCode}, ${response.body}');
      throw Exception('Error al agregar boleta');
    }
  }

}
