class AddPatientModel {
  bool? success;
  String? message;
  Data? data;
  String? token;

  AddPatientModel({this.success, this.message, this.data, this.token});

  AddPatientModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['token'] = this.token;
    return data;
  }
}

class Data {
  int? branchId;
  String? name;
  String? email;
  String? mobileNo;
  String? address;
  String? dob;
  String? updatedAt;
  String? createdAt;
  int? id;

  Data(
      {this.branchId,
      this.name,
      this.email,
      this.mobileNo,
      this.address,
      this.dob,
      this.updatedAt,
      this.createdAt,
      this.id});

  Data.fromJson(Map<String, dynamic> json) {
    branchId = json['branch_id'];
    name = json['name'];
    email = json['email'];
    mobileNo = json['mobile_no'];
    address = json['address'];
    dob = json['dob'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['branch_id'] = this.branchId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['mobile_no'] = this.mobileNo;
    data['address'] = this.address;
    data['dob'] = this.dob;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}
