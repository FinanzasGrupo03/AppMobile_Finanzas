import 'package:flutter/material.dart';

class BoletaDetailView extends StatelessWidget {
  final Map<String, dynamic> boleta;

  const BoletaDetailView({Key? key, required this.boleta}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detalle de Factura')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Banco ID: ${boleta['banco_id']}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text("Nombre: ${boleta['nombre']}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
            Text("Días Calculados: ${boleta['dias_calculados']}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text("Comisión de Activación: ${boleta['comision_activacion']} ${boleta['tipo_moneda']}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text("Comisión de Estudios: ${boleta['comision_estudios']} ${boleta['tipo_moneda']}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text("Seguro de Desgravamen: ${boleta['seguro_desgravamen']} ${boleta['tipo_moneda']}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text("Costos Adicionales: ${boleta['costos_adicionales']} ${boleta['tipo_moneda']}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text("Importe: ${boleta['importe']} ${boleta['tipo_moneda']}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            
            Text("Valor Neto: ${boleta['valor_neto']} ${boleta['tipo_moneda']}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text("Valor Recibido: ${boleta['valor_recibido']} ${boleta['tipo_moneda']}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            
            Text("TE Compensatoria: ${boleta['te_compensatoria']*100}%", style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text("Tasa de Descuento: ${boleta['tasa_descuento']*100}%", style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text("TCEA: ${boleta['tcea']*100}%", style: TextStyle(fontSize: 16)),
            
          ],
        )
        ),
      ),
    );
  }
}
