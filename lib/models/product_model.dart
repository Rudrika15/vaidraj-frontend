class ProductModel {
  bool? success;
  String? message;
  Data? data;

  ProductModel({this.success, this.message, this.data});

  ProductModel.fromJson(Map<String, dynamic> json) {
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
  List<Product>? data;
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
      data = <Product>[];
      json['data'].forEach((v) {
        data!.add(new Product.fromJson(v));
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

class Product {
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
  String? displayName;
  List<DiseaseProducts>? diseaseProducts;

  Product(
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
      this.updatedAt,
      this.displayName,
      this.diseaseProducts});

  Product.fromJson(Map<String, dynamic> json) {
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
    displayName = json['display_name'];
    if (json['disease_products'] != null) {
      diseaseProducts = <DiseaseProducts>[];
      json['disease_products'].forEach((v) {
        diseaseProducts!.add(new DiseaseProducts.fromJson(v));
      });
    }
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
    data['display_name'] = this.displayName;
    if (this.diseaseProducts != null) {
      data['disease_products'] =
          this.diseaseProducts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DiseaseProducts {
  int? id;
  int? diseaseId;
  int? productId;
  String? createdAt;
  String? updatedAt;
  Disease? diseases;

  DiseaseProducts(
      {this.id,
      this.diseaseId,
      this.productId,
      this.createdAt,
      this.updatedAt,
      this.diseases});

  DiseaseProducts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    diseaseId = json['disease_id'];
    productId = json['product_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    diseases = json['diseases'] != null
        ? new Disease.fromJson(json['diseases'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['disease_id'] = this.diseaseId;
    data['product_id'] = this.productId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.diseases != null) {
      data['diseases'] = this.diseases!.toJson();
    }
    return data;
  }
}

class Disease {
  int? id;
  String? diseaseName;
  String? description;
  String? diseaseNameHindi;
  String? descriptionHindi;
  String? foodPlan;
  String? foodPlanHindi;
  String? url;
  String? thumbnail;
  String? createdAt;
  String? updatedAt;
  String? displayName;
  String? displayDescription;

  Disease(
      {this.id,
      this.diseaseName,
      this.description,
      this.diseaseNameHindi,
      this.descriptionHindi,
      this.foodPlan,
      this.foodPlanHindi,
      this.url,
      this.thumbnail,
      this.createdAt,
      this.updatedAt,
      this.displayName,
      this.displayDescription});

  Disease.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    diseaseName = json['disease_name'];
    description = json['description'];
    diseaseNameHindi = json['disease_name_hindi'];
    descriptionHindi = json['description_hindi'];
    foodPlan = json['food_plan'];
    foodPlanHindi = json['food_plan_hindi'];
    url = json['url'];
    thumbnail = json['thumbnail'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    displayName = json['display_name'];
    displayDescription = json['display_description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['disease_name'] = this.diseaseName;
    data['description'] = this.description;
    data['disease_name_hindi'] = this.diseaseNameHindi;
    data['description_hindi'] = this.descriptionHindi;
    data['food_plan'] = this.foodPlan;
    data['food_plan_hindi'] = this.foodPlanHindi;
    data['url'] = this.url;
    data['thumbnail'] = this.thumbnail;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['display_name'] = this.displayName;
    data['display_description'] = this.displayDescription;
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
