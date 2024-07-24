// https://developers.google.com/maps/documentation/places/web-service/supported_types

extension XPlacesTypes on PlacesTypes {
  String get string {
    if (this == PlacesTypes.regions) {
      return "(regions)";
    }

    if (this == PlacesTypes.cities) {
      return "(cities)";
    }
    return this.toString().replaceAll("PlacesTypes.", "");
  }
}

enum PlacesTypes {
  /// Only allowed a single value if using the following
  geocode,
  address,
  establishment,

  /// (regions) includes the following results
  /// locality,
  /// sublocality,
  /// postal_code,
  /// country,
  /// administrative_area_level_1,
  /// administrative_area_level_2,
  regions, // The string literal will be '(regions)'

  /// (cities) includes the following results
  /// locality
  /// administrative_area_level_3
  cities, // The string literal should be '(cities)'

  /// Up to five of the follow
  accounting,
  airport,
  amusement_park,
  aquarium,
  art_gallery,
  atm,
  bakery,
  bank,
  bar,
  beauty_salon,
  bicycle_store,
  book_store,
  bowling_alley,
  bus_station,
  cafe,
  campground,
  car_dealer,
  car_rental,
  car_repair,
  car_wash,
  casino,
  cemetery,
  church,
  city_hall,
  clothing_store,
  convenience_store,
  courthouse,
  dentist,
  department_store,
  doctor,
  drugstore,
  electrician,
  electronics_store,
  embassy,
  fire_station,
  florist,
  funeral_home,
  furniture_store,
  gas_station,
  gym,
  hair_care,
  hardware_store,
  hindu_temple,
  home_goods_store,
  hospital,
  insurance_agency,
  jewelry_store,
  laundry,
  lawyer,
  library,
  light_rail_station,
  liquor_store,
  local_government_office,
  locksmith,
  lodging,
  meal_delivery,
  meal_takeaway,
  mosque,
  movie_rental,
  movie_theater,
  moving_company,
  museum,
  night_club,
  painter,
  park,
  parking,
  pet_store,
  pharmacy,
  physiotherapist,
  plumber,
  police,
  post_office,
  primary_school,
  real_estate_agency,
  restaurant,
  roofing_contractor,
  rv_park,
  school,
  secondary_school,
  shoe_store,
  shopping_mall,
  spa,
  stadium,
  storage,
  store,
  subway_station,
  supermarket,
  synagogue,
  taxi_stand,
  tourist_attraction,
  train_station,
  transit_station,
  travel_agency,
  university,
  veterinary_care,
  zoo,
}
