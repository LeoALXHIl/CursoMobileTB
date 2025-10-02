// tela de busca de músicas

import 'package:cine_favorite/controllers/firestore_controller.dart';
import 'package:cine_favorite/controllers/spotify_controller.dart';
import 'package:flutter/material.dart';

class SearchTrackView extends StatefulWidget {
  const SearchTrackView({super.key});

  @override
  State<SearchTrackView> createState() => _SearchTrackViewState();
}

class _SearchTrackViewState extends State<SearchTrackView> {
  //atributos

  final _firestoreController = FirestoreController();
  final _searchField = TextEditingController();
  List<Map<String,dynamic>> _searchResults = [];
  bool _isloading = false;

  void _searchTracks() async{
    final query = _searchField.text.trim();
    print("Search triggered for query: '$query'");
    if(query.isEmpty) {
      print("Query is empty, aborting search");
      return; // para o metodo se o campo estiver vazio
    }
    setState(() {
      _isloading = true;
    });
    try{ // tenta conectar com a API
    //aqui armazena o resultado da busca
      print("Calling SpotifyController.searchTracks...");
      final resultado = await SpotifyController.searchTracks(query);
      print("Search successful, results count: ${resultado.length}");
      setState(() {
        //aqui passa o resultado para a lista
        _searchResults = resultado;
        _isloading = false;
      });
    }catch(e){
      print("Search error caught: $e");
      setState(() {
        _isloading = false;
        _searchResults = [];
      });
      //mostrar um aviso de erro
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao Buscar Músicas: $e"))
        );
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Buscar Música'),),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _searchField,
              decoration: InputDecoration(
                labelText: "Nome da Música",
                border: OutlineInputBorder(),
                suffix: IconButton(
                  onPressed: _searchTracks,
                  icon: Icon(Icons.search))),
            ),
            SizedBox(height: 10,),
            Expanded(
              child: _isloading 
                ? const Center(child: CircularProgressIndicator())
                : _searchResults.isEmpty 
                  ? const Center(child: Text("Nenhuma Música Encontrada"))
                  : ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index){
                        final track = _searchResults[index];
                        final artists = (track["artists"] as List).map((a) => a["name"] as String).join(', ');
                        return ListTile(
                          //exibir a lista de Músicas
                          title: Text(track["name"]),
                          subtitle: Text(artists),
                          trailing: IconButton(
                            onPressed: ()async{
                              //adicionar a música aos favoritos
                              _firestoreController.addFavoriteTrack(track);
                              // Mostrar um aviso
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("${track["name"]} Adicionado aos Favoritos"))
                                );
                              }
                              Navigator.pop(context); //volto pra tela de favoritos
                            },
                           icon: Icon(Icons.add)),
                        );
                      },
                    ),
            )
          ],
        ),),
    );
  }
}
