import 'package:flutter/material.dart';
import 'package:proyecto/listaCitaEstilistasView.dart';
import 'package:proyecto/listaCitasUserView.dart';
import 'package:proyecto/productScreen.dart';
import 'package:proyecto/calendarScreen.dart';

class HomeEstilista extends StatefulWidget {
  final Map<String, dynamic> user;
  const HomeEstilista({Key? key, required this.user}) : super(key: key);
  @override
  _HomeEstilistaState createState() => _HomeEstilistaState();
}

class _HomeEstilistaState extends State<HomeEstilista> {
  int _currentIndex = 0;
  late List<Widget> _children;

  @override
  void initState() {
    super.initState();
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListasCitasEstilistasView(user: widget.user['identificacion'], userComplete:widget.user ,),
    );
  }
}
