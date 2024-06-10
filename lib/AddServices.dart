import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:proyecto/resdialog.dart';

import 'package:proyecto/services.dart';

class ServicesAdd extends StatefulWidget {
  const ServicesAdd({Key? key}) : super(key: key);

  @override
  _ServicesAddState createState() => _ServicesAddState();
}

class _ServicesAddState extends State<ServicesAdd> {
  final _formKey = GlobalKey<FormState>();
  String _nombreServicio = '';
  String _precioServicio = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Agregar Servicios"),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                'https://th.bing.com/th/id/OIG2.C5T.cbOT9XQXbf_Vth_e?pid=ImgGn'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: <Widget>[
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                  child: Container(
                    color: Colors.black.withOpacity(0),
                  ),
                ),
              ),
              Center(
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          radius: 90.0,
                          backgroundImage: NetworkImage(
                              'https://img.freepik.com/vector-premium/diseno-logotipo-vectorial-salon-belleza-o-peluqueria-o-diseno-cosmetico-ilustracion-vector-concepto-linea-cara-mujer-abstracta_501705-134.jpg'), // Reemplaza con la ruta de tu imagen predeterminada
                        ),
                        const SizedBox(height: 20.0),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Nombre Servicio',
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Por favor ingresa el nombre del servicio';
                            }
                            return null;
                          },
                          onSaved: (value) => _nombreServicio = value!,
                        ),
                        const SizedBox(height: 20.0),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Precio servicio',
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Por favor ingresa el precio que va  atener el servicio';
                            }
                            return null;
                          },
                          onSaved: (value) => _precioServicio = value!,
                        ),
                        const SizedBox(height: 20.0),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(15.0),
                          ),
                          child: const Text('Agregar'),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();

                              var res = await agregarServicio(
                                  nombre: _nombreServicio,
                                  precio: _precioServicio);
                                  if (res) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CustomDialog(
                                    isSuccess: true,
                                    descripcion:
                                        "Servicio Agregado correctamente.");
                              },
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CustomDialog(
                                    isSuccess: false,
                                    descripcion:
                                        "Error al momento de agregar el servicio.");
                              },
                            );
                          }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
