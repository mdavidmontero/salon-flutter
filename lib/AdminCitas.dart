import 'package:flutter/material.dart';
import 'package:proyecto/CItasProvider.dart';
import 'package:proyecto/EditarCita.dart';
import 'package:proyecto/addusers.dart';
import 'package:proyecto/AddServices.dart';
import 'package:proyecto/homeAdministrador.dart';
import 'package:proyecto/citas.dart';
import 'package:intl/intl.dart';
import 'package:proyecto/loginScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proyecto/resdialog.dart';
import 'package:proyecto/services.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/services.dart';

class AdminCitasScreen extends StatefulWidget {
  final CitasProvider citasProvider;

  AdminCitasScreen({Key? key, required this.citasProvider}) : super(key: key);

  @override
  _AdminCitasScreenState createState() => _AdminCitasScreenState();
}

class _AdminCitasScreenState extends State<AdminCitasScreen> {
  List<Map<String, dynamic>?> _citas = [];

  @override
  void initState() {
    super.initState();
    // Llama a getCitas al inicializar el widget
    getCitas();
  }

  Future<void> getCitas() async {
    List<Map<String, dynamic>?> nuevasCitas = await getCitasy();
    convertirFechas(nuevasCitas);
    // Utiliza setState para actualizar el estado del widget con las nuevas citas
    setState(() {
      _citas = nuevasCitas;
    });
  }

  void convertirFechas(List<Map<String, dynamic>?> citas) {
    for (var cita in citas) {
      // Convierte el campo de fecha de String a DateTime
      cita!['fecha'] = DateTime.parse(cita['fecha']);
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
        actions: [
          IconButton(
            onPressed: () {
              scanQR();
            },
            icon: Icon(Icons.qr_code_scanner),
          ),
        ],
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
              leading: Icon(Icons.design_services),
              title: Text('Agregar Servicios'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ServicesAdd(),
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
      body: RefreshIndicator(
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: _citas.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 5.0,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${_citas[index]!['nombreCliente']}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('${_citas[index]!['nombreEstilista']}'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('${_formatDate(_citas[index]!['fecha'])}'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('${_citas[index]!['hora']}'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            var res = await eliminarCita(
                                idCita: _citas[index]!['id']);
                            if (res) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CustomDialog(
                                      isSuccess: true,
                                      descripcion:
                                          "Cita eliminada correctamente,");
                                },
                              );
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CustomDialog(
                                      isSuccess: false,
                                      descripcion:
                                          "Error al momento de eliminar la cita.");
                                },
                              );
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditarCitaScreen(cita: _citas[index]),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        onRefresh: getCitas,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AgregarCitaScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final formattedDate = DateFormat.yMMMd().format(date);
    return formattedDate;
  }

  Future<void> scanQR() async {
    try {
      var qrResult = await BarcodeScanner.scan();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Cita"),
            content: Text(qrResult.rawContent),
            actions: [
              TextButton(
                onPressed: () {
                  Map<String, dynamic>? citaEncontrada = _citas.firstWhere(
                    (cita) => cita!['id'] == qrResult.rawContent,
                    orElse: () => null,
                  );

                  if (citaEncontrada != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EditarCitaScreen(cita: citaEncontrada),
                      ),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Cita no encontrada"),
                          content: Text(
                              "No se encontró ninguna cita con el ID proporcionado."),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("Cerrar"),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: Text("Ir a cita"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cerrar"),
              ),
            ],
          );
        },
      );
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Permiso de cámara denegado"),
              content:
                  Text("Por favor, otorga permiso para acceder a la cámara."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cerrar"),
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error al escanear"),
              content: Text(
                  "Ocurrió un error al intentar escanear el código QR: $e"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cerrar"),
                ),
              ],
            );
          },
        );
      }
    } on FormatException {
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Ocurrió un error inesperado: $e"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cerrar"),
              ),
            ],
          );
        },
      );
    }
  }
}
