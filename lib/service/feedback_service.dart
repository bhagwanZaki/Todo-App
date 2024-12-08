import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:todo/constant/api_routes.dart';

import 'package:todo/utils/api_exception.dart';
import 'package:todo/utils/preferences.dart';

class FeedbackService {
  Preferences prefs = Preferences();

  Future<dynamic> getHeader() async {
    String? token = await prefs.getStringItem("token");

    if (token == null) {
      throw UnauthorisedException("No token found");
    }

    return {'Content-Type': 'multipart/form-data', 'Cookie': token};
  }

  Future<dynamic> createFeedbackApi(File uploadedImage, String feedback) async {
    var header = await getHeader();

    final request =
        http.MultipartRequest('POST', Uri.parse(ApiRoutes.feedbackApi));

    final fileStream = http.ByteStream(uploadedImage.openRead());
    final fileLength = await uploadedImage.length();

    request.headers.addAll(header);
    request.fields['feedback'] = feedback;
    request.files.add(http.MultipartFile(
      'image',
      fileStream,
      fileLength,
      filename: uploadedImage.uri.pathSegments.last,
    ));
    print(request);
    // request.files.add(http.MultipartFile.fromBytes(
    //     'image', await uploadedImage.readAsBytes(),contentType: new MediaType('image', 'jpeg'),));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    // Handle the response with returnResponse
    returnResponse(response);
    return true;
  }
}
