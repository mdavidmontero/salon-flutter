import 'package:flutter/material.dart';
import 'package:proyecto/verCita.dart';
import 'package:proyecto/services.dart';

class ListaCitas extends StatefulWidget {
  final String idUsuario;

  ListaCitas({required this.idUsuario});

  @override
  _ListaCitasState createState() => _ListaCitasState();
}

class _ListaCitasState extends State<ListaCitas> {
  late Future<List<Map<String, dynamic>?>> _citasFuture;

  @override
  void initState() {
    super.initState();
    _citasFuture = cargarFechasCitas();
  }

  Future<List<Map<String, dynamic>?>> cargarFechasCitas() async {
    try {
      // Obtener las citas por usuario
      return await obtenerCitasPorUsuario(widget.idUsuario);
    } catch (e) {
      print('Error al cargar fechas de citas: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>?>>(
      future: _citasFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error al cargar las citas'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No hay citas disponibles'));
        } else {
          // Mostrar la lista de citas
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var cita = snapshot.data![index];
              return Card(
                elevation: 2.0,
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ListTile(
                  title: Text('Cliente: ${cita!['nombreCliente']}'),
                  subtitle: Text('Estilista: ${cita['nombreEstilista']}'),
                  trailing: Text('Fecha: ${cita['fecha']}'),
                  onTap: () {
                    // Mostrar detalles de la cita
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return VerCitaDialog(cita: cita, userType: 1,);
                      },
                    );
                  },
                ),
              );
            },
          );
        }
      },
    );
  }
}
