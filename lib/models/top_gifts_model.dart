class GiftModel {
  String? status;
  List<Data>? data;
  String? msg;
  List<String>? errors;

  GiftModel({this.status, this.data, this.msg, this.errors});

  GiftModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    msg = json['msg'];
    if (json['errors'] != null) {
      errors = [];
      json['errors'].forEach((v) {
        errors!.add("");
      });
    }
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
  dynamic value;
  User? user;

  Data({this.value, this.user});

  Data.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? type;
  String? name;
  String? isOnline;
  String? isLive;
  String? image;
  String? followed;
  LevelHost? levelHost;
  LevelHost? levelUser;

  User(
      {
        this.id,
        this.type,
        this.name,
        this.isOnline,
        this.isLive,
        this.image,
        this.followed,
        this.levelHost,
        this.levelUser});

  User.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    type = json['type'];
    name = json['name'];
    isOnline = json['is_online'];
    isLive = json['is_live'];
    image = json['image'];
    followed = json['followed'];
    levelHost = json['level_host'] != null
        ? new LevelHost.fromJson(json['level_host'])
        : null;
    levelUser = json['level_user'] != null
        ? new LevelHost.fromJson(json['level_user'])
        : null;
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['name'] = this.name;
    data['is_online'] = this.isOnline;
    data['is_live'] = this.isLive;
    data['image'] = this.image;
    data['followed'] = this.followed;
    if (this.levelHost != null) {
      data['level_host'] = this.levelHost!.toJson();
    }
    if (this.levelUser != null) {
      data['level_user'] = this.levelUser!.toJson();
    }
    return data;
  }
}

class LevelHost {
  dynamic level;
  dynamic previous;
  dynamic current;
  dynamic next;
  dynamic remaining;
  dynamic value;

  LevelHost(
      {this.level,
        this.previous,
        this.current,
        this.next,
        this.remaining,
        this.value});

  LevelHost.fromJson(Map<String, dynamic> json) {
    level = json['level'];
    previous = json['previous'];
    current = json['current'];
    next = json['next'];
    remaining = json['remaining'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['level'] = this.level;
    data['previous'] = this.previous;
    data['current'] = this.current;
    data['next'] = this.next;
    data['remaining'] = this.remaining;
    data['value'] = this.value;
    return data;
  }
}