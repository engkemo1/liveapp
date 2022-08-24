class BannerModel {
  String? status;
  List<Data>? data;
  String? msg;
  List<String>? errors;

  BannerModel({this.status, this.data, this.msg, this.errors});

  BannerModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    msg = json['msg'];
    if (json['errors'] != null) {
      errors = <String>[];
      json['errors'].forEach((v) {
        errors!.add(v);
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
    if (this.errors != null) {
      data['errors'] = this.errors!.map((v) => v).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? course_name;
  String? course_level;
  String? description;
  String? enrollable;
  String? entryExamId;
  String? exam1;
  String? duration;
  String? ordering;
  String? image;
  String? video;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
        this.course_level,
        this.course_name,
        this.description,
        this.enrollable,
        this.entryExamId,
        this.exam1,
        this.duration,
        this.ordering,
        this.image,
        this.video,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    course_name = json['course_name'];
    course_level = json['course_level'];
    description = json['description'];
    enrollable = json['enrollable'];
    entryExamId = json['entryExamId'];
    exam1 = json['exam1'];
    exam2 = json['duration'];
    ordering = json['ordering'];
    image = json['image'];
    video = json['video'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['course_name'] = this.course_name;
    data['course_level'] = this.course_level;
    data['enrollable'] = this.enrollable;
    data['exam1'] = this.exam1;
    data['entryExamId'] = this.entryExamId;
    data['exam2'] = this.exam2;
    data['duration'] = this.duration;
    data['ordering'] = this.ordering;
    data['image'] = this.image;
    data['video'] = this.video;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}