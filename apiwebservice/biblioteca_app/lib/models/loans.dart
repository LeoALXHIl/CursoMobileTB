class LoansModel {
  final String? id;
  final String? userId;
  final String? bookId;
  final String startDate;
  final String dueDate;
  final String returned;

  LoansModel({
    this.id,
    this.userId,
    this.bookId,
    required this.startDate,
    required this.dueDate,
    required this.returned,
  });

  factory LoansModel.fromJson(Map<String, dynamic> json) {
    return LoansModel(
      id: json['id']?.toString(),
      userId: json['userId']?.toString(),
      bookId: (json['booksId'] ?? json['bookId'])?.toString(),
      startDate: json['startDate']?.toString() ?? '',
      dueDate: json['dueDate']?.toString() ?? '',
      returned: json['returned']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'userId': userId,
      'booksId': bookId,
      'startDate': startDate,
      'dueDate': dueDate,
      'returned': returned,
    };
    if (id != null) {
      data['id'] = id;
    }
    return data;
  }
}
