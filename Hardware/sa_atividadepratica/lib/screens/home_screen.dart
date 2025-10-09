import 'dart:io';
import 'package:flutter/material.dart';
import '../models/photo_model.dart';
import '../services/photo_service.dart';
import 'photo_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PhotoService _photoService = PhotoService();
  List<PhotoModel> _photos = [];

  void _takePhoto() async {
    final photo = await _photoService.takePhoto();
    if (photo != null) {
      setState(() {
        _photos.add(photo);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Galeria de Fotos')),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        onPressed: _takePhoto,
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(10),
        itemCount: _photos.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemBuilder: (ctx, index) {
          final photo = _photos[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PhotoDetailScreen(photo: photo),
                ),
              );
            },
            child: Image.file(
              File(photo.path),
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}
