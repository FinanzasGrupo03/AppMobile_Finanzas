import '../models/user_model.dart';
import '../services/api_service.dart';

class AuthController {
  final ApiService apiService = ApiService();

  // Método de inicio de sesión
  Future<UserModel?> signIn(String username, String password) async {
    try {
      final data = await apiService.signIn(username, password);
      return UserModel.fromJson(data);
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  // Método para registrarse
  Future<bool> register(String username, String password, String firstName, String lastName, String email) async {
    try {
      await apiService.register(username, password, firstName, lastName, email);
      return true;
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }
  
  // Simulación de verificación de autenticación (debería conectarse a un servicio real)
  Future<bool> checkAuthentication() async {
    // Aquí iría la lógica para verificar si el usuario está autenticado,
    // como la lectura de un token o sesión guardada.
    return false; // Reemplaza con lógica real
  }
}
