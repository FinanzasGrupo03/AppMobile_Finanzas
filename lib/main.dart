import 'package:flutter/material.dart';
import 'views/login_view.dart';
import 'views/register_view.dart';
import 'views/home_view.dart';
import 'views/bank_boletas_view.dart';
import 'views/form_view.dart';
import 'views/consolidado_moneda_view.dart'; // Importar la nueva vista de consolidado por moneda
import 'views/boletas_libres_view.dart'; // Vista para boletas sin asignar

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finanzas Flutter',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginView(),
        '/register': (context) => RegisterView(),
        '/home': (context) => HomeView(),
        '/boletasLibres': (context) => BoletasLibresView(),
        '/boletas': (context) => BankBoletasView(
              bankId: (ModalRoute.of(context)!.settings.arguments as Map)['bankId'],
            ),
        '/addBoleta': (context) => FormView(bankId: ModalRoute.of(context)!.settings.arguments as String),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/consolidado') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => ConsolidadoMonedaView(
              bankId: args['bankId'],
              tipoMoneda: args['tipoMoneda'],
              fechaInicio: args['fechaInicio'],
              fechaFin: args['fechaFin'],
            ),
          );
        }
        return null;
      },
    );
  }
}
