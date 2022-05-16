class CountryModel {
  final String code;
  final String title;
  String? image;
  final int id;

  CountryModel({
    required this.code,
    required this.title,
    this.image,
    required this.id,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      code: json['c'] ?? "Unknown",
      title: json['n'] ?? "Unknown",
      image: json['c'].toUpperCase().replaceAllMapped(
          RegExp(r'[A-Z]'),
          (match) =>
              String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397)),
      id: json['cid'] ?? 0,
    );
  }
}
