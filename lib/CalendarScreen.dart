import 'package:flutter/material.dart';
import 'package:proyecto/home.dart';
import 'package:proyecto/listaCitasUserView.dart';
import 'package:proyecto/listcitas.dart';
import 'package:proyecto/loginScreen.dart';
import 'package:proyecto/resdialog.dart';
import 'package:proyecto/services.dart';
import 'package:proyecto/verCita.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CalendarScreen extends StatefulWidget {
  final String idUsuario;
  final Map<String, dynamic> user;

  CalendarScreen({Key? key, required this.idUsuario, required this.user}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<Map<String, dynamic>?> citas = [];

  @override
  void initState() {
    super.initState();
    // Cargar las fechas de las citas al inicializar el estado
    cargarFechasCitas();
  }

  Future<void> cargarFechasCitas() async {
    try {
      // Obtener las citas por usuario
      List<Map<String, dynamic>?> citasSnapshot =
          await obtenerCitasPorUsuario(widget.idUsuario);

      setState(() {
        // Mapear las citas a la lista de fechas
        citas = citasSnapshot
            .map((cita) => {
                  "fecha": DateTime.parse(cita!['fecha'] as String),
                  "idCliente": cita!['idCliente'],
                  "nombreCliente": cita!['nombreCliente'],
                  "hora": cita!['hora'],
                  "idEstilista": cita!['idEstilista'],
                  "nombreEstilista": cita!['nombreEstilista']
                })
            .toList();

        citas.sort((a, b) =>
            (a!['fecha'] as DateTime).compareTo(b!['fecha'] as DateTime));
      });
    } catch (e) {
      print('Error al cargar fechas de citas: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendario de Citas'),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              onTap: () {
                // Agrega la lógica para cerrar sesión
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen(user: widget.user)),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.date_range),
              title: const Text('Ver citas'),
              onTap: () {
                // Agrega la lógica para cerrar sesión
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListCitasView(user: widget.idUsuario, userComplete: widget.user, userType: 1,)),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Cerrar Sesión'),
              onTap: () {
                // Agrega la lógica para cerrar sesión
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
      body: citas.isNotEmpty
          ? TableCalendar(
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              eventLoader: (day) {
                var find = false;
                DateTime dayDate = DateTime(day.year, day.month, day.day);
                citas.forEach((element) {
                  DateTime citaDate = DateTime(element!['fecha'].year,
                      element!['fecha'].month, element!['fecha'].day);
                  if (citaDate.isAtSameMomentAs(dayDate)) {
                    find = true;
                  }
                });
                if (find) {
                  return [day];
                }

                return [];
              },
              onDaySelected: (selectedDay, focusedDay) {
                var cita = null;
                var find = false;
                DateTime dayDate = DateTime(
                    selectedDay.year, selectedDay.month, selectedDay.day);
                citas.forEach((element) {
                  DateTime citaDate = DateTime(element!['fecha'].year,
                      element!['fecha'].month, element!['fecha'].day);
                  if (citaDate.isAtSameMomentAs(dayDate)) {
                    find = true;
                    cita = element;
                  }
                });
                if (find) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return VerCitaDialog(cita: cita, userType: 1,);
                    },
                  );
                }
              },
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
            )
          : Center(
              child:
                  CircularProgressIndicator(), // Muestra un indicador de carga mientras se obtienen las citas
            ),
    );
  }
}
