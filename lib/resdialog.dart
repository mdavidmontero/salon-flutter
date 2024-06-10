import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final bool isSuccess;
  final String descripcion;

  CustomDialog({required this.isSuccess, required this.descripcion});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _buildDialogContent(context),
    );
  }

  Widget _buildDialogContent(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildIcon(),
          SizedBox(height: 16),
          Text(
            descripcion,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon() {
    return isSuccess
        ? Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 48,
          )
        : Icon(
            Icons.error,
            color: Colors.red,
            size: 48,
          );
  }
}