import 'package:proyecto/citas.dart';

class CitasProvider {
  List<Cita> citas = [];

  void agregarCita(Cita cita) {
    citas.add(cita);
  }

  void actualizarCita(Cita cita) {
    // Implementa la lógica para actualizar la cita en la lista
  }

  void eliminarCita(int citaId) {
    // Implementa la lógica para eliminar la cita de la lista
  }
}
