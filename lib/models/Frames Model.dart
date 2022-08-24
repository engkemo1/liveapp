class GameModel {
  GameModel({
    this.status,
    this.data,
    this.msg,
    this.errors,
  });

  String? status;
  List<Frames>? data;
  String? msg;
  List<dynamic>? errors;

  factory GameModel.fromJson(Map<String, dynamic> json) => GameModel(
    status: json["status"],
    data:
    List<Frames>.from(json["data"].map((x) => Frames.fromJson(x))),
    msg: json["msg"],
    errors: List<dynamic>.from(json["errors"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data != null
        ? List<dynamic>.from(data!.map((x) => x.toJson()))
        : [],
    "msg": msg,
    "errors":
    errors != null ? List<dynamic>.from(errors!.map((x) => x)) : [],
  };
}

class Frames {
  Frames({
    this.id,
    this.teamOneName,
    this.teamOneImg,
    this.teamTwoName,
    this.teamTwoImg,

  });

  int? id;
  String? teamOneName;
  String? teamOneImg;
  String? teamTwoName;
  String? teamTwoImg;


  factory Frames.fromJson(Map<String, dynamic> json) => Frames(
    id: json["id"],
    teamOneName: json["team_one_name"],
    teamOneImg: json["team_one_img"],
    teamTwoName: json["team_two_name"],

  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "team_one_name": teamOneName,
    "team_one_img": teamOneImg,
    "team_two_name": teamTwoName,
    "team_two_img": teamTwoImg,
    "game_date":

  };
}
