import 'package:awesome_place_search/src/core/error/failures/i_failure.dart';
import 'package:awesome_place_search/src/core/services/places_service.dart';
import 'package:awesome_place_search/src/data/models/place_details.dart';

import '../../core/error/exceptions/key_empty_exception.dart';
import '../models/awesome_place_model.dart';

class GetSearchRepository {
  GetSearchRepository({required this.service});

  final PlacesServices service;

  Future<(Failure?, PlaceDetails?)> getDetails({required String placeId}) async {
    try {
      final res = await service.getDetails(param: placeId);
      return (null, res);
    } catch (e,s) {
      return (ServerFailure(message: "Something went wrong"), null);
    }
  }

  Future<(Failure?, AwesomePlacesSearchModel?)> getPlaces({
    required String searchString,
    required String? countries,
    required String? types,
    required String? location,
    required int? radius,
  }) async {
    try {
      final res = await service.getPlaces(
        searchString: searchString,
        countries: countries,
        types: types,
        location: location,
        radius: radius,
      );
      if (res.predictions!.isEmpty) {
        return (EmptyFailure(), null);
      }
      return (null, res);
    } on InvalidKeyException {
      return (InvalidKeyFailure(), null);
    } catch (e) {
      return (ServerFailure(message: e.toString()), null);
    }
  }
}
