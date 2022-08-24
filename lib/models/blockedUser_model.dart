class BlockedUserModel {
  String? status;
  List<Data>? data;
  String? msg;

  BlockedUserModel({
    this.status,
    this.data,
    this.msg,
  });

  BlockedUserModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['msg'] = this.msg;

    return data;
  }
}

class Data {
  int? id;
  String? type;
  String? name;
  String? email;
  String? image;

  Data({
    this.id,
    this.type,
    this.name,
    this.email,
    this.image,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    name = json['name'];
    email = json['email'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['name'] = this.name;
    data['email'] = this.email;
    data['image'] = this.image;

    return data;
  }
}
