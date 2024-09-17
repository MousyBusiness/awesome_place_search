import 'package:awesome_place_search/awesome_place_search.dart';
import 'package:awesome_place_search/src/core/error/failures/i_failure.dart';
import 'package:awesome_place_search/src/core/services/places_service.dart';
import 'package:awesome_place_search/src/data/models/awesome_place_model.dart';
import 'package:awesome_place_search/src/data/models/place_details.dart';
import 'package:awesome_place_search/src/data/repositories/get_search_repository.dart';
import 'package:awesome_place_search/src/presentation/controller/search_state.dart';

// https://developers.google.com/maps/documentation/places/web-service/autocomplete
class AwesomePlaceSearchController {
  AwesomePlaceSearchController({
    required this.requester,
    required this.countries,
    required this.types,
    this.location,
    this.radius,
  }) {
    repository = GetSearchRepository(service: PlacesServices(requester));
  }

  final PlacesRequester requester;
  late final GetSearchRepository repository;

  /// Location and radius should be used together
  /// latitude,longitude
  final String? location;

  /// meters
  final int? radius;

  /// Pipe separated string of iban alpha-2 codes e.g. us|ad (United States and Andorra)
  /// https://www.iban.com/country-codes
  final String? countries;

  /// Pipe separated string e.g. airport|bar see PlacesTypes for valid values
  final List<PlacesTypes>? types;

  String? get typesString {
    if (types == null || types!.isEmpty) return null;

    return types!.map((e) => e.string).join("|");
  }

  Future<(Failure?, AwesomePlacesSearchModel?)> getPlaces({required String searchString}) async {
    final result = await repository.getPlaces(
      searchString: searchString,
      location: location,
      radius: radius,
      countries: countries,
      types: typesString,
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
