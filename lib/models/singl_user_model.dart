import 'package:stars_live/models/user_model.dart';

class User {
  int? id;
  String? type;
  String? name;
  String? email;
  String? phone;
  dynamic salary;
  dynamic shiftTransferredUsd;
  String? balanceInCoins;
  dynamic diamonds;
  dynamic totalReceivedGifts;
  String? isOnline;
  String? isLive;
  String? image;
  String? followed;
  LevelHost? levelHost;
  LevelHost? levelUser;
  String? apiToken;
  // List<Null>? followers;
  // List<Null>? followeds;

  User({
    this.id,
    this.type,
    this.name,
    this.email,
    this.phone,
    this.salary,
    this.shiftTransferredUsd,
    this.balanceInCoins,
    this.diamonds,
    this.totalReceivedGifts,
    this.isOnline,
    this.isLive,
    this.image,
    this.followed,
    this.levelHost,
    this.levelUser,
    this.apiToken,
  });

  User.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    type = json['type'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    salary = json['salary'];
    shiftTransferredUsd = json['shift_transferred_usd'];
    balanceInCoins = json['balance_in_coins'];
    diamonds = json['diamonds'];
    totalReceivedGifts = json['total_received_gifts'];
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
    apiToken = json['api_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['salary'] = this.salary;
    data['shift_transferred_usd'] = this.shiftTransferredUsd;
    data['balance_in_coins'] = this.balanceInCoins;
    data['diamonds'] = this.diamonds;
    data['total_received_gifts'] = this.totalReceivedGifts;
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
    data['api_token'] = this.apiToken;
    // if (this.followers != null) {
    //   data['followers'] = this.followers!.map((v) => v.toJson()).toList();
    // }
    // if (this.followeds != null) {
    //   data['followeds'] = this.followeds!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}
