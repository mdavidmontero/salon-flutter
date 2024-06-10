import 'package:flutter/material.dart';
import 'package:proyecto/ProfilePage.dart';
import 'package:proyecto/services.dart';

class VerCitaDialog extends StatelessWidget {
  final Map<String, dynamic>? cita;
  final int userType;

  VerCitaDialog({required this.cita, required this.userType});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Ver cita'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: TextEditingController(text: cita!['nombreCliente']),
              decoration: InputDecoration(labelText: 'Cliente', enabled: false),
            ),
            TextField(
              controller: TextEditingController(text: cita!['nombreEstilista']),
              decoration:
                  InputDecoration(labelText: 'Estilista', enabled: false),
            ),
            ListTile(
                title: Text('Fecha: ${cita!['fecha']}'),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  // Implementa la lógica para seleccionar la fecha
                },
                enabled: false),
            ListTile(
                title: Text('Hora: ${cita!['hora']}'),
                trailing: Icon(Icons.access_time),
                onTap: () async {
                  // Implementa la lógica para seleccionar la hora
                },
                enabled: false),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () async {
            var estilista = await obtenerPorId(cita!['idCliente']);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfilePage(
                  userComplete: estilista,
                  isEdit: false,
                ),
              ),
            );
          },
          child: Text(userType == 1 ? 'Ver Estilista' : 'Ver Paciente'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Aceptar'),
        ),
      ],
    );
  }
}
