class Item {
  String id;
  String nombre;
  double precio;
  String unidad;
  String imagen;

  Item(
      {required this.id,
      required this.nombre,
      required this.precio,
      required this.unidad,
      required this.imagen});

  factory Item.map(dynamic o) {
    return Item(
        id: o['id'],
        nombre: o['nombre'],
        precio: o['precio'],
        unidad: o['unidad'],
        imagen: o['imagen']);
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map['id'] = id;
    map['nombre'] = nombre;
    map['precio'] = precio;
    map['unidad'] = unidad;
    map['imagen'] = imagen;

    return map;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['id'] = this.id;
    data['nombre'] = this.nombre;
    data['precio'] = this.precio;
    data['unidad'] = this.unidad;
    data['imagen'] = this.imagen;

    return data;
  }

  Item copyWith({
    String? id,
    String? nombre,
    double? precio,
    String? unidad,
    String? imagen,
  }) {
    return Item(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      precio: precio ?? this.precio,
      unidad: unidad ?? this.unidad,
      imagen: imagen ?? this.imagen,
    );
  }
}