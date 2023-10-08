import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<void> fetchData() async {
  final response = await http.get(Uri.parse(
      'https://pk32nv4d-8080.euw.devtunnels.ms/api/v1/auth/register'));
  if (response.statusCode == 200) {
    // Успешно получили ответ
    print('Тело ответа: ${response.body}');
  } else {
    // Обработка ошибок
    print('Ошибка: ${response.statusCode}');
  }
}

Future<void> sendData() async {
  String rawData =
      '{"username": "alex","password": "123fwef1","image": "sorry"}';
  final response = await http.post(
    Uri.parse('https://pk32nv4d-8080.euw.devtunnels.ms/api/v1/auth/register'),
    headers: {"Content-Type": "application/json"},
    body: rawData,
  );
  if (response.statusCode == 200) {
    // Успешно отправили данные и получили ответ
    print('Тело ответа: ${response.body}');
  } else {
    // Обработка ошибок
    print('Ошибка: ${response.statusCode}');
  }
}
