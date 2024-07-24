import 'dart:async';
import 'dart:convert';

import 'package:awesome_place_search/src/core/client/http_client.dart';
import 'package:awesome_place_search/src/core/error/exceptions/key_empty_exception.dart';
import 'package:awesome_place_search/src/data/models/place_details.dart';

import '../error/exceptions/network_exception.dart';
import '../error/exceptions/server_exception.dart';
import '../../data/models/awesome_place_model.dart';

class PlacesServices {
  PlacesServices({
    required this.apiKey,
    required this.http,
  });

  final String apiKey;
  final HttpClient http;
  final url = "maps.googleapis.com";

  Future<PlaceDetails> getDetails({required String param}) async {
    try {
      var res = await http.get(
        authority: url,
        path: "maps/api/place/details/json",
        param: {
          "place_id": param,
          "key": apiKey,
        },
      );
      if (res.statusCode == 200) {
        final value = jsonDecode(res.body) as Map<String, dynamic>;

        final result = PlaceDetails.fromJson(value);
        return result;
      }
      throw ServerException();
    } catch (e,s) {
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
    if (apiKey.isEmpty || apiKey.contains(' ')) {
      throw InvalidKeyException();
    } else {
      try {
        final params = <String, dynamic>{
          "key": apiKey,
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

        var res = await http.get(
          authority: url,
          path: "maps/api/place/autocomplete/json",
          param: params,
        );
        if (res.statusCode == 200) {
          final result = AwesomePlacesSearchModel.fromJson(jsonDecode(res.body));

          return result;
        }
        throw ServerException();
      } on TimeoutException {
        throw NetworkException();
      } catch (e) {
        throw ServerException();
      }
    }
  }
}
