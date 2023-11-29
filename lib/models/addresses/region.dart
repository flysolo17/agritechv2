class Region {
  final String code;
  final String name;

  Region({
    required this.code,
    required this.name,
  });

  factory Region.fromJson(Map<String, dynamic> json) {
    return Region(
      code: json['code'],
      name: json['name'],
    );
  }
}
