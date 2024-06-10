import 'package:flutter/material.dart';
import 'package:proyecto/resdialog.dart';
import 'package:proyecto/services.dart';
import 'dart:ui';

class ProfilePage extends StatefulWidget {
  final Map<String, dynamic>? userComplete;
  final bool isEdit;
  const ProfilePage(
      {Key? key, required this.userComplete, required this.isEdit})
      : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late String _identification;
  late String _name;
  late String _email;
  late String _selectedRole;
  late String _password;
  late String _direccion;
  late String _telefono;
  late String _edad;

  @override
  void initState() {
    super.initState();
    _identification = widget.userComplete!['identificacion'] ?? '';
    _name = widget.userComplete!['nombre'] ?? '';
    _email = widget.userComplete!['correo'] ?? '';
    _selectedRole = widget.userComplete!['rol'] ?? '';
    _password = widget.userComplete!['pass'] ?? '';
    _direccion = widget.userComplete!['direccion'] ?? '';
    _telefono = widget.userComplete!['telefono'] ?? '';
    _edad = widget.userComplete!['_edad'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Perfil"),
      ),
      body: Container(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(children: <Widget>[
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(
                  color: Colors.black.withOpacity(0),
                ),
              ),
            ),
            Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 90.0,
                      backgroundImage: NetworkImage(
                          'https://img.freepik.com/vector-premium/diseno-logotipo-vectorial-salon-belleza-o-peluqueria-o-diseno-cosmetico-ilustracion-vector-concepto-linea-cara-mujer-abstracta_501705-134.jpg'),
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Identificación',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      initialValue: _identification,
                      enabled: false,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Por favor ingresa tu identificación';
                        }
                        return null;
                      },
                      onSaved: (value) => _identification = value!,
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Nombre',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      initialValue: _name,
                      enabled: widget.isEdit,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Por favor ingresa tu nombre';
                        }
                        return null;
                      },
                      onSaved: (value) => _name = value!,
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Correo electrónico',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      initialValue: _email,
                      enabled: false,
                      validator: (value) {
                        if (value!.isEmpty || !value.contains('@')) {
                          return 'Ingresa un correo electrónico válido';
                        }
                        return null;
                      },
                      onSaved: (value) => _email = value!,
                    ),
                    const SizedBox(height: 20.0),
                    Visibility(
                      visible:
                          widget.isEdit, // mostrarCampo es tu variable booleana
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Contraseña',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        initialValue: _password,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Ingresa una contraseña válida';
                          }
                          return null;
                        },
                        onSaved: (value) => _password = value!,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Teléfono',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      initialValue: _telefono,
                      enabled: widget.isEdit,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Ingresa un teléfono válido';
                        }
                        return null;
                      },
                      onSaved: (value) => _telefono = value!,
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Dirección',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      initialValue: _direccion,
                      enabled: widget.isEdit,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Ingresa una dirección válida';
                        }
                        return null;
                      },
                      onSaved: (value) => _direccion = value!,
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Edad',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      initialValue: _edad,
                      enabled: widget.isEdit,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Ingresa una edad';
                        }
                        return null;
                      },
                      onSaved: (value) => _edad = value!,
                    ),
                    const SizedBox(height: 20.0),
                    Visibility(
                      visible: widget.isEdit,
                      child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(15.0),
                      ),
                      child: const Text('Actualizar'),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          var res = await actualizarUsuario(
                              correo: _email,
                              identificacion: _identification,
                              nombre: _name,
                              rol: _selectedRole,
                              pass: _password,
                              direccion: _direccion,
                              edad: _edad,
                              telefono: _telefono);
                          if (res) {
                            Navigator.pop(context);
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CustomDialog(
                                    isSuccess: true,
                                    descripcion:
                                        "Usuario Actualizado correctamente");
                              },
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CustomDialog(
                                    isSuccess: false,
                                    descripcion:
                                        "Error al momento de actualizar el usuario.");
                              },
                            );
                          }
                        }
                      },
                    )),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
