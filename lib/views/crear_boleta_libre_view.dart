import 'package:flutter/material.dart';
import '../services/api_service.dart';

class CrearBoletaLibreView extends StatefulWidget {
  @override
  _CrearBoletaLibreViewState createState() => _CrearBoletaLibreViewState();
}

class _CrearBoletaLibreViewState extends State<CrearBoletaLibreView> {
  final ApiService apiService = ApiService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController dniController = TextEditingController();
  final TextEditingController empresaController = TextEditingController();
  final TextEditingController rucController = TextEditingController();
  final TextEditingController fechaEmisionController = TextEditingController();
  final TextEditingController fechaVencimientoController = TextEditingController();
  final TextEditingController importeController = TextEditingController();
  String tipoMoneda = 'USD';

  Future<void> crearBoletaLibre() async {
    if (_formKey.currentState!.validate()) {
      try {
        await apiService.crearBoletaLibre({
          "nombre": nombreController.text,
          "dni": dniController.text,
          "empresa": empresaController.text,
          "ruc": rucController.text,
          "fecha_emision": fechaEmisionController.text,
          "fecha_vencimiento": fechaVencimientoController.text,
          "importe": double.parse(importeController.text),
          "tipo_moneda": tipoMoneda,
        });
        Navigator.pop(context, true); // Regresar y recargar lista de boletas libres
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al crear Factura: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Crear Factura sin Asignar")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nombreController,
                decoration: InputDecoration(labelText: "Nombre"),
                validator: (value) => value!.isEmpty ? "Ingrese el nombre" : null,
              ),
              TextFormField(
                controller: dniController,
                decoration: InputDecoration(labelText: "DNI"),
                validator: (value) => value!.isEmpty ? "Ingrese el DNI" : null,
              ),
              TextFormField(
                controller: empresaController,
                decoration: InputDecoration(labelText: "Empresa"),
                validator: (value) => value!.isEmpty ? "Ingrese la empresa" : null,
              ),
              TextFormField(
                controller: rucController,
                decoration: InputDecoration(labelText: "RUC"),
                validator: (value) => value!.isEmpty ? "Ingrese el RUC" : null,
              ),
              TextFormField(
                controller: fechaEmisionController,
                decoration: InputDecoration(labelText: "Fecha de Emisión (DD/MM/YYYY)"),
                validator: (value) => value!.isEmpty ? "Ingrese la fecha de emisión" : null,
              ),
              TextFormField(
                controller: fechaVencimientoController,
                decoration: InputDecoration(labelText: "Fecha de Vencimiento (DD/MM/YYYY)"),
                validator: (value) => value!.isEmpty ? "Ingrese la fecha de vencimiento" : null,
              ),
              TextFormField(
                controller: importeController,
                decoration: InputDecoration(labelText: "Importe"),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? "Ingrese el importe" : null,
              ),
              DropdownButtonFormField<String>(
                value: tipoMoneda,
                items: ['USD', 'PEN'].map((String moneda) {
                  return DropdownMenuItem<String>(
                    value: moneda,
                    child: Text(moneda),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    tipoMoneda = newValue!;
                  });
                },
                decoration: InputDecoration(labelText: "Tipo de Moneda"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: crearBoletaLibre,
                child: Text("Crear Factura"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}