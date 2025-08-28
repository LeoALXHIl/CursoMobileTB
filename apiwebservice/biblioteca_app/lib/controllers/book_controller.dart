import 'package:biblioteca_app/models/books.dart';
import 'package:biblioteca_app/services/api_service.dart';

class BookController {
  // Buscar todos os livros
  Future<List<BookModel>> fetchAll() async {
    final list = await ApiService.getList("books");
    return list.map<BookModel>((item) => BookModel.fromMap(item)).toList();
  }

  // Atualizar livro
  Future<BookModel> update(BookModel book) async {
    final updated = await ApiService.put("books", book.toMap(), book.id!);
    return BookModel.fromMap(updated);
  }
}
