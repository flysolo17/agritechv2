class City {
  final String code;
  final String name;

  City({
    required this.code,
    required this.name,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      code: json['code'],
      name: json['name'],
    );
  }
}
