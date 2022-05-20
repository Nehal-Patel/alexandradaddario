class ModelFavorite {
  String id;
  String image;
  String thumbnail;
  ModelFavorite(this.id, this.image,this.thumbnail);

  Map toJson() => {
    'id': id,
    'image': image,
    'thumbnail': thumbnail,
  };
}