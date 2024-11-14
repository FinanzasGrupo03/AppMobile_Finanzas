class UserModel {
  final String username;
  final String firstName;
  final String lastName;
  final String email;

  UserModel({
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  // Mapeo desde JSON con manejo de valores nulos
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['usuario'] ?? '',       // Valor predeterminado si es null
      firstName: json['nombres'] ?? '',      // Valor predeterminado si es null
      lastName: json['apellidos'] ?? '',     // Valor predeterminado si es null
      email: json['correo'] ?? '',           // Valor predeterminado si es null
    );
  }
}
