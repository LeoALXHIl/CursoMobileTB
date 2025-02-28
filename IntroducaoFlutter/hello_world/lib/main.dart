import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp()); // roda minha aplicação
}

class MainApp extends StatelessWidget { // janela de aplicação
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) { // Base de Construção
    return const MaterialApp(
      home: Scaffold( //modelo de pagina
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}

