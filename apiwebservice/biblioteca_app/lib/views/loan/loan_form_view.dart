import 'package:flutter/material.dart';
import 'package:biblioteca_app/models/users.dart';
import 'package:biblioteca_app/models/books.dart';
import 'package:biblioteca_app/controllers/book_controller.dart';
import 'package:biblioteca_app/models/loans.dart';
import 'package:biblioteca_app/controllers/loan_controller.dart';
import 'package:biblioteca_app/services/api_service.dart';

class LoanFormView extends StatefulWidget {
  const LoanFormView({super.key});

  @override
  State<LoanFormView> createState() => _LoanFormViewState();
}

class _LoanFormViewState extends State<LoanFormView> {
  final LoanController _controller = LoanController();
  final BookController _bookController = BookController();
  List<UserModel> _users = [];
  List<BookModel> _books = [];
  String? _selectedUserId;
  String? _selectedBookId;
  DateTime? _startDate;
  DateTime? _dueDate;
  bool _returned = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final usersList = await ApiService.getList("users");
    final booksList = await ApiService.getList("books");
    setState(() {
      _users = usersList.map<UserModel>((item) => UserModel.fromJson(item)).toList();
      // Filtra apenas livros disponíveis
      _books = booksList.map<BookModel>((item) => BookModel.fromMap(item)).where((b) => b.avaliable == true).toList();
      _loading = false;
    });
  }

  Future<void> _saveLoan() async {
    if (_selectedUserId == null || _selectedBookId == null || _startDate == null || _dueDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Preencha todos os campos!')));
      return;
    }
    final loan = LoansModel(
      userId: _selectedUserId,
      bookId: _selectedBookId,
      startDate: _startDate!.toIso8601String().substring(0, 10),
      dueDate: _dueDate!.toIso8601String().substring(0, 10),
      returned: _returned.toString(),
    );
    await _controller.create(loan);
    // Atualiza disponibilidade do livro
    final book = _books.firstWhere((b) => b.id == _selectedBookId);
    final updatedBook = BookModel(
      id: book.id,
      title: book.title,
      author: book.author,
      avaliable: false,
    );
    await _bookController.update(updatedBook);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Empréstimo salvo!')));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Novo Empréstimo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Usuário'),
              DropdownButtonFormField<String>(
                value: _selectedUserId,
                items: _users.map((u) => DropdownMenuItem(value: u.id, child: Text(u.name))).toList(),
                onChanged: (value) => setState(() => _selectedUserId = value),
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              const Text('Livro'),
              DropdownButtonFormField<String>(
                value: _selectedBookId,
                items: _books.map((b) => DropdownMenuItem(value: b.id, child: Text(b.title))).toList(),
                onChanged: (value) => setState(() => _selectedBookId = value),
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(_startDate == null ? 'Data de início' : 'Início: ${_startDate!.toLocal().toString().substring(0, 10)}'),
                  ),
                  TextButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) setState(() => _startDate = picked);
                    },
                    child: const Text('Selecionar'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(_dueDate == null ? 'Data de devolução' : 'Devolução: ${_dueDate!.toLocal().toString().substring(0, 10)}'),
                  ),
                  TextButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) setState(() => _dueDate = picked);
                    },
                    child: const Text('Selecionar'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Devolvido?'),
                  Checkbox(
                    value: _returned,
                    onChanged: (value) => setState(() => _returned = value ?? false),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveLoan,
                  child: const Text('Salvar Empréstimo'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}