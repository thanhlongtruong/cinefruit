class Cinema {
  String? id;
  String? name;
  String? address;
  String? urlImage;
  String? area;

  Cinema({this.id, this.name, this.address, this.urlImage, this.area});

  Cinema.fromJson(Map<String, dynamic> json) {
    id = json["_id"];
    name = json["name"];
    address = json["address"];
    urlImage = json["urlImage"];
    area = json["area"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["name"] = name;
    data["address"] = address;
    data["urlImage"] = urlImage;
    data["area"] = area;
    return data;
  }
}
