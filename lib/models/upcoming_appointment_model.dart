class UpcomingAppointmentModel {
  bool? success;
  String? message;
  Data? data;

  UpcomingAppointmentModel({this.success, this.message, this.data});

  UpcomingAppointmentModel.fromJson(Map<String, dynamic> json) {
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
  int? currentPage;
  List<UpcomingAppointmentInfo>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Links>? links;
  String? nextPageUrl;
  String? path;
  int? perPage;
  String? prevPageUrl;
  int? to;
  int? total;

  Data(
      {this.currentPage,
      this.data,
      this.firstPageUrl,
      this.from,
      this.lastPage,
      this.lastPageUrl,
      this.links,
      this.nextPageUrl,
      this.path,
      this.perPage,
      this.prevPageUrl,
      this.to,
      this.total});

  Data.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <UpcomingAppointmentInfo>[];
      json['data'].forEach((v) {
        data!.add(new UpcomingAppointmentInfo.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(new Links.fromJson(v));
      });
    }
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = this.firstPageUrl;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    data['last_page_url'] = this.lastPageUrl;
    if (this.links != null) {
      data['links'] = this.links!.map((v) => v.toJson()).toList();
    }
    data['next_page_url'] = this.nextPageUrl;
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['prev_page_url'] = this.prevPageUrl;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }
}

class UpcomingAppointmentInfo {
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
  List<Prescriptions>? prescriptions;
  User? user;

  UpcomingAppointmentInfo(
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
      this.prescriptions,
      this.user});

  UpcomingAppointmentInfo.fromJson(Map<String, dynamic> json) {
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
    if (json['prescriptions'] != null) {
      prescriptions = <Prescriptions>[];
      json['prescriptions'].forEach((v) {
        prescriptions!.add(new Prescriptions.fromJson(v));
      });
    }
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
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
    if (this.prescriptions != null) {
      data['prescriptions'] =
          this.prescriptions!.map((v) => v.toJson()).toList();
    }
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class Prescriptions {
  int? id;
  int? appointmentId;
  int? doctorId;
  String? diseaseId;
  String? note;
  String? otherMedicines;
  String? createdAt;
  String? updatedAt;
  List<Medicines>? medicines;

  Prescriptions(
      {this.id,
      this.appointmentId,
      this.doctorId,
      this.diseaseId,
      this.note,
      this.otherMedicines,
      this.createdAt,
      this.updatedAt,
      this.medicines});

  Prescriptions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    appointmentId = json['appointment_id'];
    doctorId = json['doctor_id'];
    diseaseId = json['disease_id'];
    note = json['note'];
    otherMedicines = json['other_medicines'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['medicines'] != null) {
      medicines = <Medicines>[];
      json['medicines'].forEach((v) {
        medicines!.add(new Medicines.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['appointment_id'] = this.appointmentId;
    data['doctor_id'] = this.doctorId;
    data['disease_id'] = this.diseaseId;
    data['note'] = this.note;
    data['other_medicines'] = this.otherMedicines;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.medicines != null) {
      data['medicines'] = this.medicines!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Medicines {
  int? id;
  int? prescriptionId;
  String? productId;
  String? time;
  String? toBeTaken;
  String? createdAt;
  String? updatedAt;
  Products? products;

  Medicines(
      {this.id,
      this.prescriptionId,
      this.productId,
      this.time,
      this.toBeTaken,
      this.createdAt,
      this.updatedAt,
      this.products});

  Medicines.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    prescriptionId = json['prescription_id'];
    productId = json['product_id'];
    time = json['time'];
    toBeTaken = json['to_be_taken'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    products = json['products'] != null
        ? new Products.fromJson(json['products'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['prescription_id'] = this.prescriptionId;
    data['product_id'] = this.productId;
    data['time'] = this.time;
    data['to_be_taken'] = this.toBeTaken;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.products != null) {
      data['products'] = this.products!.toJson();
    }
    return data;
  }
}

class Products {
  int? id;
  int? diseaseId;
  String? productName;
  String? description;
  String? productNameHindi;
  String? descriptionHindi;
  String? amazonLink;
  String? thumbnail;
  String? isOnAmazone;
  String? createdAt;
  String? updatedAt;

  Products(
      {this.id,
      this.diseaseId,
      this.productName,
      this.description,
      this.productNameHindi,
      this.descriptionHindi,
      this.amazonLink,
      this.thumbnail,
      this.isOnAmazone,
      this.createdAt,
      this.updatedAt});

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    diseaseId = json['disease_id'];
    productName = json['product_name'];
    description = json['description'];
    productNameHindi = json['product_name_hindi'];
    descriptionHindi = json['description_hindi'];
    amazonLink = json['amazon_link'];
    thumbnail = json['thumbnail'];
    isOnAmazone = json['is_on_amazone'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['disease_id'] = this.diseaseId;
    data['product_name'] = this.productName;
    data['description'] = this.description;
    data['product_name_hindi'] = this.productNameHindi;
    data['description_hindi'] = this.descriptionHindi;
    data['amazon_link'] = this.amazonLink;
    data['thumbnail'] = this.thumbnail;
    data['is_on_amazone'] = this.isOnAmazone;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class User {
  int? id;
  int? branchId;
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

  User(
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

  User.fromJson(Map<String, dynamic> json) {
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

class Links {
  String? url;
  String? label;
  bool? active;

  Links({this.url, this.label, this.active});

  Links.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    label = json['label'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['label'] = this.label;
    data['active'] = this.active;
    return data;
  }
}
