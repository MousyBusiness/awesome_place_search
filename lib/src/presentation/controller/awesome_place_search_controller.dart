import 'package:awesome_place_search/src/core/client/http_client.dart';
import 'package:awesome_place_search/src/core/error/failures/i_failure.dart';
import 'package:awesome_place_search/src/core/services/places_service.dart';
import 'package:awesome_place_search/src/data/models/awesome_place_model.dart';
import 'package:awesome_place_search/src/data/models/place_details.dart';
import 'package:awesome_place_search/src/data/repositories/get_search_repository.dart';
import 'package:awesome_place_search/src/presentation/controller/search_state.dart';

// https://developers.google.com/maps/documentation/places/web-service/autocomplete
class AwesomePlaceSearchController {
  AwesomePlaceSearchController({
    required String apiKey,
    required this.location,
    required this.radius,
    required this.countries,
    required this.types,
  }) {
    repository = GetSearchRepository(service: PlacesServices(apiKey: apiKey, http: HttpClient()));
  }

  late final GetSearchRepository repository;
  final String? location;
  final int? radius;
  final String? countries;
  final String? types;

  Future<(Failure?, AwesomePlacesSearchModel?)> getPlaces({required String searchString}) async {
    final result = await repository.getPlaces(
      searchString: searchString,
      location: location,
      radius: radius,
      countries: countries,
      types: types,
    );

    return result;
  }

  Future<(Failure?, PlaceDetails?)> getDetails({required String value}) async {
      final result = await repository.getDetails(placeId: value);

    return result;
  }

  SearchState mapError(Failure left) {
    if (left is InvalidKeyFailure) {
      return SearchState.invalidKey;
    }

    if (left is EmptyFailure) {
      return SearchState.empty;
    }

    return SearchState.serverError;
  }
}
