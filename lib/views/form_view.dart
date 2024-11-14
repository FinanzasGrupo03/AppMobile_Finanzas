import 'package:flutter/material.dart';
import '../services/api_service.dart';

class FormView extends StatefulWidget {
  final String bankId;

  const FormView({required this.bankId});

  @override
  _FormViewState createState() => _FormViewState();
}

class _FormViewState extends State<FormView> {
  final ApiService _apiService = ApiService();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _dniController = TextEditingController();
  final TextEditingController _empresaController = TextEditingController();
  final TextEditingController _rucController = TextEditingController();
  final TextEditingController _fechaEmisionController = TextEditingController();
  final TextEditingController _fechaVencimientoController = TextEditingController();
  final TextEditingController _importeController = TextEditingController();
  String _selectedCurrency = 'USD';

  Future<void> _addFactura() async {
    try {
      await _apiService.addBoleta({
        "nombre": _nombreController.text,
        "dni": _dniController.text,
        "empresa": _empresaController.text,
        "ruc": _rucController.text,
        "fecha_emision": _fechaEmisionController.text,
        "fecha_vencimiento": _fechaVencimientoController.text,
        "importe": double.tryParse(_importeController.text) ?? 0.0,
        "banco_id": widget.bankId,
        "tipo_moneda": _selectedCurrency,
      });
      Navigator.pop(context, true); // Regresa y refresca la lista en la vista de facturas
    } catch (e) {
      print('Error al agregar factura: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hubo un error al agregar la factura. Inténtalo de nuevo.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Agregar Factura Nueva')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _nombreController, decoration: InputDecoration(labelText: 'Nombre')),
            TextField(controller: _dniController, decoration: InputDecoration(labelText: 'DNI')),
            TextField(controller: _empresaController, decoration: InputDecoration(labelText: 'Empresa')),
            TextField(controller: _rucController, decoration: InputDecoration(labelText: 'RUC')),
            TextField(controller: _fechaEmisionController, decoration: InputDecoration(labelText: 'Fecha Emisión')),
            TextField(controller: _fechaVencimientoController, decoration: InputDecoration(labelText: 'Fecha Vencimiento')),
            TextField(controller: _importeController, decoration: InputDecoration(labelText: 'Importe'), keyboardType: TextInputType.number),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCurrency,
              items: ['USD', 'PEN'].map((String currency) {
                return DropdownMenuItem<String>(
                  value: currency,
                  child: Text(currency),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCurrency = value!;
                });
              },
              decoration: InputDecoration(labelText: 'Tipo de Moneda'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addFactura,
              child: Text('Agregar Factura'),
            ),
          ],
        ),
      ),
    );
  }
}
