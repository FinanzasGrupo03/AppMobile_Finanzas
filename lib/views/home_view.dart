import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Opciones")),
      body: Column(
        children: [
          Expanded(
            child: Card(
              color: Colors.blue[800], // Azul oscuro para BCP
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/boletas',
                    arguments: {'bankId': 'BCP', 'tipoMoneda': 'Soles'},
                  );
                },
                child: Center(
                  child: Text(
                    "BCP",
                    style: TextStyle(fontSize: 32, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Card(
              color: Colors.green[700], // Verde para Interbank
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/boletas',
                    arguments: {'bankId': 'Interbank', 'tipoMoneda': 'Soles'},
                  );
                },
                child: Center(
                  child: Text(
                    "Interbank",
                    style: TextStyle(fontSize: 32, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Card(
              color: Colors.lightBlue[400], // Celeste para BBVA
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/boletas',
                    arguments: {'bankId': 'BBVA', 'tipoMoneda': 'Soles'},
                  );
                },
                child: Center(
                  child: Text(
                    "BBVA",
                    style: TextStyle(fontSize: 32, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Card(
              color: Colors.orange[800], // Color para Facturas (Boletas sin asignar)
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/boletasLibres');
                },
                child: Center(
                  child: Text(
                    "Facturas",
                    style: TextStyle(fontSize: 32, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
