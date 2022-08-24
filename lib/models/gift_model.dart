class Gift {
  int? id;
  String? name;
  String? title;
  String? description;
  String? image;
  String? videoLink;
  String? valueInCoins;
  String? createdAt;
  String? updatedAt;
  String? cachedImgPath;
  String? cachedVidPath;

  Gift({
    this.id,
    this.name,
    this.title,
    this.description,
    this.image,
    this.videoLink,
    this.valueInCoins,
    this.createdAt,
    this.updatedAt,
  });

  Gift.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    title = json['title'];
    description = json['description'];
    image = json['image'];
    videoLink = json['video_link'];
    valueInCoins = json['value_in_coins'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['title'] = this.title;
    data['description'] = this.description;
    data['image'] = this.image;
    data['video_link'] = this.videoLink;
    data['value_in_coins'] = this.valueInCoins;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
