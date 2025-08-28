import 'package:biblioteca_app/controllers/Book_contoller.dart';
import 'package:biblioteca_app/models/books.dart';
import 'package:biblioteca_app/views/book/book_form_view.dart';
import 'package:biblioteca_app/views/loan/loan_form_view.dart';
import 'package:flutter/material.dart';

class BookListView extends StatefulWidget {
    const BookListView({super.key});

    @override
    State<BookListView> createState() => _BookListViewState();
}

class _BookListViewState extends State<BookListView> {
    final _controller = BookController();
    List<BookModel> _books = [];
    bool _loading = true;
    List<BookModel> _filteredBooks = [];
    final _searchController = TextEditingController();

    @override
    void initState() {
        super.initState();
        _load();
    }

    void _load() async {
        setState(() => _loading = true);
        try {
            _books = await _controller.fetchAll();
            _filteredBooks = _books.where((book) => book.avaliable == true).toList();
        } catch (e) {
            // tratar erro aqui
        }
        setState(() => _loading = false);
    }

    void _booksFilter() {
        final query = _searchController.text.toLowerCase();
        setState(() {
            _filteredBooks = _books.where((book) {
                return book.title.toLowerCase().contains(query) ||
                        book.author.toLowerCase().contains(query);
            }).toList();
        });
    }

    void _openForm({BookModel? book}) async {
        await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BookFormView(book: book)),
        );
        _load();
    }

    void _emprestarLivro(BookModel book) async {
        await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => LoanFormView(),
                settings: RouteSettings(arguments: book),
            ),
        );
        _load();
    }

    void _delete(BookModel book) async {
        if (book.id == null) return;
        final confirm = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
                title: Text("Confirmar Exclusão"),
                            content: Text("Deseja realmente excluir o livro ${book.title}?"),
                            actions: [
                                TextButton(
                                        onPressed: () => Navigator.pop(context, false),
                                        child: Text("Cancelar")),
                                TextButton(
                                        onPressed: () => Navigator.pop(context, true),
                                        child: Text("Excluir")),
                            ],
                        ));

        if (confirm == true) {
            try {
                await _controller.delete(book.id!);
                _load();
            } catch (e) {
                // criar uma mensagem de erro
            }
        }
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text('Lista de Livros'),
                actions: [
                    IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () => _openForm(),
                    ),
                ],
            ),
            body: Column(
                children: [
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                                labelText: 'Pesquisar',
                                prefixIcon: Icon(Icons.search),
                                border: OutlineInputBorder(),
                            ),
                            onChanged: (value) => _booksFilter(),
                        ),
                    ),
                    Expanded(
                        child: _loading
                            ? Center(child: CircularProgressIndicator())
                            : ListView.builder(
                                itemCount: _filteredBooks.length,
                                itemBuilder: (context, index) {
                                    final book = _filteredBooks[index];
                                    return Card(
                                        child: ListTile(
                                            title: Text(book.title),
                                            subtitle: Text(book.author),
                                            trailing: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                    IconButton(
                                                        icon: Icon(Icons.edit),
                                                        onPressed: () => _openForm(book: book),
                                                    ),
                                                    IconButton(
                                                        icon: Icon(Icons.delete),
                                                        onPressed: () => _delete(book),
                                                    ),
                                                    IconButton(
                                                        icon: Icon(Icons.assignment_return),
                                                        onPressed: () => _emprestarLivro(book),
                                                    ),
                                                ],
                                            ),
                                        ),
                                    );
                                },
                            ),
                    ),
                ],
            ),
        );
    }

// INVEZ DE MOSTRAR ID DO LIVRO E ID DO USUARIO MOSTRAR O NOME DO LIVRO E NOME DO USUARIO
//CARREGAR LISTAS DE USUARIOS E LIVROS
//CRIAÇÃO DE UM FILTRO DE PESQUISA 
//QUERY CARREGAR LISTA DE EMPRESTIMOS
//CRIAR UMA TELA DE DETALHES DO EMPRESTIMO 
}