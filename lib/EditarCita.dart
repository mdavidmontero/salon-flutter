import 'package:flutter/material.dart';
import 'package:proyecto/ProfilePage.dart';
import 'package:proyecto/citas.dart';
import 'package:proyecto/resdialog.dart';
import 'package:proyecto/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:typed_data'; // Importación necesaria para Uint8List
import 'package:flutter/services.dart';

class EditarCitaScreen extends StatefulWidget {
  final Map<String, dynamic>? cita;

  EditarCitaScreen({required this.cita});

  @override
  _EditarCitaScreenState createState() => _EditarCitaScreenState();
}

class _EditarCitaScreenState extends State<EditarCitaScreen> {
  TextEditingController _clienteController = TextEditingController();
  TextEditingController _estilistaController = TextEditingController();
  TextEditingController _tipoPagoController = TextEditingController();
  TextEditingController _estadoController = TextEditingController();
  DateTime _fechaSeleccionada = DateTime.now();
  TimeOfDay _horaSeleccionada = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    print(widget.cita!);
    // Inicializa los controladores con los valores existentes
    _clienteController.text = widget.cita!['nombreCliente'];
    _estilistaController.text = widget.cita!['nombreEstilista'];
    _tipoPagoController.text = widget.cita!['tipoPago'];
    _fechaSeleccionada = widget.cita!['fecha'];
    _horaSeleccionada = TimeOfDay(
      hour: int.parse(widget.cita!['hora'].split(':')[0]),
      minute: int.parse(widget.cita!['hora'].split(':')[1].split(' ')[0]),
    );
    _estadoController.text = widget.cita!['estado'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Cita'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _clienteController,
              decoration: InputDecoration(labelText: 'Cliente'),
              enabled: false,
            ),
            TextField(
              controller: _estilistaController,
              decoration: InputDecoration(labelText: 'Estilista'),
              enabled: false,
            ),
            TextField(
              controller: _tipoPagoController,
              decoration: InputDecoration(labelText: 'Tipo Pago'),
              enabled: false,
            ),
            ListTile(
              title: Text('Fecha: ${_fechaSeleccionada.toLocal()}'),
              trailing: Icon(Icons.calendar_today),
              onTap: () async {
                DateTime? fechaSeleccionada = await showDatePicker(
                  context: context,
                  initialDate: _fechaSeleccionada,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2101),
                );

                if (fechaSeleccionada != null &&
                    fechaSeleccionada != _fechaSeleccionada) {
                  setState(() {
                    _fechaSeleccionada = fechaSeleccionada;
                  });
                }
              },
            ),
            ListTile(
              title: Text('Hora: ${_horaSeleccionada.format(context)}'),
              trailing: Icon(Icons.access_time),
              onTap: () async {
                TimeOfDay? horaSeleccionada = await showTimePicker(
                  context: context,
                  initialTime: _horaSeleccionada,
                );

                if (horaSeleccionada != null &&
                    horaSeleccionada != _horaSeleccionada) {
                  setState(() {
                    _horaSeleccionada = horaSeleccionada;
                  });
                }
              },
            ),
            SizedBox(height: 16.0),
            DropdownButton<String>(
              value: _estadoController.text,
              onChanged: (String? newValue) {
                setState(() {
                  _estadoController.text = newValue!;
                });
              },
              items: <String>['Pendiente', 'Pagado']
                  .map<DropdownMenuItem<String>>(
                    (String value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    ),
                  )
                  .toList(),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _actualizarCita();
              },
              child: Text('Actualizar'),
            ),
            ElevatedButton(
              onPressed: () async {
                var estilista = await obtenerPorId(widget.cita!['idEstilista']);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfilePage(
                            userComplete: estilista,
                            isEdit: true,
                          )),
                );
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  foregroundColor: Colors.white),
              child: Text('Ver Estilista'),
            ),
            ElevatedButton(
              onPressed: () async {
                var estilista = await obtenerPorId(widget.cita!['idCliente']);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfilePage(
                            userComplete: estilista,
                            isEdit: true,
                          )),
                );
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amberAccent,
                  foregroundColor: Colors.white),
              child: Text('Ver Paciente'),
            ),
            ElevatedButton(
              onPressed: () {
                generarYMostrarPDF();
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, foregroundColor: Colors.white),
              child: Text('Generar Factura'),
            )
          ],
        ),
      ),
    );
  }

  void _actualizarCita() async {
    String cliente = _clienteController.text;
    String estilista = _estilistaController.text;
    DateTime fecha = _fechaSeleccionada;
    String hora = _horaSeleccionada.format(context);
    String estado = _estadoController.text;
    var res = await actualizarCita(
        idCita: widget.cita!['id'],
        nuevaFecha: fecha.toString(),
        nuevaHora: hora,
        estado: estado);

    if (res) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialog(
              isSuccess: true, descripcion: "Cita actualizada correctamente");
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialog(
              isSuccess: false,
              descripcion: "Error al momento de actualizar la cita.");
        },
      );
    }
  }

  Future<void> generarYMostrarPDF() async {
    final pdf = pw.Document();

    final String fechaActual = DateFormat('dd/MM/yyyy').format(DateTime.now());

    final String nombreCliente = widget.cita!['nombreCliente'];
    final String nombreEstilista = widget.cita!['nombreEstilista'];
    final DateTime fechaCita = widget.cita!['fecha'];
    final String tipoPago = widget.cita!['tipoPago'];
    final String total = widget.cita!['valorServicio'];
    final String servicio = widget.cita!['servicio'];
    final String estado = widget.cita!['estado'];
    final qrValidationResult = QrValidator.validate(
      data: widget.cita!['id'],
      version: QrVersions.auto,
      errorCorrectionLevel: QrErrorCorrectLevel.L,
    );

    if (qrValidationResult.status == QrValidationStatus.valid) {
      final qrCode = qrValidationResult.qrCode;
      final painter = QrPainter.withQr(
        qr: qrCode!,
        color: const Color(0xFF000000),
        emptyColor: const Color(0xFFFFFFFF),
        gapless: true,
      );

      final picData = await painter.toImageData(200);
      final imgBytes = picData!.buffer.asUint8List();

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Factura',
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 20),
                pw.Text('$fechaActual'),
                pw.SizedBox(height: 20),
                pw.Text('Nombre Cliente: $nombreCliente'),
                pw.Text('Nombre Estilista: $nombreEstilista'),
                pw.Text('Fecha Cita: $fechaCita'),
                pw.Text('Tipo Pago: $tipoPago'),
                pw.Text('Servicio: $servicio'),
                pw.Text(
                  'Estado: $estado',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  'Total: $total',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 20),
                pw.Container(
                  alignment: pw.Alignment.center,
                  child: pw.Image(
                    pw.MemoryImage(imgBytes),
                    width: 100,
                    height: 100,
                  ), // Añadir la imagen QR al PDF
                ),
              ],
            );
          },
        ),
      );

      final output = await getTemporaryDirectory();
      final file = File("${output.path}/factura.pdf");

      await file.writeAsBytes(await pdf.save());

      Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );
    }
  }
}
