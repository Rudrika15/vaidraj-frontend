class TodaysAppointmentsModel {
  bool? success;
  String? message;
  List<TodaysAppointment>? data;

  TodaysAppointmentsModel({this.success, this.message, this.data});

  TodaysAppointmentsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <TodaysAppointment>[];
      json['data'].forEach((v) {
        data!.add(new TodaysAppointment.fromJson(v));
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

class TodaysAppointment {
  int? id;
  String? name;
  String? email;
  String? contact;
  String? dob;
  String? address;
  int? diseaseId;
  int? userId;
  String? date;
  String? slot;
  String? subject;
  String? message;
  String? status;
  String? createdAt;
  String? updatedAt;
  Diseases? diseases;

  TodaysAppointment(
      {this.id,
      this.name,
      this.email,
      this.contact,
      this.dob,
      this.address,
      this.diseaseId,
      this.userId,
      this.date,
      this.slot,
      this.subject,
      this.message,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.diseases});

  TodaysAppointment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    contact = json['contact'];
    dob = json['dob'];
    address = json['address'];
    diseaseId = json['disease_id'];
    userId = json['user_id'];
    date = json['date'];
    slot = json['slot'];
    subject = json['subject'];
    message = json['message'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    diseases = json['diseases'] != null
        ? new Diseases.fromJson(json['diseases'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['contact'] = this.contact;
    data['dob'] = this.dob;
    data['address'] = this.address;
    data['disease_id'] = this.diseaseId;
    data['user_id'] = this.userId;
    data['date'] = this.date;
    data['slot'] = this.slot;
    data['subject'] = this.subject;
    data['message'] = this.message;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.diseases != null) {
      data['diseases'] = this.diseases!.toJson();
    }
    return data;
  }
}

class Diseases {
  int? id;
  String? diseaseName;
  String? description;
  String? diseaseNameHindi;
  String? descriptionHindi;
  String? url;
  String? thumbnail;
  String? createdAt;
  String? updatedAt;

  Diseases(
      {this.id,
      this.diseaseName,
      this.description,
      this.diseaseNameHindi,
      this.descriptionHindi,
      this.url,
      this.thumbnail,
      this.createdAt,
      this.updatedAt});

  Diseases.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    diseaseName = json['disease_name'];
    description = json['description'];
    diseaseNameHindi = json['disease_name_hindi'];
    descriptionHindi = json['description_hindi'];
    url = json['url'];
    thumbnail = json['thumbnail'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['disease_name'] = this.diseaseName;
    data['description'] = this.description;
    data['disease_name_hindi'] = this.diseaseNameHindi;
    data['description_hindi'] = this.descriptionHindi;
    data['url'] = this.url;
    data['thumbnail'] = this.thumbnail;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
