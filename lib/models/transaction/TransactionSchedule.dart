import 'package:intl/intl.dart';

class TransactionSchedule {
  final DateTime startDate;
  final DateTime endDate;

  TransactionSchedule({
    required this.startDate,
    required this.endDate,
  });

  factory TransactionSchedule.initialize() {
    final today = DateTime.now();
    final endDate = today.add(const Duration(days: 3));
    return TransactionSchedule(startDate: today, endDate: endDate);
  }

  String getFormatedSchedule() {
    final start = DateFormat.MMMd().format(startDate);
    final end = DateFormat.MMMd().format(endDate);
    return '$start - $end';
  }

  factory TransactionSchedule.fromJson(Map<String, dynamic> json) {
    return TransactionSchedule(
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    };
  }
}
