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
        child: ListView(
          children: boleta.entries.map((entry) {
            return ListTile(
              title: Text(entry.key, style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(entry.value.toString()),
            );
          }).toList(),
        ),
      ),
    );
  }
}
