import 'dart:async';

import 'package:http/http.dart';
import 'package:photo_search/Resources/StringContants.dart';
import 'package:photo_search/Resources/secrets.dart';
import 'package:photo_search/model/imageModel.dart';

Future<List<PixBayImage>> getPics(
    String searchTerm, String pageNumber, String imagePerPage) async {
  final String url =
      "$urlStart?key=$API_KEY&q=$searchTerm&$queryParamConstant&page=$pageNumber&per_page=$imagePerPage";
  final response = await get(url);
  if (response.statusCode == 200) {
    return welcomeFromJson(response.body).pixBayImageList;
  } else {
    print("The service is Down and response code is : " +
        response.statusCode.toString());
    return null;
  }
}
