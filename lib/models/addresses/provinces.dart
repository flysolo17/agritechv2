class Province {
  final String code;
  final String name;

  Province({
    required this.code,
    required this.name,
  });

  factory Province.fromJson(Map<String, dynamic> json) {
    return Province(
      code: json['code'],
      name: json['name'],
    );
  }
}
