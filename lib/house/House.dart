class Data {
  double longitude;
  double latitude;
  int zipcode;
  String city;
  String urls;
  int lotSqft;
  double numBathrooms;
  String state;
  String usecode;
  int zpid;
  String createdAt;
  int numBedrooms;
  int houseSqft;
  String modifiedAt;
  int houseId;
  String address;

  Data(
      {this.longitude,
        this.zipcode,
        this.city,
        this.latitude,
        this.urls,
        this.lotSqft,
        this.numBathrooms,
        this.state,
        this.usecode,
        this.zpid,
        this.createdAt,
        this.numBedrooms,
        this.houseSqft,
        this.modifiedAt,
        this.houseId,
        this.address});

  Data.fromJson(Map<String, dynamic> json) {
    longitude = json['longitude'];
    zipcode = json['zipcode'];
    city = json['city'];
    latitude = json['latitude'];
    urls = json['urls'];
    lotSqft = json['lot_sqft'];
    numBathrooms = json['num_bathrooms'];
    state = json['state'];
    usecode = json['usecode'];
    zpid = json['zpid'];
    createdAt = json['created_at'];
    numBedrooms = json['num_bedrooms'];
    houseSqft = json['house_sqft'];
    modifiedAt = json['modified_at'];
    houseId = json['house_id'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['longitude'] = this.longitude;
    data['zipcode'] = this.zipcode;
    data['city'] = this.city;
    data['latitude'] = this.latitude;
    data['urls'] = this.urls;
    data['lot_sqft'] = this.lotSqft;
    data['num_bathrooms'] = this.numBathrooms;
    data['state'] = this.state;
    data['usecode'] = this.usecode;
    data['zpid'] = this.zpid;
    data['created_at'] = this.createdAt;
    data['num_bedrooms'] = this.numBedrooms;
    data['house_sqft'] = this.houseSqft;
    data['modified_at'] = this.modifiedAt;
    data['house_id'] = this.houseId;
    data['address'] = this.address;
    return data;
  }
}


/*

class House {
  String status;
  List<Data> data;

  House({this.status, this.data});

  House.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
 */