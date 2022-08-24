class SearchModel {
  String? status;
  List<Data>? data;
  String? msg;

  SearchModel({this.status, this.data, this.msg});

  SearchModel.fromJson(Map<String, dynamic> json) {
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
  String? isOnline;
  String? isLive;
  String? image;
  String? followed;
  LevelHost? levelHost;
  LevelHost? levelUser;
  dynamic diamonds;
  dynamic totalReceivedGifts;
  List<dynamic>? followers;
  List<dynamic>? followeds;

  Data(
      {this.id,
        this.type,
        this.name,
        this.email,
        this.isOnline,
        this.isLive,
        this.totalReceivedGifts,
        this.diamonds,
        this.image,
        this.followed,
        this.levelHost,
        this.levelUser,
        this.followers,
        this.followeds});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    name = json['name'];
    diamonds = json['diamonds'];
    totalReceivedGifts = json['total_received_gifts'];
    email = json['email'];
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
    if (json['followers'] != null) {
      followers = <dynamic>[];
      json['followers'].forEach((v) {
        followers!.add(v);
      });
    }
    if (json['followeds'] != null) {
      followeds = <dynamic>[];
      json['followeds'].forEach((v) {
        followeds!.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['name'] = this.name;
    data['email'] = this.email;
    data['is_online'] = this.isOnline;
    data['is_live'] = this.isLive;
    data['diamonds'] = this.diamonds;
    data['total_received_gifts'] = this.totalReceivedGifts;
    data['image'] = this.image;
    data['followed'] = this.followed;
    if (this.levelHost != null) {
      data['level_host'] = this.levelHost!.toJson();
    }
    if (this.levelUser != null) {
      data['level_user'] = this.levelUser!.toJson();
    }
    if (this.followers != null) {
      data['followers'] = this.followers!.map((v) => v).toList();
    }
    if (this.followeds != null) {
      data['followeds'] = this.followeds!.map((v) => v).toList();
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