class ForwardModel {
  String? status;
  List<Data>? data;
  String? msg;

  ForwardModel({this.status, this.data, this.msg});

  ForwardModel.fromJson(Map<String, dynamic> json) {
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
  String? name;
  String? whats;
  String? avatar;

  Data({this.name, this.whats, this.avatar});

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    whats = json['whats'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['whats'] = this.whats;
    data['avatar'] = this.avatar;
    return data;
  }
}