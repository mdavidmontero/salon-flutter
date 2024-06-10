import 'package:flutter/material.dart';
import 'package:proyecto/ProfilePage.dart';
import 'package:proyecto/calendarScreen.dart';
import 'package:proyecto/home.dart';
import 'package:proyecto/listaCitasEstilistas.dart';
import 'package:proyecto/listaCitasUser.dart';
import 'package:proyecto/listcitas.dart';
import 'package:proyecto/loginScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proyecto/resdialog.dart';
import 'package:proyecto/services.dart';

class ListasCitasEstilistasView extends StatefulWidget {
  final String user;
  final Map<String, dynamic> userComplete;
  const ListasCitasEstilistasView({Key? key, required this.user, required this.userComplete}) : super(key: key);

  @override
  _ListasCitasEstilistasViewState createState() => _ListasCitasEstilistasViewState();
}

class _ListasCitasEstilistasViewState extends State<ListasCitasEstilistasView> {
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
              leading: const Icon(Icons.person),
              title: const Text('Perfil'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfilePage(
                          userComplete: widget.userComplete, isEdit: true,)),
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
      body: ListaCitasEstilistas(idUsuario: widget.user),
    );
  }
}

