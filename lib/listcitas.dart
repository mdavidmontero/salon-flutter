import 'package:flutter/material.dart';
import 'package:proyecto/CItasProvider.dart';
import 'package:proyecto/EditarCita.dart';
import 'package:proyecto/addusers.dart';
import 'package:proyecto/homeAdministrador.dart';
import 'package:proyecto/citas.dart';
import 'package:intl/intl.dart';
import 'package:proyecto/loginScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proyecto/services.dart';

class ListCitasScreen extends StatelessWidget {
  final String user;
  List<Map<String, dynamic>?> citas = [];
  ListCitasScreen({Key? key, required this.user}) : super(key: key);

  Future<void> getCitas() async {
    citas = await obtenerCitasPorUsuarios(user);
    convertirFechas();
  }

  void convertirFechas() {
    for (var cita in citas) {
      // Convierte el campo de fecha de String a DateTime
      cita!['fecha'] = DateTime.parse(cita!['fecha']);
      // Extrae solo la hora y minutos del campo 'hora'
      String horaCompleta = cita['hora'];
      String hora = horaCompleta.split(' ')[0];
      cita['hora'] = hora;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administrador'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.add),
              title: Text('Agregar Usuarios'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserAdd(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
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
        future: getCitas(),
        builder: ((context, index) {
          return RefreshIndicator(
            onRefresh: () async {
              await getCitas();
            },
            child: ListView.builder(
              itemCount: citas.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 5.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${citas[index]!['nombreCliente']}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('${citas[index]!['nombreEstilista']}'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('${_formatDate(citas[index]!['fecha'])}'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('${citas[index]!['hora']}'),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditarCitaScreen(cita: citas[index]),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final formattedDate = DateFormat.yMMMd().format(date);
    return formattedDate;
  }
}
