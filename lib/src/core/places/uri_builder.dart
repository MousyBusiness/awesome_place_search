import 'package:http/http.dart';

class PlacesUriBuilder{
  static Uri build({required String authority, required String path, required Map<String, dynamic> param}){
    return Uri.https(authority, path, param);
  }
}