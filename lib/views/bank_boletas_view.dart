import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'boleta_detail_view.dart';
import 'fecha_input_view.dart'; // Importar la nueva vista de ingreso de fecha

class BankBoletasView extends StatefulWidget {
  final String bankId;

  const BankBoletasView({Key? key, required this.bankId}) : super(key: key);

  @override
  _BankBoletasViewState createState() => _BankBoletasViewState();
}

class _BankBoletasViewState extends State<BankBoletasView> {
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> facturas = [];
  bool isLoading = true;
  String tipoMoneda = 'USD';

  @override
  void initState() {
    super.initState();
    fetchFacturas();
  }

  Future<void> fetchFacturas() async {
    setState(() => isLoading = true);

    try {
      final data = await _apiService.getBoletasByBankAndCurrency(widget.bankId, tipoMoneda);
      setState(() {
        facturas = data['boletas'].cast<Map<String, dynamic>>();
      });
    } catch (e) {
      print('Error fetching facturas: $e');
      setState(() {
        facturas = [];
      });
    }

    setState(() => isLoading = false);
  }

  void onTipoMonedaChanged(String moneda) {
    setState(() {
      tipoMoneda = moneda;
      fetchFacturas();
    });
  }

  void goToFechaInput() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FechaInputView(
          bankId: widget.bankId,
          tipoMoneda: tipoMoneda,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Facturas de ${widget.bankId}'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => onTipoMonedaChanged('USD'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tipoMoneda == 'USD' ? Colors.blue : Colors.grey,
                  ),
                  child: Text('USD'),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => onTipoMonedaChanged('PEN'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tipoMoneda == 'PEN' ? Colors.blue : Colors.grey,
                  ),
                  child: Text('PEN'),
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : facturas.isEmpty
                    ? Center(child: Text("No se encontraron facturas para ${widget.bankId} en $tipoMoneda"))
                    : ListView.builder(
                        itemCount: facturas.length,
                        itemBuilder: (context, index) {
                          final factura = facturas[index];
                          String truncatedFacturaId = factura['boleta_id'].substring(0, 10);
                          int importe = factura['importe'].toInt();
                          return Card(
                            child: ListTile(
                              title: Text('Factura ID: $truncatedFacturaId'),
                              subtitle: Text('Importe: $importe ${factura['tipo_moneda']}'),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BoletaDetailView(boleta: factura),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: goToFechaInput, // Navegar a FechaInputView
                    icon: Icon(Icons.assessment),
                    label: Text('Generar Consolidado'),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final result = await Navigator.pushNamed(
                        context,
                        '/addBoleta',
                        arguments: widget.bankId,
                      );
                      if (result == true) {
                        fetchFacturas();
                      }
                    },
                    icon: Icon(Icons.add),
                    label: Text('Agregar Factura'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
