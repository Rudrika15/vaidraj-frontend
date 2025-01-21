class AllDieseasesModel {
  bool? success;
  String? message;
  Data? data;

  AllDieseasesModel({this.success, this.message, this.data});

  AllDieseasesModel.fromJson(Map<String, dynamic> json) {
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
  List<Diseases>? data;
  int? currentPage;
  int? lastPage;
  int? perPage;
  int? total;

  Data({this.data, this.currentPage, this.lastPage, this.perPage, this.total});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Diseases>[];
      json['data'].forEach((v) {
        data!.add(new Diseases.fromJson(v));
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
  String? displayName;
  String? displayDescription;
  List<Products>? products;
  List<Videos>? videos;
  List<Articles>? articles;

  Diseases(
      {this.id,
      this.diseaseName,
      this.description,
      this.diseaseNameHindi,
      this.descriptionHindi,
      this.url,
      this.thumbnail,
      this.createdAt,
      this.updatedAt,
      this.displayName,
      this.displayDescription,
      this.products,
      this.videos,
      this.articles});

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
    displayName = json['display_name'];
    displayDescription = json['display_description'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
    if (json['videos'] != null) {
      videos = <Videos>[];
      json['videos'].forEach((v) {
        videos!.add(new Videos.fromJson(v));
      });
    }
    if (json['articles'] != null) {
      articles = <Articles>[];
      json['articles'].forEach((v) {
        articles!.add(new Articles.fromJson(v));
      });
    }
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
    data['display_name'] = this.displayName;
    data['display_description'] = this.displayDescription;
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    if (this.videos != null) {
      data['videos'] = this.videos!.map((v) => v.toJson()).toList();
    }
    if (this.articles != null) {
      data['articles'] = this.articles!.map((v) => v.toJson()).toList();
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
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Videos {
  int? id;
  int? diseaseId;
  String? title;
  String? titleHindi;
  String? youtubeLink;
  String? thumbnail;
  String? createdAt;
  String? updatedAt;

  Videos(
      {this.id,
      this.diseaseId,
      this.title,
      this.titleHindi,
      this.youtubeLink,
      this.thumbnail,
      this.createdAt,
      this.updatedAt});

  Videos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    diseaseId = json['disease_id'];
    title = json['title'];
    titleHindi = json['title_hindi'];
    youtubeLink = json['youtube_link'];
    thumbnail = json['thumbnail'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['disease_id'] = this.diseaseId;
    data['title'] = this.title;
    data['title_hindi'] = this.titleHindi;
    data['youtube_link'] = this.youtubeLink;
    data['thumbnail'] = this.thumbnail;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Articles {
  int? id;
  int? diseaseId;
  String? title;
  String? titleHindi;
  String? url;
  String? thumbnail;
  String? createdAt;
  String? updatedAt;

  Articles(
      {this.id,
      this.diseaseId,
      this.title,
      this.titleHindi,
      this.url,
      this.thumbnail,
      this.createdAt,
      this.updatedAt});

  Articles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    diseaseId = json['disease_id'];
    title = json['title'];
    titleHindi = json['title_hindi'];
    url = json['url'];
    thumbnail = json['thumbnail'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['disease_id'] = this.diseaseId;
    data['title'] = this.title;
    data['title_hindi'] = this.titleHindi;
    data['url'] = this.url;
    data['thumbnail'] = this.thumbnail;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
