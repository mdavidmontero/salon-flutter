import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:proyecto/resdialog.dart';
import 'package:proyecto/services.dart';

class UserAdd extends StatefulWidget {
  const UserAdd({Key? key}) : super(key: key);

  @override
  _UserAddState createState() => _UserAddState();
}

class _UserAddState extends State<UserAdd> {
  final _formKey = GlobalKey<FormState>();
  String _identification = '';
  String _name = '';
  String _email = '';
  String _selectedRole = 'Usuario';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Agregar Usuarios"),
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
                            labelText: 'Identificación',
                            border: OutlineInputBorder(),
                            filled: true,
                        fillColor: Colors.white,
                          ),
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
                          validator: (value) {
                            if (value!.isEmpty || !value.contains('@')) {
                              return 'Ingresa un correo electrónico válido';
                            }
                            return null;
                          },
                          onSaved: (value) => _email = value!,
                        ),
                        const SizedBox(height: 20.0),
                        DropdownButton<String>(
                          value: _selectedRole,
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedRole = newValue!;
                            });
                          },
                          items:
                              <String>['Usuario', 'Administrador', 'Estilista']
                                  .map<DropdownMenuItem<String>>(
                                    (String value) => DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    ),
                                  )
                                  .toList(),
                        ),
                        const SizedBox(height: 20.0),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(15.0),
                          ),
                          child: const Text('Agregar'),
                          onPressed: () async{
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                             var res = await agregarUsuario(
                              correo: _email,
                              identificacion: _identification,
                              nombre: _name,
                              rol: _selectedRole,
                              pass: _identification);
                          if (res) {
                            Navigator.pop(context);
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CustomDialog(
                                    isSuccess: true,
                                    descripcion:
                                        "Usuario agregado correctamente");
                              },
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CustomDialog(
                                    isSuccess: false,
                                    descripcion:
                                        "Error al momento de agregar el usuario.");
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
