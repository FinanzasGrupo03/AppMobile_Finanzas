import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'boleta_libre_detail_view.dart';
import 'crear_boleta_libre_view.dart';

class BoletasLibresView extends StatefulWidget {
  @override
  _BoletasLibresViewState createState() => _BoletasLibresViewState();
}

class _BoletasLibresViewState extends State<BoletasLibresView> {
  final ApiService apiService = ApiService();
  List<Map<String, dynamic>> facturas = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFacturasLibres();
  }

  Future<void> fetchFacturasLibres() async {
    try {
      final data = await apiService.getBoletasLibres();
      setState(() {
        facturas = data;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching facturas libres: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> asignarFactura(BuildContext context, String facturaId) async {
    String? selectedBank;
    final bancos = ["BCP", "Interbank", "BBVA"];

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text("Asignar Factura a Banco"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String>(
                    hint: Text("Selecciona un banco"),
                    value: selectedBank,
                    onChanged: (String? newValue) {
                      setDialogState(() {
                        selectedBank = newValue;
                      });
                    },
                    items: bancos.map((String bank) {
                      return DropdownMenuItem<String>(
                        value: bank,
                        child: Text(bank),
                      );
                    }).toList(),
                  ),
                  if (selectedBank != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text("Banco seleccionado: $selectedBank"),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancelar"),
                ),
                TextButton(
                  onPressed: () async {
                    if (selectedBank != null) {
                      try {
                        await apiService.asignarBoleta(facturaId, selectedBank!);
                        setState(() {
                          facturas.removeWhere((factura) => factura['boleta_id'] == facturaId);
                        });
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Factura asignada a $selectedBank")),
                        );
                      } catch (e) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Error al asignar factura: $e")),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Selecciona un banco")),
                      );
                    }
                  },
                  child: Text("Asignar"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> crearFactura() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CrearBoletaLibreView()),
    );
    if (result == true) {
      fetchFacturasLibres(); // Recargar lista si se crea una nueva factura
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Facturas sin Asignar"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: crearFactura,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : facturas.isEmpty
              ? Center(child: Text("No se encontraron facturas libres"))
              : ListView.builder(
                  itemCount: facturas.length,
                  itemBuilder: (context, index) {
                    final factura = facturas[index];
                    return ListTile(
                      title: Text("Factura ID: ${factura['boleta_id']}"),
                      subtitle: Text("Importe: ${factura['importe']} ${factura['tipo_moneda']}"),
                      trailing: IconButton(
                        icon: Icon(Icons.account_balance),
                        onPressed: () => asignarFactura(context, factura['boleta_id']),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BoletaLibreDetailView(boleta: factura),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}
