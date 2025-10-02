// Classe modelo de músicas (tracks)

class Track {
  // Atributos
  final String id; // ID da track no Spotify
  final String name; // Nome da Música
  final String artists; // Artistas (nomes juntados)
  final String imagePath; // URL da imagem da capa do álbum (local)

  double rating; // Nota que o usuário dará à música (de 0 a 5)

  // Construtor
  Track({
    required this.id,
    required this.name,
    required this.artists,
    required this.imagePath,
    this.rating = 0.0,
  });

  // Converter de um OBJ para modelo de dados para o FireStore
  // toMap OBJ => JSON
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "artists": artists,
      "imagePath": imagePath,
      "rating": rating,
    };
  }

  // Criar um Obj a partir dos dados do firestore
  // Fabricar um obj através de um json
  // fromMap Json => OBJ
  factory Track.fromMap(Map<String, dynamic> map) {
    return Track(
      id: map["id"],
      name: map["name"],
      artists: map["artists"],
      imagePath: map["imagePath"],
      rating: map["rating"] ?? 0.0,
    );
  }
}
