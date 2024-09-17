import 'dart:async';
import 'dart:convert';

import 'package:awesome_place_search/src/core/places/uri_builder.dart';
import 'package:awesome_place_search/src/data/models/place_details.dart';
import 'package:flutter/widgets.dart';

import '../error/exceptions/network_exception.dart';
import '../error/exceptions/server_exception.dart';
import '../../data/models/awesome_place_model.dart';
import 'package:http/http.dart' as http;

typedef PlacesRequester = Future<http.Response> Function(Uri uri);

class PlacesServices {
  PlacesServices(this.get);

  final PlacesRequester get;
  final url = "maps.googleapis.com";

  Future<PlaceDetails> getDetails({required String param}) async {
    try {
      final res = await get(PlacesUriBuilder.build(
        authority: url,
        path: "maps/api/place/details/json",
        param: {
          "place_id": param,
        },
      ));
      if (res.statusCode == 200) {
        final value = jsonDecode(res.body) as Map<String, dynamic>;

        final result = PlaceDetails.fromJson(value);
        return result;
      }
      throw ServerException();
    } catch (e, s) {
      print(e);
      print(s.toString());
      throw ServerException();
    }
  }

  Future<AwesomePlacesSearchModel> getPlaces({
    required String searchString,
    String? countries,
    String? types,
    String? location,
    int? radius,
  }) async {
    try {
      final params = <String, dynamic>{
        "input": searchString,
      };

      if (countries != null) {
        params["components"] = countries.split("|").map((c) => "country:$c").join("|");
      }

      if (types != null) {
        params["types"] = types;
      }

      if (location != null) {
        if (radius == null) {
          throw Exception("Required radius with location");
        }
        params["location"] = location;
        params["radius"] = radius;
      }

      var res = await get(PlacesUriBuilder.build(
        authority: url,
        path: "maps/api/place/autocomplete/json",
        param: params,
      ));
      if (res.statusCode == 200) {
        final result = AwesomePlacesSearchModel.fromJson(jsonDecode(res.body));

        return result;
      }
      throw ServerException();
    } on TimeoutException {
      debugPrint("Timed out while trying to get places");
      throw NetworkException();
    } catch (e, s) {
      debugPrint("Error getting places");
      debugPrint(e.toString());
      debugPrint(s.toString());
      throw ServerException();
    }
  }
}
