import 'dart:io';

import 'package:cine_favorite/controllers/firestore_controller.dart';
import 'package:cine_favorite/models/track.dart';
import 'package:cine_favorite/views/search_track_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavoriteView extends StatefulWidget {
  const FavoriteView({super.key});

  @override
  State<FavoriteView> createState() => _FavoriteViewState();
}

class _FavoriteViewState extends State<FavoriteView> {
  final _firestoreController = FirestoreController();

  void _showRatingDialog(Track track) {
    double tempRating = track.rating;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Avaliar ${track.name}"),
        content: StatefulBuilder(
          builder: (context, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Nota: ${tempRating.toStringAsFixed(1)}"),
              Slider(
                value: tempRating,
                min: 0,
                max: 5,
                divisions: 10,
                onChanged: (value) {
                  setState(() {
                    tempRating = value;
                  });
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              _firestoreController.updateTrackRating(track.id, tempRating);
              Navigator.pop(context);
            },
            child: Text("Salvar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Músicas Favoritas"),
        actions: [
          IconButton(
            onPressed: FirebaseAuth.instance.signOut,
            icon: Icon(Icons.logout))
        ],
      ),
      // criar um gridView com as músicas favoritas
      body: StreamBuilder<List<Track>>(
        stream: _firestoreController.getFavoriteTracks(),
        builder: (context, snapshot){
          if(snapshot.hasError){
            return Center(child: Text("Erro ao carregar Lista de Músicas"),);
          }
          if(!snapshot.hasData){
            return Center(child:CircularProgressIndicator());
          }
          if(snapshot.data!.isEmpty){
            return Center(child: Text("Nenhuma Música adicionada aos Favoritos"),);
          }
          final favoriteTracks = snapshot.data!;
          return GridView.builder(
            padding: EdgeInsets.all(8),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.7),
              itemCount: favoriteTracks.length,
              itemBuilder:  (context, index){
              final track = favoriteTracks[index];
              return Card(
                child: InkWell(
                  onTap: () => _showRatingDialog(track),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Image.file(
                              File(track.imagePath),
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(track.name),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text("Artistas: ${track.artists}"),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text("Nota: ${track.rating == 0 ? 'Não avaliado' : track.rating.toStringAsFixed(1)}"),
                          ),
                        ],
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _firestoreController.removeFavoriteTrack(track.id),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            });
        }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context,
          MaterialPageRoute(builder: (context) => SearchTrackView()))),
    );
  }
}