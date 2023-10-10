import 'package:flutter/material.dart';

void showCustomDialog(BuildContext context, String title, String desc, String btnText) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(desc),
        
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              btnText,
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ],
      );
    },
  );
}