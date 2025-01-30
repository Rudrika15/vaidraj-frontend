class BranchAddressModel {
  bool? success;
  String? message;
  List<BranchAddress>? data;

  BranchAddressModel({this.success, this.message, this.data});

  BranchAddressModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <BranchAddress>[];
      json['data'].forEach((v) {
        data!.add(new BranchAddress.fromJson(v));
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

class BranchAddress {
  int? id;
  String? branchName;
  int? pincode;
  String? city;
  String? address;
  String? addressHindi;
  String? mobileNo;
  String? createdAt;
  String? updatedAt;
  String? displayAddress;

  BranchAddress(
      {this.id,
      this.branchName,
      this.pincode,
      this.city,
      this.address,
      this.addressHindi,
      this.mobileNo,
      this.createdAt,
      this.updatedAt,
      this.displayAddress});

  BranchAddress.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    branchName = json['branch_name'];
    pincode = json['pincode'];
    city = json['city'];
    address = json['address'];
    addressHindi = json['address_hindi'];
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
    data['address'] = this.address;
    data['address_hindi'] = this.addressHindi;
    data['mobile_no'] = this.mobileNo;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['display_address'] = this.displayAddress;
    return data;
  }
}
