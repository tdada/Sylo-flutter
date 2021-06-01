class QcastDashboardItem {
  QcastDashboardItem({
    this.featuredQcasts,
    this.mostPopularQcasts,
    this.mySubscriptions,
  });

  List<DiscoverQcastItem> featuredQcasts;
  List<DiscoverQcastItem> mostPopularQcasts;
  List<DiscoverQcastItem> mySubscriptions;

  factory QcastDashboardItem.fromJson(Map<String, dynamic> json) => QcastDashboardItem(
    featuredQcasts: json["FeaturedQcasts"]!=null ? List<DiscoverQcastItem>.from(json["FeaturedQcasts"].map((x) => DiscoverQcastItem.fromJson(x))) : List<DiscoverQcastItem>(),
    mostPopularQcasts: json["MostPopularQcasts"]!=null ? List<DiscoverQcastItem>.from(json["MostPopularQcasts"].map((x) => DiscoverQcastItem.fromJson(x))) : List<DiscoverQcastItem>(),
    mySubscriptions: json["MySubscriptions"]!=null ? List<DiscoverQcastItem>.from(json["MySubscriptions"].map((x) => DiscoverQcastItem.fromJson(x))) : List<DiscoverQcastItem>(),
  );

  Map<String, dynamic> toJson() => {
    "FeaturedQcasts": List<dynamic>.from(featuredQcasts.map((x) => x.toJson())),
    "MostPopularQcasts": List<dynamic>.from(mostPopularQcasts.map((x) => x.toJson())),
    "MySubscriptions": List<dynamic>.from(mySubscriptions.map((x) => x.toJson())),
  };
}

class DiscoverQcastItem {
  DiscoverQcastItem({
    this.qcasId,
    this.userId,
    this.name,
    this.description,
    this.coverPhoto,
    this.qcastOrUserid,
  });

  int qcasId;
  int userId;
  int qcastOrUserid;
  String name;
  String description;
  String coverPhoto;

  factory DiscoverQcastItem.fromJson(Map<String, dynamic> json) => DiscoverQcastItem(
    qcasId: json["qcasId"] == null ? 0: json["qcasId"],
    userId: json["userId"] == null ? 0: json["userId"],
    name: json["name"],
    description: json["description"],
    coverPhoto: json["coverPhoto"],
    qcastOrUserid: json["qcastOrUserid"] == null ? 0: json["qcastOrUserid"],
  );

  Map<String, dynamic> toJson() => {
    "qcasId": qcasId,
    "userId": userId,
    "name": name,
    "description": description,
    "coverPhoto": coverPhoto,
    "qcastOrUserid": qcastOrUserid,
  };
}

class MyDownloadedQcastItem {
  MyDownloadedQcastItem({
    this.recipientQcasts,
    this.downloadedQcasts,
  });

  List<DiscoverQcastItem> recipientQcasts;
  List<DiscoverQcastItem> downloadedQcasts;

  factory MyDownloadedQcastItem.fromJson(Map<String, dynamic> json) => MyDownloadedQcastItem(
    recipientQcasts: json["recipientQcast"]!=null ? List<DiscoverQcastItem>.from(json["recipientQcast"].map((x) => DiscoverQcastItem.fromJson(x))) : List<DiscoverQcastItem>(),
    downloadedQcasts: json["downloadedQcasts"]!=null ? List<DiscoverQcastItem>.from(json["downloadedQcasts"].map((x) => DiscoverQcastItem.fromJson(x))) : List<DiscoverQcastItem>(),
  );

  Map<String, dynamic> toJson() => {
    "recipientQcast": List<dynamic>.from(recipientQcasts.map((x) => x.toJson())),
    "downloadedQcasts": List<dynamic>.from(downloadedQcasts.map((x) => x.toJson())),
  };
}