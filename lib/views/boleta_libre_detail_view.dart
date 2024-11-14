import 'package:flutter/material.dart'; 

class BoletaLibreDetailView extends StatelessWidget {
  final Map<String, dynamic> boleta;

  const BoletaLibreDetailView({Key? key, required this.boleta}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalle de Factura sin Asignar"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Nombre: ${boleta['nombre']}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text("DNI: ${boleta['dni']}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text("Empresa: ${boleta['empresa']}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text("RUC: ${boleta['ruc']}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text("Fecha de Emisión: ${boleta['fecha_emision']}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text("Fecha de Vencimiento: ${boleta['fecha_vencimiento']}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text("Importe: ${boleta['importe']} ${boleta['tipo_moneda']}", style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}