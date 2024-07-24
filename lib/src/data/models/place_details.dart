import 'package:collection/collection.dart';
class PlaceDetails {
  PlaceDetails({this.country, this.city, this.latitude, this.longitude});

  String? country;
  String? city;
  double? latitude;
  double? longitude;

  factory PlaceDetails.fromJson(Map<String, dynamic> json){
    final result = json['result'];
    final address = result["address_components"] as List<dynamic>;
    
    final country = address.firstWhereOrNull((e)=> (e["types"]).contains("country"))?["long_name"];
    String? city = address.firstWhereOrNull((e)=> (e["types"]).contains("locality"))?["long_name"];
    city ??= address.firstWhereOrNull((e)=> (e["types"]).contains("administrative_area_level_3"))?["long_name"];
    final latitude =result['geometry']['location']['lat'];
    final longitude =result['geometry']['location']['lng'];
    return PlaceDetails(country: country, city: city, latitude: latitude, longitude: longitude);
  }
}
