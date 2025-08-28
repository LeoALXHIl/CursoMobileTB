import 'package:biblioteca_app/models/loans.dart';
import 'package:biblioteca_app/services/api_service.dart';

class LoanController {
  // Buscar todos os empréstimos
  Future<List<LoansModel>> fetchAll() async {
    final list = await ApiService.getList("loans");
    return list.map<LoansModel>((item) => LoansModel.fromJson(item)).toList();
  }

  // Criar novo empréstimo
  Future<LoansModel> create(LoansModel loan) async {
    final created = await ApiService.post("loans", loan.toJson());
    return LoansModel.fromJson(created);
  }

  // Buscar um empréstimo por ID
  Future<LoansModel> fetchOne(String id) async {
    final loan = await ApiService.getOne("loans", id);
    return LoansModel.fromJson(loan);
  }

  // Atualizar empréstimo
  Future<LoansModel> update(LoansModel loan) async {
    final updated = await ApiService.put("loans", loan.toJson(), loan.id!);
    return LoansModel.fromJson(updated);
  }

  // Deletar empréstimo
  Future<void> delete(String id) async {
    await ApiService.delete("loans", id);
  }
}
