import 'dart:io';

import 'package:cine_favorite/controllers/firestore_controller.dart';
import 'package:cine_favorite/models/movie.dart';
import 'package:cine_favorite/views/search_movie_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavoriteView extends StatefulWidget {
  const FavoriteView({super.key});

  @override
  State<FavoriteView> createState() => _FavoriteViewState();
}

class _FavoriteViewState extends State<FavoriteView> {
  final _firestoreController = FirestoreController();

  void _showRatingDialog(Movie movie) {
    double tempRating = movie.rating;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Avaliar ${movie.title}"),
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
              _firestoreController.updateMovieRating(movie.id, tempRating);
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
        title: Text("Filmes Favoritos"),
        actions: [
          IconButton(
            onPressed: FirebaseAuth.instance.signOut, 
            icon: Icon(Icons.logout))
        ],
      ),
      // criar um gridView com os filmes favoritos
      body: StreamBuilder<List<Movie>>(
        stream: _firestoreController.getFavoriteMovies(), 
        builder: (context, snapshot){
          if(snapshot.hasError){
            return Center(child: Text("Erro ao carregar Lista de Filmes"),);
          }
          if(!snapshot.hasData){
            return Center(child:CircularProgressIndicator());
          }
          if(snapshot.data!.isEmpty){
            return Center(child: Text("Nenhum Filme adicionado ao Favoritos"),);
          }
          final favoriteMovies = snapshot.data!;
          return GridView.builder(
            padding: EdgeInsets.all(8),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.7),
              itemCount: favoriteMovies.length,
              itemBuilder:  (context, index){
              final movie = favoriteMovies[index];
              return Card(
                child: InkWell(
                  onTap: () => _showRatingDialog(movie),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Image.file(
                              File(movie.posterPath),
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(movie.title),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text("Nota: ${movie.rating == 0 ? 'Não avaliado' : movie.rating.toStringAsFixed(1)}"),
                          ),
                        ],
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: IconButton(
                          icon: Icon(Icons.delete, color: Colors.transparent),
                          onPressed: () => _firestoreController.removeFavoriteMovie(movie.id),
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
          MaterialPageRoute(builder: (context) => SearchMovieView()))),
    );
  }
}

