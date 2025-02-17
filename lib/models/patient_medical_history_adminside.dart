class PatientWiseMedicalHistoryModel {
  bool? success;
  String? message;
  Data? data;

  PatientWiseMedicalHistoryModel({this.success, this.message, this.data});

  PatientWiseMedicalHistoryModel.fromJson(Map<String, dynamic> json) {
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
  List<PatientHistoryInfo>? data;
  int? currentPage;
  int? lastPage;
  int? perPage;
  int? total;

  Data({this.data, this.currentPage, this.lastPage, this.perPage, this.total});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <PatientHistoryInfo>[];
      json['data'].forEach((v) {
        data!.add(new PatientHistoryInfo.fromJson(v));
      });
    }
    currentPage = json['current_page'];
    lastPage = json['last_page'];
    perPage = json['per_page'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['current_page'] = this.currentPage;
    data['last_page'] = this.lastPage;
    data['per_page'] = this.perPage;
    data['total'] = this.total;
    return data;
  }
}

class PatientHistoryInfo {
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
  List<Appointments>? appointments;

  PatientHistoryInfo(
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
      this.updatedAt,
      this.appointments});

  PatientHistoryInfo.fromJson(Map<String, dynamic> json) {
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
    if (json['appointments'] != null) {
      appointments = <Appointments>[];
      json['appointments'].forEach((v) {
        appointments!.add(new Appointments.fromJson(v));
      });
    }
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
    if (this.appointments != null) {
      data['appointments'] = this.appointments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Appointments {
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
  List<PatientWisePrescriptions>? prescriptions;

  Appointments(
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
      this.prescriptions});

  Appointments.fromJson(Map<String, dynamic> json) {
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
      prescriptions = <PatientWisePrescriptions>[];
      json['prescriptions'].forEach((v) {
        prescriptions!.add(new PatientWisePrescriptions.fromJson(v));
      });
    }
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
    return data;
  }
}

class PatientWisePrescriptions {
  int? id;
  int? appointmentId;
  int? doctorId;
  String? diseaseId;
  String? note;
  String? otherMedicines;
  String? createdAt;
  String? updatedAt;
  User? user;
  List<PatientWiseMedicines>? medicines;

  PatientWisePrescriptions(
      {this.id,
      this.appointmentId,
      this.doctorId,
      this.diseaseId,
      this.note,
      this.otherMedicines,
      this.createdAt,
      this.updatedAt,
      this.user,
      this.medicines});

  PatientWisePrescriptions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    appointmentId = json['appointment_id'];
    doctorId = json['doctor_id'];
    diseaseId = json['disease_id'];
    note = json['note'];
    otherMedicines = json['other_medicines'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    if (json['medicines'] != null) {
      medicines = <PatientWiseMedicines>[];
      json['medicines'].forEach((v) {
        medicines!.add(new PatientWiseMedicines.fromJson(v));
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
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.medicines != null) {
      data['medicines'] = this.medicines!.map((v) => v.toJson()).toList();
    }
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

class PatientWiseMedicines {
  int? id;
  int? prescriptionId;
  String? productId;
  String? time;
  String? toBeTaken;
  String? createdAt;
  String? updatedAt;

  PatientWiseMedicines(
      {this.id,
      this.prescriptionId,
      this.productId,
      this.time,
      this.toBeTaken,
      this.createdAt,
      this.updatedAt});

  PatientWiseMedicines.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    prescriptionId = json['prescription_id'];
    productId = json['product_id'];
    time = json['time'];
    toBeTaken = json['to_be_taken'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
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
    return data;
  }
}
