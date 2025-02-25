class DeleteNotificationModel {
  bool? success;
  String? message;
  DeleteNotification? data;

  DeleteNotificationModel({this.success, this.message, this.data});

  DeleteNotificationModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null
        ? new DeleteNotification.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class DeleteNotification {
  int? id;
  int? userId;
  String? subject;
  String? message;
  String? type;
  String? createdAt;
  String? updatedAt;

  DeleteNotification(
      {this.id,
      this.userId,
      this.subject,
      this.message,
      this.type,
      this.createdAt,
      this.updatedAt});

  DeleteNotification.fromJson(Map<String, dynamic> json) {
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
