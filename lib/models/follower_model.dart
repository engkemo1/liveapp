class Follower {
  int? id;
  String? type;
  String? name;
  String? isOnline;
  String? isLive;
  String? image;
  String? followed;
  LevelHost? levelHost;
  LevelHost? levelUser;

  Follower(
      {this.id,
      this.type,
      this.name,
      this.isOnline,
      this.isLive,
      this.image,
      this.followed,
      this.levelHost,
      this.levelUser});

  Follower.fromJson(Map<String, dynamic> json) {
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
