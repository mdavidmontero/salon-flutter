import 'package:flutter/material.dart';
import 'package:proyecto/models/item.dart';

class Agenda extends ChangeNotifier {
  Map<String, Item> _items = {};

  Map<String, Item> get items {
    return {..._items};
  }
}