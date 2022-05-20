import 'dart:convert';

List<ModelCategory> modelCategoryFromJson(String str) => List<ModelCategory>.from(json.decode(str).map((x) => ModelCategory.fromJson(x)));

String modelCategoryToJson(List<ModelCategory> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ModelCategory {
  ModelCategory({
    required this.id,
    required this.name,
    required this.gender,
    required this.image,
    required this.status,
  });

  String id;
  String name;
  String gender;
  String image;
  String status;

  factory ModelCategory.fromJson(Map<String, dynamic> json) => ModelCategory(
    id: json["id"].toString(),
    name: json["name"],
    gender: json["gender"],
    image: json["image"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id.toString(),
    "name": name,
    "gender": gender,
    "image": image,
    "status": status,
  };
}
