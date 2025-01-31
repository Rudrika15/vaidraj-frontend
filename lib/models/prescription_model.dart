class PrescriptionModel {
  String? patientName;
  List<Diseases>? diseases;

  PrescriptionModel({this.patientName, this.diseases});

  PrescriptionModel.fromJson(Map<String, dynamic> json) {
    patientName = json['patientName'];
    if (json['diseases'] != null) {
      diseases = <Diseases>[];
      json['diseases'].forEach((v) {
        diseases!.add(new Diseases.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['patientName'] = this.patientName;
    if (this.diseases != null) {
      data['diseases'] = this.diseases!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Diseases {
  String? diseaseName;
  List<Products>? products;
  List<Medicine>? medicine;

  Diseases({this.diseaseName, this.products, this.medicine});

  Diseases.fromJson(Map<String, dynamic> json) {
    diseaseName = json['diseaseName'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
    if (json['medicine'] != null) {
      medicine = <Medicine>[];
      json['medicine'].forEach((v) {
        medicine!.add(new Medicine.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['diseaseName'] = this.diseaseName;
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    if (this.medicine != null) {
      data['medicine'] = this.medicine!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Products {
  int? id;
  String? name;

  Products({this.id, this.name});

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class Medicine {
  int? productId;
  List<String>? time;
  String? toBeTaken;

  Medicine({this.productId, this.time, this.toBeTaken});

  Medicine.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    time = json['time'].cast<String>();
    toBeTaken = json['to_be_taken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['time'] = this.time;
    data['to_be_taken'] = this.toBeTaken;
    return data;
  }
}
