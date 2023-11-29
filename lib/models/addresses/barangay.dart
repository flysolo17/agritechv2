class Barangay {
  final String code;
  final String name;

  Barangay({
    required this.code,
    required this.name,
  });

  factory Barangay.fromJson(Map<String, dynamic> json) {
    return Barangay(
      code: json['code'],
      name: json['name'],
    );
  }
}
