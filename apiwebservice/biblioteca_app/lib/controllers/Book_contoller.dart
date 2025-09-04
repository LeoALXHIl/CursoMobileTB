
import 'package:biblioteca_app/models/books.dart';
import 'package:biblioteca_app/services/api_service.dart';

class BookController {
  //obs: não precisa instaciar obj de ApiService (métodos static)

  //métodos
  // GET dos Usuários
  Future<List<BookModel>> fetchAll() async{
    final list = await ApiService.getList("books?_sort=name"); //?_sort=name -> flag para organizar em order alfabetica
    //retorna a Lista de Usuário Convertidas para Book Model List<dynamic> => List<OBJ>
    return list.map<BookModel>((item)=>BookModel.fromMap(item)).toList();
  }

  // POST -> Criar novo usuário
  Future<BookModel> create(BookModel u) async{
    final created  = await ApiService.post("books", u.toMap());
    // adiciona um Usuário e Retorna o Usuário Criado -> ID
    return BookModel.fromMap(created);
  }

  // GET -> Buscar um Usuário
  Future<BookModel> fetchOne(String id) async{
    final book = await ApiService.getOne("books", id);
    // Retorna o Usuário Encontrado no Banco de Dados
    return BookModel.fromMap(book);
  }

  // PUT -> Atualizar Usuário
  Future<BookModel> update(BookModel u) async{
    final updated = await ApiService.put("books", u.toMap(), u.id!);
    //REtorna o Usuário Atualizado
    return BookModel.fromMap(updated);
  }

  Future<void> delete(String id) async{
    await ApiService.delete("books", id);
    // Não há retorno, usuário deletado com sucesso
  }
}
