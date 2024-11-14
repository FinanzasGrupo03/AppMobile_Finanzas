import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';

class ConsolidadoMonedaView extends StatefulWidget {
  final String bankId;
  final String tipoMoneda;
  final DateTime fechaInicio;
  final DateTime fechaFin;
  static const double usdToPenRate = 3.8161573;

  const ConsolidadoMonedaView({
    Key? key,
    required this.bankId,
    required this.tipoMoneda,
    required this.fechaInicio,
    required this.fechaFin,
  }) : super(key: key);

  @override
  _ConsolidadoMonedaViewState createState() => _ConsolidadoMonedaViewState();
}

class _ConsolidadoMonedaViewState extends State<ConsolidadoMonedaView> {
  final ApiService _apiService = ApiService();
  bool showConsolidado = false;
  Map<String, dynamic>? consolidadoData;

  @override
  void initState() {
    super.initState();
    _fetchConsolidado();
  }

  Future<void> _fetchConsolidado() async {
  try {
    final consolidado = await _apiService.getConsolidadoByBank(
      widget.bankId,
      widget.tipoMoneda,
      fechaInicio: DateFormat('dd/MM/yyyy').format(widget.fechaInicio!),
      fechaFin: DateFormat('dd/MM/yyyy').format(widget.fechaFin!),
    );

    setState(() {
      consolidadoData = consolidado;
      showConsolidado = true;
    });
  } catch (e) {
    print('Error fetching consolidado: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error al obtener el consolidado: $e')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consolidado por Moneda'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: showConsolidado ? _buildConsolidadoView() : _buildLoadingView(),
      ),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildConsolidadoView() {
    if (consolidadoData == null) return Container();

    String tipoMoneda = consolidadoData!["Tipo de Moneda"] ?? "N/A";
    double montoTotal = consolidadoData!["Monto Total (Valor Recibido)"] ?? 0.0;
    double tceaCartera = consolidadoData!["TCEA Cartera (Tasa de Costo Efectivo Anual Cartera)"] ?? 0.0;
    double montoTotalEnPen = tipoMoneda == "USD" ? montoTotal * ConsolidadoMonedaView.usdToPenRate : montoTotal;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Banco ID: ${consolidadoData!["Banco ID"] ?? "No disponible"}',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          'Tipo de Moneda: $tipoMoneda',
          style: TextStyle(fontSize: 16),
        ),
        Text(
          'Monto Total (Valor Recibido): ${montoTotal.toStringAsFixed(2)} $tipoMoneda',
          style: TextStyle(fontSize: 16),
        ),
        if (tipoMoneda == "USD")
          Text(
            'Monto Total en PEN: ${montoTotalEnPen.toStringAsFixed(2)} PEN',
            style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
          ),
        Text(
          'TCEA Cartera: ${tceaCartera.toStringAsFixed(2)}%',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 20),
        Text(
          'Lista de Facturas:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: consolidadoData!["Lista de Boletas"] != null &&
                  consolidadoData!["Lista de Boletas"].isNotEmpty
              ? ListView.builder(
                  itemCount: consolidadoData!["Lista de Boletas"].length,
                  itemBuilder: (context, index) {
                    final boleta = consolidadoData!["Lista de Boletas"][index];
                    final truncatedBoletaId = boleta["Boleta ID"].toString().substring(0, 10);
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text('Factura ID: $truncatedBoletaId'),
                        subtitle: Text('COK: ${boleta["COK"]?.toStringAsFixed(2) ?? "No disponible"}%'),
                      ),
                    );
                  },
                )
              : Center(
                  child: Text(
                    "No hay facturas en la lista",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
        ),
      ],
    );
  }
}
