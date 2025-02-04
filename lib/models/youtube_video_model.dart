class YoutubeVideoModel {
  bool? success;
  String? message;
  Data? data;

  YoutubeVideoModel({this.success, this.message, this.data});

  YoutubeVideoModel.fromJson(Map<String, dynamic> json) {
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
  List<YoutubeVideoInfo>? data;
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
      data = <YoutubeVideoInfo>[];
      json['data'].forEach((v) {
        data!.add(new YoutubeVideoInfo.fromJson(v));
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

class YoutubeVideoInfo {
  int? id;
  int? diseaseId;
  String? title;
  String? titleHindi;
  String? youtubeLink;
  String? thumbnail;
  String? createdAt;
  String? updatedAt;
  String? displayName;
  DiseaseFromYouTubePlayer? disease;

  YoutubeVideoInfo(
      {this.id,
      this.diseaseId,
      this.title,
      this.titleHindi,
      this.youtubeLink,
      this.thumbnail,
      this.createdAt,
      this.updatedAt,
      this.displayName,
      this.disease});

  YoutubeVideoInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    diseaseId = json['disease_id'];
    title = json['title'];
    titleHindi = json['title_hindi'];
    youtubeLink = json['youtube_link'];
    thumbnail = json['thumbnail'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    displayName = json['display_name'];
    disease = json['disease'] != null
        ? new DiseaseFromYouTubePlayer.fromJson(json['disease'])
        : null;
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
    data['display_name'] = this.displayName;
    if (this.disease != null) {
      data['disease'] = this.disease!.toJson();
    }
    return data;
  }
}

class DiseaseFromYouTubePlayer {
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

  DiseaseFromYouTubePlayer(
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

  DiseaseFromYouTubePlayer.fromJson(Map<String, dynamic> json) {
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
