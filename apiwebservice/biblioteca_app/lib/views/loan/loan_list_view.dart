import 'package:biblioteca_app/views/loan/loan_form_view.dart';
import 'package:flutter/material.dart';
import 'package:biblioteca_app/models/loans.dart';
import 'package:biblioteca_app/models/users.dart';
import 'package:biblioteca_app/models/books.dart';
import 'package:biblioteca_app/services/api_service.dart';

class LoanListView extends StatefulWidget {
  const LoanListView({super.key});

  @override
  State<LoanListView> createState() => _LoanListViewState();
}

class _LoanListViewState extends State<LoanListView> {
  List<LoansModel> _loans = [];
  List<UserModel> _users = [];
  List<BookModel> _books = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final loansList = await ApiService.getList("loans");
      final usersList = await ApiService.getList("users");
      final booksList = await ApiService.getList("books");
      setState(() {
        _loans = loansList.map<LoansModel>((item) => LoansModel.fromJson(item)).toList();
        _users = usersList.map<UserModel>((item) => UserModel.fromJson(item)).toList();
        _books = booksList.map<BookModel>((item) => BookModel.fromMap(item)).toList();
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
      // Pode mostrar um erro na tela se quiser
    }
  }

  String _getUserName(String? userId) {
    final user = _users.firstWhere(
      (u) => u.id == userId,
      orElse: () => UserModel(id: '', name: 'Desconhecido', email: ''),
    );
    return user.name;
  }

  String _getBookTitle(String? bookId) {
    final book = _books.firstWhere(
      (b) => b.id == bookId,
      orElse: () => BookModel(id: '', title: 'Desconhecido', author: '', avaliable: false),
    );
    return book.title;
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Empréstimos')),
      body: _loans.isEmpty
          ? const Center(child: Text('Nenhum empréstimo encontrado.'))
          : ListView.builder(
              itemCount: _loans.length,
              itemBuilder: (context, index) {
                final loan = _loans[index];
                final userName = _getUserName(loan.userId);
                final bookTitle = _getBookTitle(loan.bookId);
                return ListTile(
                  title: Text('Livro: $bookTitle'),
                  subtitle: Text('Usuário: $userName'),
                  trailing: loan.returned == 'true' || loan.returned == true
                      ? const Icon(Icons.check, color: Colors.green)
                      : const Icon(Icons.schedule, color: Colors.red),
                  onTap: () {
                    // Aqui pode abrir a tela de detalhes do empréstimo
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoanFormView()),
          );
          _loadData();
        },
        child: const Icon(Icons.assignment_turned_in),
        tooltip: 'Emprestar Livro',
      ),
    );
  }
}