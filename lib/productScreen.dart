import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proyecto/calendarScreen.dart';
import 'package:proyecto/listaCitasUserView.dart';
import 'package:proyecto/loginScreen.dart';
import 'package:proyecto/resdialog.dart';
import 'package:proyecto/services.dart';
import 'package:proyecto/listcitas.dart';
import 'package:proyecto/ProfilePage.dart';

class ProductScreen extends StatefulWidget {
  final Map<String, dynamic> user;
  const ProductScreen({Key? key, required this.user}) : super(key: key);

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late List<Map<String, dynamic>?> estilistas = [];

  String? _selectedService; // Estado para almacenar el servicio seleccionado

  @override
  void initState() {
    super.initState();
  }

  Future<void> getEstilistas() async {
    estilistas = await obtenerEstilistas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estilistas'),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.date_range),
              title: const Text('Ver citas'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ListCitasView(
                            user: widget.user['identificacion'],
                            userComplete: widget.user,
                            userType: 1,
                          )),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Perfil'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfilePage(
                            userComplete: widget.user,
                            isEdit: true,
                          )),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Cerrar Sesión'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder(
        future: getEstilistas(),
        builder: (context, snapshot) {
          List<Map<String, dynamic>?> estilistasData = estilistas;
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: estilistasData.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  // Navegar a la nueva pantalla cuando se presiona la tarjeta
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(
                        userComplete: estilistasData[index],
                        isEdit: false,
                      ),
                    ),
                  );
                },
                child: Card(
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        './image/imagen_2.png',
                        height: 100,
                        width: 100,
                      ),
                      Text(estilistasData[index]!['nombre'] ?? ''),
                      ElevatedButton(
                        onPressed: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(DateTime.now().year + 1),
                          );

                          if (pickedDate != null) {
                            TimeOfDay? pickedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );

                            if (pickedTime != null) {
                              DateTime selectedDateTime = DateTime(
                                pickedDate.year,
                                pickedDate.month,
                                pickedDate.day,
                                pickedTime.hour,
                                pickedTime.minute,
                              );
                              String horaFormateada =
                                  pickedTime.format(context);
                              _showServiceDialog(
                                  context,
                                  selectedDateTime.toString(),
                                  horaFormateada,
                                  estilistasData,
                                  index,
                                  widget);
                            }
                          }
                        },
                        child: const Text('Agendar Cita'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

Future<void> _showServiceDialog(
    BuildContext context,
    String selectedDateTime,
    String horaFormateada,
    List<Map<String, dynamic>?> estilistasData,
    int index,
    ProductScreen widget) async {
  List<Map<String, dynamic>?> servicios = await obtenerServicios();
  int? selectedServiceIndex;
  String? selectedServicePrice;

showDialog<int>(
  context: context,
  builder: (BuildContext context) {
    String selectedPaymentMethod = 'Efectivo'; // Variable para almacenar el método de pago seleccionado

    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: const Text('Selecciona un servicio'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButton<int>(
                value: selectedServiceIndex,
                hint: const Text('Selecciona un servicio'),
                onChanged: (int? newValue) {
                  setState(() {
                    selectedServiceIndex = newValue;
                    selectedServicePrice = servicios[selectedServiceIndex!]!['precio'].toString();
                  });
                },
                items: servicios.asMap().entries.map((entry) {
                  return DropdownMenuItem<int>(
                    value: entry.key,
                    child: Text(entry.value!['nombre']), 
                  );
                }).toList(),
              ),
              if (selectedServiceIndex != null)
                TextFormField(
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Precio',
                    hintText: selectedServicePrice,
                  ),
                ),
              const SizedBox(height: 20), // Agregamos un espacio entre el campo de precio y los RadioButtons
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RadioListTile<String>(
                    title: const Text('Efectivo'),
                    value: 'Efectivo',
                    groupValue: selectedPaymentMethod,
                    onChanged: (String? value) {
                      setState(() {
                        selectedPaymentMethod = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Transferencia'),
                    value: 'Transferencia',
                    groupValue: selectedPaymentMethod,
                    onChanged: (String? value) {
                      setState(() {
                        selectedPaymentMethod = value!;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                 String serviceName = servicios[selectedServiceIndex!]!['nombre'];
                    String precioServicio = servicios[selectedServiceIndex!]!['precio'];
                var res = await guardarCita(
                      fecha: selectedDateTime.toString(),
                      hora: horaFormateada,
                      idEstilista: estilistasData[index]!['identificacion'],
                      idCliente: widget.user['identificacion'],
                      nombreEstilista: estilistasData[index]!['nombre'],
                      nombreCliente: widget.user['nombre'],
                      tipoPago: selectedPaymentMethod,
                      servicio: serviceName ?? "",
                      ValorServicio: precioServicio,
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CalendarScreen(
                          idUsuario: widget.user['identificacion'],
                          user: widget.user,
                        ),
                      ),
                    );
                    if (res) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CustomDialog(
                            isSuccess: true,
                            descripcion: "Cita agendada correctamente",
                          );
                        },
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CustomDialog(
                            isSuccess: false,
                            descripcion: "Error al momento de agendar la cita.",
                          );
                        },
                      );
                    }
              },
              child: const Text('Aceptar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  },
);
  }

Future<List<Map<String, dynamic>>> obtenerEstilistas() async {
  try {
    var querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('rol', isEqualTo: 'Estilista')
        .get();

    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  } catch (e) {
    print('Error al obtener estilistas: $e');
    return [];
  }
}
