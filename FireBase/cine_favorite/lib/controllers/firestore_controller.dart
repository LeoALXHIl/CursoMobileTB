//gerenciar o relacionamento do aplicativo com o FireStore DataBase

import 'dart:io';
import 'package:cine_favorite/models/track.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class FirestoreController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  
  //método para pegar o usuário atual
  User? get currentUser => _auth.currentUser;

  // Vamos criar um listener => pegar a lista de músicas favoritas
  // Chama a mudança toda vez que alterar uma música da baseDados favorite_tracks
  Stream<List<Track>> getFavoriteTracks() { // lista salva no FireBase
  // Não é a lista da API
  // Se usuário == null, retorna uma lista vazia
    if (currentUser == null) return Stream.value([]);
    // Caso contrário
    return _db
    .collection("users")
    .doc(currentUser!.uid)
    .collection("favorite_tracks")
    .snapshots() // Memória instantânea do aplicativo
    .map((snapshot) =>
    // Converte cada doc do BD em Obj da classe Track
      snapshot.docs.map((doc) => Track.fromMap(doc.data())).toList());
  }

  // Adicionar uma música à lista de favoritos
  void addFavoriteTrack(Map<String, dynamic> trackData) async {
    // Carregar imagem diretamente do cache do aplicativo
    if (trackData["album"]?["images"]?.isNotEmpty != true || currentUser == null) return; // Se música não tiver imagem, não armazena

    // Baixando a imagem da capa do álbum
    final images = trackData["album"]["images"] as List;
    final imagemUrl = images.isNotEmpty ? images.last["url"] : ""; // Usar a menor imagem disponível
    final responseImg = await http.get(Uri.parse(imagemUrl));

    // Armazenar a imagem no cache do aplicativo
    final tempDir = await getApplicationDocumentsDirectory(); // Armazenar imagem no aplicativo
    final file = File("${tempDir.path}/${trackData["id"]}.jpg");
    await file.writeAsBytes(responseImg.bodyBytes);

    // Criar a música
    final artists = (trackData["artists"] as List).map((a) => a["name"] as String).join(', ');
    final track = Track(
      id: trackData["id"],
      name: trackData["name"],
      artists: artists,
      imagePath: file.path,
    );

    // Armazenar no Firestore
    await _db.collection("users").doc(currentUser!.uid)
        .collection("favorite_tracks").doc(track.id).set(track.toMap());
    // Doc é criado com o id = ao do Spotify
  }

  // Remover uma música da lista de favoritos
  void removeFavoriteTrack(String trackID) async {
    if (currentUser == null) return; // Verifica se o usuário não é nulo
    await _db.collection("users").doc(currentUser!.uid)
        .collection("favorite_tracks").doc(trackID).delete(); // Deleta o doc da base de dados

    // Deletar a imagem do cache do aplicativo
    final imagemPath = await getApplicationDocumentsDirectory();
    final imagemFile = File("${imagemPath.path}/$trackID.jpg");
    try {
      await imagemFile.delete();
    } catch (e) {
      // Log error without print in production
    }
  }
  // Update avaliação
  void updateTrackRating(String trackID, double rating) async {
    if (currentUser == null) return;
    await _db.collection("users").doc(currentUser!.uid)
        .collection("favorite_tracks").doc(trackID).update({"rating": rating});
  }
}