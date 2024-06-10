import 'package:flutter/material.dart';
import 'package:proyecto/resdialog.dart';
import 'package:proyecto/services.dart';

class Estilista {
  final String id;
  final String nombre;

  Estilista({required this.id, required this.nombre});
}

class AgregarCitaScreen extends StatefulWidget {
  @override
  _AgregarCitaScreenState createState() => _AgregarCitaScreenState();
}

class _AgregarCitaScreenState extends State<AgregarCitaScreen> {
  Map<String, dynamic>? selectedCliente;
  Map<String, dynamic>? selectedEstilista;
  Map<String, dynamic>? selectedTipoPago;
  DateTime fechaSeleccionada = DateTime.now();
  TimeOfDay horaSeleccionada = TimeOfDay.now();
  List<Map<String, dynamic>> clientes = [];
  List<Map<String, dynamic>> estilistas = [];
  List<Map<String, dynamic>> tiposPagos = [];

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  Future<void> getUsers() async {
    await obtenerUsuarios('Usuario').then((List<Map<String, dynamic>> result) {
      setState(() {
        clientes = result;
      });
    });

    await obtenerUsuarios('Estilista')
        .then((List<Map<String, dynamic>> result) {
      setState(() {
        estilistas = result;
      });
    });

    await obtenerTiposPagos().then((List<Map<String, dynamic>> result) {
      setState(() {
        tiposPagos = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Cita'),
      ),
      body: FutureBuilder(
        future: getUsers(),
        builder: ((context, index) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                buildDropdownTextField(
                  'Cliente',
                  selectedCliente != null
                      ? selectedCliente!['nombre'] ?? ''
                      : '',
                  clientes,
                ),
                SizedBox(height: 16.0),
                buildDropdownTextField(
                  'Estilista',
                  selectedEstilista != null
                      ? selectedEstilista!['nombre'] ?? ''
                      : '',
                  estilistas,
                ),
                ListTile(
                  title: Text('Fecha: ${fechaSeleccionada.toLocal()}'),
                  trailing: Icon(Icons.calendar_today),
                  onTap: () async {
                    DateTime? fechaSeleccionada = await showDatePicker(
                      context: context,
                      initialDate: this.fechaSeleccionada,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101),
                    );

                    if (fechaSeleccionada != null &&
                        fechaSeleccionada != this.fechaSeleccionada) {
                      setState(() {
                        this.fechaSeleccionada = fechaSeleccionada;
                      });
                    }
                  },
                ),
                SizedBox(height: 16.0),
                ListTile(
                  title: Text('Hora: ${horaSeleccionada.format(context)}'),
                  trailing: Icon(Icons.access_time),
                  onTap: () async {
                    TimeOfDay? horaSeleccionada = await showTimePicker(
                      context: context,
                      initialTime: this.horaSeleccionada,
                    );

                    if (horaSeleccionada != null &&
                        horaSeleccionada != this.horaSeleccionada) {
                      setState(() {
                        this.horaSeleccionada = horaSeleccionada;
                      });
                    }
                  },
                ),
                buildDropdownTextField(
                  'Tipo de Pago',
                  selectedTipoPago != null
                      ? selectedTipoPago!['nombre'] ?? ''
                      : '',
                  tiposPagos,
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    // Handle the logic for adding the appointment
                    _agregarCita();
                  },
                  child: const Text('Agregar Cita'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget buildDropdownTextField(
    String label,
    String selectedValue,
    List<Map<String, dynamic>> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        SizedBox(height: 8.0),
        TextField(
          controller: TextEditingController(text: selectedValue),
          onTap: () {
            _showSelectionDialog(context, label, items);
          },
          readOnly: true,
          decoration: InputDecoration(
            hintText: 'Seleccione un $label',
            suffixIcon: Icon(Icons.arrow_drop_down),
          ),
        ),
      ],
    );
  }

  Future<void> _showSelectionDialog(BuildContext context, String label,
      List<Map<String, dynamic>> items) async {
    print(items);
    dynamic result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Seleccionar $label'),
          content: Column(
            children: items.map((item) {
              return ListTile(
                title: Text(item['nombre']),
                onTap: () {
                  Navigator.pop(context, item);
                },
              );
            }).toList(),
          ),
        );
      },
    );

    if (result != null) {
      setState(() {
        if (label == 'Cliente') {
          selectedCliente = result as Map<String, dynamic>;
        } else if (label == 'Estilista') {
          selectedEstilista = result as Map<String, dynamic>;
        } else {
          selectedTipoPago = result as Map<String, dynamic>;
        }
      });
    }
  }

  void _agregarCita() async {
    // Implement the logic to add the appointment
    if (selectedCliente != null) {
      print(
          'Cliente: ${selectedCliente!['nombre']}, Cliente ID: ${selectedCliente!['identificacion']}');
    }
    if (selectedEstilista != null) {
      print(
          'Estilista: ${selectedEstilista!['nombre']}, Estilista ID: ${selectedEstilista!['identificacion']}');
    }
    var res = await guardarCita(
        fecha: this.fechaSeleccionada.toString(),
        hora: this.horaSeleccionada.format(context),
        idEstilista: selectedEstilista!['identificacion'],
        idCliente: selectedCliente!['identificacion'],
        nombreEstilista: selectedEstilista!['nombre'],
        nombreCliente: selectedCliente!['nombre'],
        tipoPago: selectedTipoPago!['nombre'],
        servicio: "",
        ValorServicio: "10000");
    if (res) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialog(
              isSuccess: true, descripcion: "Cita agendada correctamente");
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialog(
              isSuccess: false,
              descripcion: "Error al momento de agendar la cita.");
        },
      );
    }
  }
}
