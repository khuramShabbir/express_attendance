import 'dart:convert';

GetAddressModel getAddressModelFromJson(String str) => GetAddressModel.fromJson(json.decode(str));

String getAddressModelToJson(GetAddressModel data) => json.encode(data.toJson());

class GetAddressModel {
  GetAddressModel({
    required this.empty,
    required this.geocodeResponse,
  });

  String empty;
  GeocodeResponse geocodeResponse;

  factory GetAddressModel.fromJson(Map<String, dynamic> json) => GetAddressModel(
        empty: json["\u0024"],
        geocodeResponse: GeocodeResponse.fromJson(json["GeocodeResponse"]),
      );

  Map<String, dynamic> toJson() => {
        "\u0024": empty,
        "GeocodeResponse": geocodeResponse.toJson(),
      };
}

class GeocodeResponse {
  GeocodeResponse({
    required this.status,
    required this.result,
    required this.plusCode,
  });

  Status status;
  List<Result> result;
  PlusCode plusCode;

  factory GeocodeResponse.fromJson(Map<String, dynamic> json) => GeocodeResponse(
        status: Status.fromJson(json["status"]),
        result: List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
        plusCode: PlusCode.fromJson(json["plus_code"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status.toJson(),
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
        "plus_code": plusCode.toJson(),
      };
}

class PlusCode {
  PlusCode({
    required this.globalCode,
    required this.compoundCode,
  });

  Status globalCode;
  Status compoundCode;

  factory PlusCode.fromJson(Map<String, dynamic> json) => PlusCode(
        globalCode: Status.fromJson(json["global_code"]),
        compoundCode: Status.fromJson(json["compound_code"]),
      );

  Map<String, dynamic> toJson() => {
        "global_code": globalCode.toJson(),
        "compound_code": compoundCode.toJson(),
      };
}

class Status {
  Status({
    required this.empty,
  });

  String empty;

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        empty: json["\u0024"],
      );

  Map<String, dynamic> toJson() => {
        "\u0024": empty,
      };
}

class Result {
  Result({
    required this.type,
    required this.formattedAddress,
    required this.addressComponent,
    required this.geometry,
    required this.placeId,
    this.plusCode,
  });

  dynamic type;
  Status formattedAddress;
  dynamic addressComponent;
  Geometry geometry;
  Status placeId;
  PlusCode? plusCode;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        type: json["type"],
        formattedAddress: Status.fromJson(json["formatted_address"]),
        addressComponent: json["address_component"],
        geometry: Geometry.fromJson(json["geometry"]),
        placeId: Status.fromJson(json["place_id"]),
        plusCode: json["plus_code"] == null ? null : PlusCode.fromJson(json["plus_code"]),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "formatted_address": formattedAddress.toJson(),
        "address_component": addressComponent,
        "geometry": geometry.toJson(),
        "place_id": placeId.toJson(),
        "plus_code": plusCode == null ? null : plusCode?.toJson(),
      };
}

class AddressComponentElement {
  AddressComponentElement({
    required this.longName,
    required this.shortName,
    required this.type,
  });

  Status longName;
  Status shortName;
  dynamic type;

  factory AddressComponentElement.fromJson(Map<String, dynamic> json) => AddressComponentElement(
        longName: Status.fromJson(json["long_name"]),
        shortName: Status.fromJson(json["short_name"]),
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "long_name": longName.toJson(),
        "short_name": shortName.toJson(),
        "type": type,
      };
}

class PurpleAddressComponent {
  PurpleAddressComponent({
    required this.longName,
    required this.shortName,
    required this.type,
  });

  Status longName;
  Status shortName;
  List<Status> type;

  factory PurpleAddressComponent.fromJson(Map<String, dynamic> json) => PurpleAddressComponent(
        longName: Status.fromJson(json["long_name"]),
        shortName: Status.fromJson(json["short_name"]),
        type: List<Status>.from(json["type"].map((x) => Status.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "long_name": longName.toJson(),
        "short_name": shortName.toJson(),
        "type": List<dynamic>.from(type.map((x) => x.toJson())),
      };
}

class Geometry {
  Geometry({
    required this.location,
    required this.locationType,
    required this.viewport,
    required this.bounds,
  });

  Location location;
  Status locationType;
  Viewport viewport;
  Viewport? bounds;

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        location: Location.fromJson(json["location"]),
        locationType: Status.fromJson(json["location_type"]),
        viewport: Viewport.fromJson(json["viewport"]),
        bounds: json["bounds"] == null ? null : Viewport.fromJson(json["bounds"]),
      );

  Map<String, dynamic> toJson() => {
        "location": location.toJson(),
        "location_type": locationType.toJson(),
        "viewport": viewport.toJson(),
        "bounds": bounds == null ? null : bounds?.toJson(),
      };
}

class Viewport {
  Viewport({
    required this.southwest,
    required this.northeast,
  });

  Location southwest;
  Location northeast;

  factory Viewport.fromJson(Map<String, dynamic> json) => Viewport(
        southwest: Location.fromJson(json["southwest"]),
        northeast: Location.fromJson(json["northeast"]),
      );

  Map<String, dynamic> toJson() => {
        "southwest": southwest.toJson(),
        "northeast": northeast.toJson(),
      };
}

class Location {
  Location({
    required this.lat,
    required this.lng,
  });

  Status lat;
  Status lng;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        lat: Status.fromJson(json["lat"]),
        lng: Status.fromJson(json["lng"]),
      );

  Map<String, dynamic> toJson() => {
        "lat": lat.toJson(),
        "lng": lng.toJson(),
      };
}
