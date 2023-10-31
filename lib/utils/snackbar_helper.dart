import 'package:flutter/material.dart';
 void showErrorMessage(BuildContext context,{required String message}) {
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(message),
      ),
    );
  }
