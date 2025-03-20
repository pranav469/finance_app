class Finance {
  final int? id;
  final String title;
  final double amount;
  final String category;
  final DateTime date;
  final String? dueDate;
  final String type;
  final String status;

  Finance({
    this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    required this.type,
    this.dueDate,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
      'type': type,
      'due_date': dueDate,
      'status': status,
    };
  }

  factory Finance.fromJson(Map<String, dynamic> json) {
    return Finance(
      id: json['id'],
      title: json['title'],
      amount: json['amount'],
      category: json['category'],
      date: DateTime.parse(json['date']),
      type: json['type'],
      dueDate: json['due_date'],
      status: json['status'],
    );
  }

  Finance copyWith({
    int? id,
    String? title,
    double? amount,
    String? category,
    DateTime? date,
    String? type,
    DateTime? due,
    String? status,
  }) {
    return Finance(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
      type: type ?? this.type,
      status: status ?? this.status,
    );
  }
}
