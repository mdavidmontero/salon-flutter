import 'package:cloud_firestore/cloud_firestore.dart';

Future<bool> agregarUsuario(
    {required String identificacion,
    required String nombre,
    required String correo,
    required String rol,
    required String pass}) async {
  try {
    bool identificacionExistente =
        await verificarExistencia('identificacion', identificacion);
    bool correoExistente = await verificarExistencia('correo', correo);

    if (identificacionExistente) {
      print(
          'La identificación ya está en uso. No se puede agregar el usuario.');
      return false;
    }

    if (correoExistente) {
      print('El correo ya está en uso. No se puede agregar el usuario.');
      return false;
    }
    await FirebaseFirestore.instance.collection('users').add({
      'identificacion': identificacion,
      'nombre': nombre,
      'correo': correo,
      'rol': rol,
      'pass': pass
    });

    print('Usuario agregado correctamente');
    return true;
  } catch (e) {
    print('Error al agregar usuario: $e');
    return false;
  }
}

Future<bool> actualizarUsuario({
  required String identificacion,
  required String nombre,
  required String correo,
  required String rol,
  required String pass,
  required String direccion,
  required String telefono,
  required String edad,
}) async {
  try {
    // Verificar si el usuario existe
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('identificacion', isEqualTo: identificacion)
        .get();

    if (querySnapshot.docs.isEmpty) {
      print('El usuario con identificación $identificacion no existe.');
      return false;
    }

    // Actualizar los datos del usuario
    await querySnapshot.docs.first.reference.update({
      'nombre': nombre,
      'correo': correo,
      'rol': rol,
      'pass': pass,
      'direccion': direccion,
      'telefono': telefono,
      'edad': edad,
    });

    print('Usuario actualizado correctamente');
    return true;
  } catch (e) {
    print('Error al actualizar usuario: $e');
    return false;
  }
}

Future<bool> agregarServicio(
    {required String nombre,
    required String precio,
}) async {
  try {
    await FirebaseFirestore.instance.collection('servicios').add({
      'precio': precio,
      'nombre': nombre,
    });

    print('Usuario agregado correctamente');
    return true;
  } catch (e) {
    print('Error al agregar usuario: $e');
    return false;
  }
}

Future<bool> actualizarCita(
    {required String idCita,
    required String nuevaFecha,
    required String nuevaHora,
    required String estado}) async {
  try {
    CollectionReference citasCollection = FirebaseFirestore.instance.collection('citas');
    QuerySnapshot citas = await citasCollection.where('id', isEqualTo: idCita).get();

    if (citas.docs.isEmpty) {
      print('No se encontró la cita con el ID proporcionado.');
      return false;
    }

    await citas.docs.first.reference.update({
      'fecha': nuevaFecha,
      'hora': nuevaHora,
      'estado': estado
    });

    print('Cita actualizada correctamente');
    return true;
  } catch (e) {
    print('Error al actualizar cita: $e');
    return false;
  }
}

Future<bool> eliminarCita({required String idCita}) async {
  try {
    CollectionReference citasCollection = FirebaseFirestore.instance.collection('citas');
    QuerySnapshot citas = await citasCollection.where('id', isEqualTo: idCita).get();

    if (citas.docs.isEmpty) {
      print('No se encontró la cita con el ID proporcionado.');
      return false;
    }

    await citas.docs.first.reference.delete();

    print('Cita eliminada correctamente');
    return true;
  } catch (e) {
    print('Error al eliminar cita: $e');
    return false;
  }
}

Future<bool> verificarExistencia(String campo, String valor) async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection('users')
      .where(campo, isEqualTo: valor)
      .get();

  return querySnapshot.docs.isNotEmpty;
}

Future<DocumentSnapshot?> loginUsuario({
  required String correo,
  required String pass,
  required String rol,
}) async {
  try {
    var query = await FirebaseFirestore.instance
        .collection('users')
        .where('correo', isEqualTo: correo)
        .where('pass', isEqualTo: pass)
        .where('rol', isEqualTo: rol)
        .get();

    if (query.docs.isNotEmpty) {
      return query.docs[0];
    } else {
      return null;
    }
  } catch (e) {
    print('Error al realizar el inicio de sesión: $e');
    return null;
  }
}

Future<List<Map<String, dynamic>>> obtenerEstilistas() async {
  try {
    var querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('rol', isEqualTo: 'Estilista')
        .get();

    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  } catch (e) {
    print('Error al obtener estilistas: $e');
    return [];
  }
}

Future<Map<String, dynamic>?> obtenerPorId(String idEstilista) async {
  try {
    var querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('identificacion', isEqualTo: idEstilista)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.data() as Map<String, dynamic>;
    } else {
      return null; // No se encontró ningún estilista con la identificación dada
    }
  } catch (e) {
    print('Error al obtener estilista: $e');
    return null;
  }
}

Future<List<Map<String, dynamic>>> obtenerTiposPagos() async {
  try {
    var querySnapshot = await FirebaseFirestore.instance
        .collection('tipos_pagos')
        .get();

    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  } catch (e) {
    print('Error al obtener los tipos de pagos: $e');
    return [];
  }
}

Future<List<Map<String, dynamic>>> obtenerUsuarios(String role) async {
  try {
    var querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('rol', isEqualTo: role)
        .get();

    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  } catch (e) {
    print('Error al obtener estilistas: $e');
    return [];
  }
}

Future<List<Map<String, dynamic>>> obtenerServicios() async {
  try {
    var querySnapshot = await FirebaseFirestore.instance
        .collection('servicios')
        .get();

    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  } catch (e) {
    print('Error al obtener los servicios: $e');
    return [];
  }
}

Future<bool> guardarCita(
    {required String idCliente,
    required String idEstilista,
    required String fecha,
    required String hora,
    required String nombreEstilista,
    required String nombreCliente,
    required String tipoPago,
    required String servicio,
    required String ValorServicio}) async {
  try {
    // Obtener la referencia a la colección 'citas'
    CollectionReference citasCollection =
        FirebaseFirestore.instance.collection('citas');

    // Obtener la cantidad actual de citas
    QuerySnapshot citas = await citasCollection.get();
    int totalCitas = citas.docs.length;

    // Incrementar el total para obtener el nuevo ID
    int nuevoId = totalCitas + 1;

    // Guardar la nueva cita con el nuevo ID
    await citasCollection.add({
      'id':
          nuevoId.toString(), // Convierte a String si el ID debe ser una cadena
      'idCliente': idCliente,
      'idEstilista': idEstilista,
      'fecha': fecha,
      'hora': hora,
      'nombreEstilista': nombreEstilista,
      'nombreCliente': nombreCliente,
      'tipoPago': tipoPago,
      'servicio': servicio,
      'valorServicio': ValorServicio,
      'estado': "Pendiente"
    });

    print('Cita guardada correctamente');
    return true;
  } catch (e) {
    print('Error al guardar cita: $e');
    return false;
  }
}

Future<List<Map<String, dynamic>?>> obtenerCitasPorUsuario(
    String idUsuario) async {
  try {
    List<Map<String, dynamic>?> citas = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('citas')
        .where('idCliente', isEqualTo: idUsuario)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      citas = documentSnapshotsToList(querySnapshot.docs);
    }
    return citas;
  } catch (e) {
    print('Error al obtener citas por usuario: $e');
    return [];
  }
}

Future<List<Map<String, dynamic>?>> obtenerCitasPorEstilistas(
    String idUsuario) async {
  try {
    List<Map<String, dynamic>?> citas = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('citas')
        .where('idEstilista', isEqualTo: idUsuario)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      citas = documentSnapshotsToList(querySnapshot.docs);
    }
    return citas;
  } catch (e) {
    print('Error al obtener citas por usuario: $e');
    return [];
  }
}

Future<List<Map<String, dynamic>?>> obtenerCitasPorUsuarios(
    String idUsuario) async {
  try {
    List<Map<String, dynamic>?> plants = [];
    QuerySnapshot collectionReference = await FirebaseFirestore.instance
        .collection('citas')
        .where('idCliente', isEqualTo: idUsuario)
        .get();

    if (collectionReference.docs.isNotEmpty) {
      plants = documentSnapshotsToList(collectionReference.docs);
    }
    return plants;
  } catch (e) {
    print('Error al obtener citas por usuario: $e');
    return [];
  }
}

Future<List<Map<String, dynamic>?>> getCitasy() async {
  FirebaseFirestore db = FirebaseFirestore.instance;
  List<Map<String, dynamic>?> plants = [];
  CollectionReference collectionReference = db.collection('citas');
  QuerySnapshot queryPlants = await collectionReference.get();

  if (queryPlants.docs.isNotEmpty) {
    plants = documentSnapshotsToList(queryPlants.docs);
  }
  return plants;
}

List<Map<String, dynamic>?> documentSnapshotsToList(
    List<QueryDocumentSnapshot> documents) {
  List<Map<String, dynamic>?> resultList = [];
  for (var document in documents) {
    Map<String, dynamic>? data = documentSnapshotToMap(document);
    resultList.add(data);
  }
  return resultList;
}

Map<String, dynamic>? documentSnapshotToMap(QueryDocumentSnapshot document) {
  if (document == null || !document.exists) {
    return null;
  }

  Map<String, dynamic> data = document.data() as Map<String, dynamic>;
  return data;
}
