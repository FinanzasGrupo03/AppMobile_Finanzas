import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'consolidado_moneda_view.dart';

class FechaInputView extends StatefulWidget {
  final String bankId;
  final String tipoMoneda;

  const FechaInputView({Key? key, required this.bankId, required this.tipoMoneda}) : super(key: key);

  @override
  _FechaInputViewState createState() => _FechaInputViewState();
}

class _FechaInputViewState extends State<FechaInputView> {
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  TextEditingController fechaInicioController = TextEditingController();
  TextEditingController fechaFinController = TextEditingController();

  Future<void> _selectDate(TextEditingController controller) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        controller.text = dateFormat.format(picked);
      });
    }
  }

  void _navigateToConsolidado() {
    if (fechaInicioController.text.isNotEmpty && fechaFinController.text.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConsolidadoMonedaView(
            bankId: widget.bankId,
            tipoMoneda: widget.tipoMoneda,
            fechaInicio: dateFormat.parse(fechaInicioController.text),
            fechaFin: dateFormat.parse(fechaFinController.text),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, ingrese ambas fechas')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seleccionar Rango de Fechas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: fechaInicioController,
              decoration: InputDecoration(
                labelText: "Fecha de Inicio (dd/MM/yyyy)",
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(fechaInicioController),
                ),
              ),
              keyboardType: TextInputType.datetime,
            ),
            SizedBox(height: 10),
            TextField(
              controller: fechaFinController,
              decoration: InputDecoration(
                labelText: "Fecha de Fin (dd/MM/yyyy)",
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(fechaFinController),
                ),
              ),
              keyboardType: TextInputType.datetime,
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _navigateToConsolidado,
                child: Text('Mostrar Consolidado'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
