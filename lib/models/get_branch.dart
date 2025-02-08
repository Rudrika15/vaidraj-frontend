class GetBranch {
  bool? success;
  String? message;
  List<Branch>? data;

  GetBranch({this.success, this.message, this.data});

  GetBranch.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Branch>[];
      json['data'].forEach((v) {
        data!.add(new Branch.fromJson(v));
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

class Branch {
  int? id;
  String? branchName;
  int? pincode;
  String? city;
  String? mobileNo;
  String? createdAt;
  String? updatedAt;
  String? displayAddress;

  Branch(
      {this.id,
      this.branchName,
      this.pincode,
      this.city,
      this.mobileNo,
      this.createdAt,
      this.updatedAt,
      this.displayAddress});

  Branch.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    branchName = json['branch_name'];
    pincode = json['pincode'];
    city = json['city'];
    mobileNo = json['mobile_no'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    displayAddress = json['display_address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['branch_name'] = this.branchName;
    data['pincode'] = this.pincode;
    data['city'] = this.city;
    data['mobile_no'] = this.mobileNo;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['display_address'] = this.displayAddress;
    return data;
  }
}
