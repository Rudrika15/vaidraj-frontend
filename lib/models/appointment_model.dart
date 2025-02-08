class AppointmentModel {
  bool? success;
  String? message;
  Data? data;

  AppointmentModel({this.success, this.message, this.data});

  AppointmentModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
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

class Data {
  String? diseaseId;
  String? date;
  String? slot;
  String? subject;
  String? message;
  int? userId;
  String? name;
  String? email;
  String? dob;
  String? contact;
  String? address;
  String? status;
  String? updatedAt;
  String? createdAt;
  int? id;

  Data(
      {this.diseaseId,
      this.date,
      this.slot,
      this.subject,
      this.message,
      this.userId,
      this.name,
      this.email,
      this.dob,
      this.contact,
      this.address,
      this.status,
      this.updatedAt,
      this.createdAt,
      this.id});

  Data.fromJson(Map<String, dynamic> json) {
    diseaseId = json['disease_id'];
    date = json['date'];
    slot = json['slot'];
    subject = json['subject'];
    message = json['message'];
    userId = json['user_id'];
    name = json['name'];
    email = json['email'];
    dob = json['dob'];
    contact = json['contact'];
    address = json['address'];
    status = json['status'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['disease_id'] = this.diseaseId;
    data['date'] = this.date;
    data['slot'] = this.slot;
    data['subject'] = this.subject;
    data['message'] = this.message;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['dob'] = this.dob;
    data['contact'] = this.contact;
    data['address'] = this.address;
    data['status'] = this.status;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}
