class GameModel {
  GameModel({
    this.status,
    this.data,
    this.msg,
    this.errors,
  });

  String? status;
  List<GameData>? data;
  String? msg;
  List<dynamic>? errors;

  factory GameModel.fromJson(Map<String, dynamic> json) => GameModel(
        status: json["status"],
        data:
            List<GameData>.from(json["data"].map((x) => GameData.fromJson(x))),
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

class GameData {
  GameData({
    this.id,
    this.teamOneName,
    this.teamOneImg,
    this.teamTwoName,
    this.teamTwoImg,
    this.gameDate,
    this.startAt,
    this.endAt,
    this.winnerTeam,
    this.status,
    this.isPaid,
    this.createdAt,
    this.updatedAt,
    this.teamOneVoted,
    this.teamTwoVoted,
    this.drawVoted,
    this.teams,
  });

  int? id;
  String? teamOneName;
  String? teamOneImg;
  String? teamTwoName;
  String? teamTwoImg;
  DateTime? gameDate;
  String? startAt;
  dynamic endAt;
  dynamic winnerTeam;
  String? status;
  String? isPaid;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool? teamOneVoted;
  bool? teamTwoVoted;
  bool? drawVoted;
  List<String>? teams;

  factory GameData.fromJson(Map<String, dynamic> json) => GameData(
        id: json["id"],
        teamOneName: json["team_one_name"],
        teamOneImg: json["team_one_img"],
        teamTwoName: json["team_two_name"],
        teamTwoImg: json["team_two_img"],
        gameDate: DateTime.parse(json["game_date"]),
        startAt: json["start_at"] == null ? null : json["start_at"],
        endAt: json["end_at"],
        winnerTeam: json["winner_team"],
        status: json["status"],
        isPaid: json["is_paid"],
        teamOneVoted: json["t_one"],
        teamTwoVoted: json["t_two"],
        drawVoted: json["draw"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        teams: json['teams'] != null
            ? List<String>.from(json["teams"].map((x) => x))
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "team_one_name": teamOneName,
        "team_one_img": teamOneImg,
        "team_two_name": teamTwoName,
        "team_two_img": teamTwoImg,
        "game_date":
            "${gameDate?.year.toString().padLeft(4, '0')}-${gameDate?.month.toString().padLeft(2, '0')}-${gameDate?.day.toString().padLeft(2, '0')}",
        "start_at": startAt == null ? null : startAt,
        "end_at": endAt,
        "winner_team": winnerTeam,
        "status": status,
        "is_paid": isPaid,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "teams": teams != null ? List<dynamic>.from(teams!.map((x) => x)) : [],
      };
}
