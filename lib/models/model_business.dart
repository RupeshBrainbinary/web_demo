

class BusinessModel {
  final int id;
  final String location;
  final String title;


  BusinessModel({
    required this.id,
    required this.location,
    required this.title

  });

  factory BusinessModel.fromJson(Map<String, dynamic> json) {


    return BusinessModel(
        id: json['id'] ?? 0,
        location: json['location'] ?? '',
        //title
      title: json['name'] ?? '',

    );
  }
}
