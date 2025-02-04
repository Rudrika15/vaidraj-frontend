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

  @override
  String toString() {
    return 'PrescriptionModel(patientName: $patientName, diseases: $diseases)';
  }
}

class Diseases {
  String? diseaseName;
  List<Medicine>? medicine;

  Diseases({this.diseaseName, this.medicine});

  Diseases.fromJson(Map<String, dynamic> json) {
    diseaseName = json['diseaseName'];
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
    if (this.medicine != null) {
      data['medicine'] = this.medicine!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Diseases && other.diseaseName == diseaseName;
  }

  @override
  int get hashCode => diseaseName.hashCode;

  @override
  String toString() {
    return 'Diseases(diseaseName: $diseaseName, medicine: $medicine)';
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

  @override
  String toString() {
    return 'Products(id: $id, name: $name)';
  }
}

class Medicine {
  int? productId;
  bool? isSelected = false;
  List<String>? time;
  String? toBeTaken;

  Medicine({this.productId, this.time, this.toBeTaken, this.isSelected});

  Medicine.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    isSelected = json['isSelected'];
    time = json['time'].cast<String>();
    toBeTaken = json['to_be_taken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['isSelected'] = this.isSelected;
    data['time'] = this.time?.join(',');
    data['to_be_taken'] = this.toBeTaken;
    return data;
  }

  @override
  String toString() {
    return 'Medicine(productId: $productId, isSelected: $isSelected, time: $time, toBeTaken: $toBeTaken)';
  }
}
