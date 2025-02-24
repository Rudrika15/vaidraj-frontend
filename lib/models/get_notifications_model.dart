class GetNotificationsModel {
  bool? success;
  String? message;
  List<Notification1>? data;

  GetNotificationsModel({this.success, this.message, this.data});

  GetNotificationsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Notification1>[];
      json['data'].forEach((v) {
        data!.add(new Notification1.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Notification1 {
  int? id;
  int? userId;
  String? subject;
  String? message;
  String? type;
  String? createdAt;
  String? updatedAt;

  Notification1(
      {this.id,
      this.userId,
      this.subject,
      this.message,
      this.type,
      this.createdAt,
      this.updatedAt});

  Notification1.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    subject = json['subject'];
    message = json['message'];
    type = json['type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['subject'] = this.subject;
    data['message'] = this.message;
    data['type'] = this.type;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
