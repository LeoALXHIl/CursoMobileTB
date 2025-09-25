// tela de busca de filmes

import 'package:cine_favorite/controllers/firestore_controller.dart';
import 'package:cine_favorite/controllers/tmdb_controller.dart';
import 'package:flutter/material.dart';

class SearchMovieView extends StatefulWidget {
  const SearchMovieView({super.key});

  @override
  State<SearchMovieView> createState() => _SearchMovieViewState();
}

class _SearchMovieViewState extends State<SearchMovieView> {
  //atributos

  final _firestoreController = FirestoreController();
  final _searchField = TextEditingController();
  List<Map<String,dynamic>> _searchResults = [];
  bool _isloading = false;

  void _searchMovies() async{
    final query = _searchField.text.trim();
    if(query.isEmpty) return; // para o metodo se o campo estiver vazio
    setState(() {
      _isloading = true;
    });
    try{ // tenta conectar com a API
    //aqui armazena o resultado da busca 
      final resultado = await TmdbController.searchMovies(query);
      setState(() {
        //aqui passa o resultado para a lista
        _searchResults = resultado;
        _isloading = false;
      });
    }catch(e){
      setState(() {
        _isloading = false;
        _searchResults = [];
      });
      //mostrar um aviso de erro
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao Buscar Filmes: $e"))
        );
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Buscar Filme'),),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _searchField,
              decoration: InputDecoration(
                labelText: "Nome do Filme",
                border: OutlineInputBorder(),
                suffix: IconButton(
                  onPressed: _searchMovies, 
                  icon: Icon(Icons.search))),
            ),
            SizedBox(height: 10,),
            // operador Ternario
            _isloading ? CircularProgressIndicator()
            : _searchResults.isEmpty ? Text("Nenhum Filme Encontrado")
            : Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index){
                  final movie = _searchResults[index];
                  return ListTile(
                    //exibir a lista de Filmes
                    title: Text(movie["title"]),
                    subtitle: Text(movie["release_date"]),
                    trailing: IconButton(
                      onPressed: ()async{
                        //adicionar o filme aos favoritos
                        _firestoreController.addFavoriteMovie(movie);
                        // Mostrar um aviso 
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("${movie["title"]} Adicionado aos Favoritos"))
                        );
                        Navigator.pop(context); //volto pra tela de favoritos
                        
                      },
                     icon: Icon(Icons.add)),
                  );
                },
              ) ,)
          ],
        ),),
    );
  }
}

// crie a opção de colocar uma nota para o filme
// e exiba essa nota na tela de favoritos
// e salve essa nota no Firestore
// permita deletar o filme da lista de favoritos
// e delete a imagem do cache do aplicativo