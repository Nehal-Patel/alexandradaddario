// To parse this JSON data, do
//
//     final modelWallpaper = modelWallpaperFromJson(jsonString);

import 'dart:convert';

List<ModelWallpaper> modelWallpaperFromJson(String str) => List<ModelWallpaper>.from(json.decode(str).map((x) => ModelWallpaper.fromJson(x)));

String modelWallpaperToJson(List<ModelWallpaper> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ModelWallpaper {
  ModelWallpaper({
    this.id,
    this.image,
    this.thumbnail,
    this.isNew,
    this.categoryId,
    this.categoryName,
  });


  String? id;
  String? image;
  String? thumbnail;
  String? status;
  String? isNew;
  String? categoryId;
  String? categoryName;

  factory ModelWallpaper.fromJson(Map<String, dynamic> json) => ModelWallpaper(

    id: json["id"],
    image: json["image"],
    thumbnail: json["thumbnail"],
    isNew: json["is_new"],
    categoryId: json["category_id"],
    categoryName: json["category_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "image": image,
    "thumbnail": thumbnail,
    "is_new": isNew,
    "category_id": categoryId,
    "category_name": categoryName,
  };

  Map<String, dynamic> toDBJson() => {
    "id": id.toString(),
    "image": image.toString(),
    "thumbnail": thumbnail.toString(),
  };
}


