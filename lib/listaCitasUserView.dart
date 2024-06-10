import 'package:flutter/material.dart';
import 'package:proyecto/calendarScreen.dart';
import 'package:proyecto/home.dart';
import 'package:proyecto/listaCitasUser.dart';
import 'package:proyecto/listcitas.dart';
import 'package:proyecto/loginScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proyecto/resdialog.dart';
import 'package:proyecto/services.dart';

class ListCitasView extends StatefulWidget {
  final String user;
  final Map<String, dynamic> userComplete;
  final int userType;
  const ListCitasView(
      {Key? key, required this.user, required this.userComplete, required this.userType})
      : super(key: key);

  @override
  _ListCitasViewState createState() => _ListCitasViewState();
}

class _ListCitasViewState extends State<ListCitasView> {
  late Future<List<Map<String, dynamic>>> estilistas;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Citas'),
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
                  MaterialPageRoute(
                      builder: (context) =>
                          HomeScreen(user: widget.userComplete)),
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
                  MaterialPageRoute(
                      builder: (context) => ListaCitas(idUsuario: widget.user)),
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
      body: ListaCitas(idUsuario: widget.user),
    );
  }
}
