class UpdateProfileModel {
  bool? success;
  String? message;
  Data? data;

  UpdateProfileModel({this.success, this.message, this.data});

  UpdateProfileModel.fromJson(Map<String, dynamic> json) {
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
  int? id;
  String? branchId;
  String? name;
  String? email;
  String? emailVerifiedAt;
  String? address;
  String? mobileNo;
  String? dob;
  String? formToken;
  String? role;
  String? language;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
      this.branchId,
      this.name,
      this.email,
      this.emailVerifiedAt,
      this.address,
      this.mobileNo,
      this.dob,
      this.formToken,
      this.role,
      this.language,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    branchId = json['branch_id'];
    name = json['name'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    address = json['address'];
    mobileNo = json['mobile_no'];
    dob = json['dob'];
    formToken = json['form_token'];
    role = json['role'];
    language = json['language'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['branch_id'] = this.branchId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['address'] = this.address;
    data['mobile_no'] = this.mobileNo;
    data['dob'] = this.dob;
    data['form_token'] = this.formToken;
    data['role'] = this.role;
    data['language'] = this.language;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
