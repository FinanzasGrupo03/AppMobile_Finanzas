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

    double? tasaCompensatoria;
    String? tipoTasa;
    int? diasTasa;
    int? capitalizacion;

    final diasTasaItems = {
      30: 'Mensual',
      90: 'Trimestral',
      180: 'Semestral',
      365: 'Anual'
    };

    await showDialog(
  context: context,
  builder: (BuildContext context) {
    return StatefulBuilder(
      builder: (context, setDialogState) {
        return AlertDialog(
          title: const Text("Asignar Factura a Banco"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Banco seleccionado en un DropdownButton que ocupa todo el ancho
                SizedBox(
                  width: double.infinity,
                  child: DropdownButton<String>(
                    isExpanded: true, // Hace que el DropdownButton ocupe todo el ancho
                    hint: const Text("Selecciona un banco"),
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
                ),
                const SizedBox(height: 10),

                // Primera fila con "Tasa" y "Días Tasa"
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: "Tasa",
                          suffixText: "%",
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          tasaCompensatoria = double.tryParse(value);
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButton<int>(
                        isExpanded: true,
                        hint: const Text("Días Tasa"),
                        value: diasTasa,
                        onChanged: (int? newValue) {
                          setDialogState(() {
                            diasTasa = newValue;
                          });
                        },
                        items: diasTasaItems.entries.map((entry) {
                          return DropdownMenuItem<int>(
                            value: entry.key,
                            child: Text(entry.value),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Segunda fila con "Tipo de Tasa" y "Capitalización" (condicional)
                Row(
                  children: [
                    Expanded(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        hint: const Text("Tipo de Tasa"),
                        value: tipoTasa,
                        onChanged: (String? newValue) {
                          setDialogState(() {
                            tipoTasa = newValue;
                          });
                        },
                        items: ["Efectiva", "Nominal"].map((String type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    if (tipoTasa == "Nominal")
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            labelText: "Capitalización",
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            capitalizacion = int.tryParse(value);
                          },
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () async {
                if (selectedBank != null && tasaCompensatoria != null && diasTasa != null && tipoTasa != null) {
                  try {
                    await apiService.asignarBoleta({
                      "boleta_id": facturaId,
                      "banco_id": selectedBank!,
                      "tasa_compensatoria": tasaCompensatoria! / 100,
                      "dias_tasa": diasTasa,
                      "tipo_tasa": tipoTasa!.toUpperCase(),
                      "dias_capitalizacion": tipoTasa == "Nominal" ? capitalizacion : null,
                    });
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
                    const SnackBar(content: Text("Completa todos los campos")),
                  );
                }
              },
              child: const Text("Asignar"),
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
