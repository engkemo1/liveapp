import 'package:stars_live/models/follower_model.dart';

class UserModel {
  String? status;
  List<Data>? data;
  String? msg;

  UserModel({
    this.status,
    this.data,
    this.msg,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
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
  String? name;
  String? email;
  dynamic phone;
  String? address;

  dynamic apiToken;

  Data({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.address,
    this.apiToken,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    address = json['address'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    apiToken = json['api_token'];



  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['api_token'] = this.apiToken;

    return data;
  }
}


