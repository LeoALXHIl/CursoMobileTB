class BookModel {
  //atributos
  final String? id;
  final String title;
  final String author;
  final bool available;

  //construtor
  BookModel({
    this.id,
    required this.title,
    required this.author,
    required this.available
  });

  // métodos ToMap e FromMap
  Map<String,dynamic> toMap() {
    final Map<String, dynamic> data = {
      "title": title,
      "author": author,
      "available": available
    };
    if (id != null) {
      data["id"] = id;
    }
    return data;
  }

  factory BookModel.fromMap(Map<String,dynamic> map)=>
  BookModel(
    id: map["id"]?.toString(),
    title: map["title"]?.toString() ?? '',
    author: map["author"]?.toString() ?? '',
    available: map["available"] == true || map["avaliable"] == true);

}
