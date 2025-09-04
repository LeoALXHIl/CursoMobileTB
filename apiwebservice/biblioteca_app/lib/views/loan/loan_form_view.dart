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
    _startDate = DateTime.now();
    _dueDate = DateTime.now().add(const Duration(days: 7));
    _loadData();
  }

  Future<void> _loadData() async {
    final usersList = await ApiService.getList("users");
    final booksList = await ApiService.getList("books");
    // Filtra usuários com id não nulo e único
    final userModels = usersList.map<UserModel>((item) => UserModel.fromJson(item)).where((u) => u.id != null).toList();
    final uniqueUsers = {for (var u in userModels) u.id!: u};
    // Filtra livros disponíveis com id não nulo e único
    final bookModels = booksList.map<BookModel>((item) => BookModel.fromMap(item)).where((b) => b.available == true && b.id != null).toList();
    final uniqueBooks = {for (var b in bookModels) b.id!: b};

    // Check if a book was passed as argument
    final book = ModalRoute.of(context)?.settings.arguments as BookModel?;
    if (book != null) {
      _selectedBookId = book.id;
    }

    setState(() {
      _users = uniqueUsers.values.toList();
      _books = uniqueBooks.values.toList();
      _loading = false;
    });
  }

  Future<void> _saveLoan() async {
    if (_selectedUserId == null || _selectedBookId == null || _startDate == null || _dueDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Preencha todos os campos obrigatórios!')));
      return;
    }
    final loan = LoansModel(
      userId: _selectedUserId,
      bookId: _selectedBookId,
      startDate: _startDate!.toIso8601String().substring(0, 10),
      dueDate: _dueDate!.toIso8601String().substring(0, 10),
      returned: _returned ? 'true' : '', // campo opcional, pode ser vazio
    );
    try {
      await _controller.create(loan);
      // Atualiza disponibilidade do livro
      final book = _books.firstWhere((b) => b.id == _selectedBookId);
      final updatedBook = BookModel(
        id: book.id,
        title: book.title,
        author: book.author,
        available: false,
      );
      await _bookController.update(updatedBook);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Empréstimo salvo!')));
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao salvar empréstimo: $e')));
    }
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
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedBookId = value);
                  }
                },
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              const Text('Data de Início'),
              TextFormField(
                readOnly: true,
                controller: TextEditingController(text: _startDate != null ? _startDate!.toLocal().toString().split(' ')[0] : ''),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _startDate ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) setState(() => _startDate = picked);
                },
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              const Text('Data de Devolução'),
              TextFormField(
                readOnly: true,
                controller: TextEditingController(text: _dueDate != null ? _dueDate!.toLocal().toString().split(' ')[0] : ''),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _dueDate ?? DateTime.now(),
                    firstDate: _startDate ?? DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) setState(() => _dueDate = picked);
                },
                decoration: const InputDecoration(border: OutlineInputBorder()),
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
