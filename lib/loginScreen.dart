import 'package:flutter/material.dart';
import 'package:proyecto/AdminCitas.dart';
import 'package:proyecto/CItasProvider.dart';
import 'package:proyecto/home.dart';
import 'package:proyecto/homeEstilista.dart';
import 'package:proyecto/register.dart';
import 'package:proyecto/resdialog.dart';
import 'package:proyecto/services.dart';
import 'dart:ui';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _userType = 'Usuario';
  CitasProvider citasProvider = CitasProvider();

  @override
  Widget build(BuildContext context) {
    return Container(
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
                          'https://www.nuevamujer.com/resizer/TIJnE5phchTB29hCSPkS0V7fdH0=/800x0/filters:format(jpg):quality(70)/cloudfront-us-east-1.images.arcpublishing.com/metroworldnews/XVICHIDNVNAT3P3P5G7LH3EM3Y.jpg',
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      DropdownButton<String>(
                        value: _userType,
                        onChanged: (String? newValue) {
                          setState(() {
                            _userType = newValue!;
                          });
                        },
                        items: <String>['Usuario', 'Administrador', 'Estilista']
                            .map<DropdownMenuItem<String>>(
                              (String value) => DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              ),
                            )
                            .toList(),
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
                          if (value!.isEmpty) {
                            return 'Por favor ingresa tu correo electrónico';
                          }
                          return null;
                        },
                        onSaved: (value) => _email = value!,
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Contraseña',
                          border: OutlineInputBorder(),
                          filled: true,
                        fillColor: Colors.white,
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Por favor ingresa tu contraseña';
                          }
                          return null;
                        },
                        onSaved: (value) => _password = value!,
                      ),
                      const SizedBox(height: 20.0),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(15.0),
                        ),
                        child: const Text('Iniciar sesión'),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            print(
                                'Tipo de usuario: $_userType, Correo electrónico: $_email, Contraseña: $_password');
                            var res = await loginUsuario(
                                correo: _email,
                                pass: _password,
                                rol: _userType);
                            print(_userType);
                            if (res != null) {
                              print(res.data());
                              if (_userType == "Administrador") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AdminCitasScreen(
                                          citasProvider: citasProvider)),
                                );
                              }
                              if (_userType == "Usuario") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen(
                                            user: res.data()
                                                as Map<String, dynamic>,
                                          )),
                                );
                              }
                              if (_userType == "Estilista") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeEstilista(
                                            user: res.data()
                                                as Map<String, dynamic>,
                                          )),
                                );
                              }
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CustomDialog(
                                      isSuccess: true,
                                      descripcion: "Bienvenido!");
                                },
                              );
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CustomDialog(
                                      isSuccess: false,
                                      descripcion:
                                          "Error al momento de iniciar sesión.");
                                },
                              );
                            }
                          }
                        },
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        '¿Aún no tienes una cuenta?',
                        style: TextStyle(color: const Color.fromARGB(255, 8, 8, 8)),
                      ),
                      const SizedBox(height: 10.0),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(15.0),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterScreen()),
                          );
                        },
                        child: const Text('Registrarse'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
