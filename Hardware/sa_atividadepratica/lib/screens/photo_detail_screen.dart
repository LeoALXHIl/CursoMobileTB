import 'package:flutter/material.dart';
import '../models/photo_model.dart';
import 'dart:io';

class PhotoDetailScreen extends StatelessWidget {
  final PhotoModel photo;

  PhotoDetailScreen({required this.photo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detalhes da Foto')),
      body: Column(
        children: [
          Image.file(File(photo.path)),
          SizedBox(height: 20),
          Text('Data/Hora: ${photo.dateTime}'),
          Text('Cidade: ${photo.city ?? 'Desconhecida'}'),
        ],
      ),
    );
  }
}
