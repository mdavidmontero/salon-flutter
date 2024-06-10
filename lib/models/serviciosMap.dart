class serviciosMap {
  final int id;
  final String nombre;
  final double precio;
  final String imagen;

  const serviciosMap(
      {required this.id,
      required this.nombre,
      required this.precio,
      required this.imagen});
}

final platos = [
  new serviciosMap(
      id: 1,
      nombre: 'Corte de pelo  + barba',
      precio: 45.500,
      imagen: '',)
];