import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:food_example/config/serveraddress.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'app_exceptions.dart';

typedef CustomResponse = Function(Map<String, dynamic> response, String error);

class RestAPI {
  Future checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup(ServerAddress.foodList);

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
      }
    } on SocketException catch (_) {
      print('not connected');
    }
  }

  Future<T> get<T>(String url, {params} /*[String t]*/) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    //String token = prefs.getString('akhil@intertoons.com');
    var params1 = params;
    print('Api Get, url $url');
    T responseJson;
    print('Params----- $params1');

    Uri uri = Uri.parse(url);

    uri.replace(queryParameters: params1);
    try {
      Response response = await http.get(url, headers: {
        "Accept": "application/json",
        'Content-type': 'application/json',
        "Authorization": "Bearer akhil@intertoons.com"
      });

      //print("token  :: $token");
      print("RESPONSE  :: ${response.body}");
      responseJson = _returnResponse(response);
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    }
    print('api get recieved!');
    return responseJson;
  }

  Future<T> post<T>(String url, {params}) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    //String token = prefs.getString('akhil@intertoons.com');
    print('Api Post, url $url  and ${json.encode(params)}');
    T responseJson;
    try {
      final response = await http
          .post(url, body: utf8.encode(json.encode(params)), headers: {
        "Accept": "application/json",
        'Content-type': 'application/json',
        //"Authorization": "Bearer akhil@intertoons.com"
      });
      print("POST RESPONSE : ${response.statusCode} ${response.body}");
      responseJson = _returnResponse(response);
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    }
    print('api post.');
    return responseJson;
  }

  Future<dynamic> put(String url, {params}) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    //String token = prefs.getString('akhil@intertoons.com');
    print('Api Put, url $url');
    var responseJson;

    try {
      final response = await http.put(url, body: json.encode(params), headers: {
        "Accept": "application/json",
        'Content-type': 'application/json',
        "Authorization": "Bearer akhil@intertoons.com"
      });
      responseJson = _returnResponse(response);
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    }
    print('api put.');
//    print(responseJson.toString());
    return responseJson;
  }

  Future<dynamic> delete(String url) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String token = prefs.getString('akhil@intertoons.com');
    print('Api delete, url $url');
    var apiResponse;
    try {
      final response = await http.delete(url, headers: {
        "Accept": "application/json",
        "Authorization": "Bearer akhil@intertoons.com"
      });
      print("Delete RESPONSE : ${response.statusCode} ${response.body}");
      apiResponse = _returnResponse(response);
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    }
    print('api delete.');
    return apiResponse;
  }
}

dynamic _returnResponse<T>(T response) {
  print('respose-------------- $T');
  if (response is http.Response) {
    print(response.body);
    print('statusCode------------- ${response.statusCode}');
    switch (response.statusCode) {
      case 200:
        var responseJson = response.body;
        print("responseJson : $responseJson");

        return responseJson;
      case 404:
      case 400:
        throw BadRequestException(response.body);
      case 401:
      case 403:
        throw UnauthorisedException(response.body);
      case 500:
      default:
        // showToast(msg: AppStrings.serverDown);
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  } else if (response is Map<String, dynamic>) {
    print("MAP :::");
    print(response);
    switch (response["code"]) {
      case 200:
        var responseJson = response["response"];
        print("responseJson : $responseJson");
        return responseJson;
      case 404:
      case 400:
        throw BadRequestException(response["response"]);
      case 401:
      case 403:
        throw UnauthorisedException(response["response"]);
      case 500:
      default:
        // showToast(msg: AppStrings.serverDown);
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response["code"]}');
    }
  }
}

Future getData(String url, {String authorization}) async {
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  //String token = prefs.getString('akhil@intertoons.com');
  var data;
  try {
    http.Response response = await http.get(Uri.encodeFull(url), headers: {
      "Accept": "application/json",
      "Authorization": "Bearer akhil@intertoons.com"
    });
//      GlobalWidgets().printMsg(json.decode(response.body));
    data = json.decode(response.body); /*JSON.decode(response.body);*/
  } on TimeoutException catch (error) {
    print('TimeoutException : $error');
  } on SocketException catch (error) {
    print('SocketException : $error');
  } on HttpException catch (error) {
    print('HttpException : $error');
  }
  return data;
}

///[MEDIA] get full size image without crop
///[THUMB] get cropped size image
enum ImageConversion { MEDIA, THUMB }
enum ImageFolder { PROFILE, DOCUMENT, TOL }

class APis {
  ///[imageSize] will only need when [imageConversion] is thumb
  String imageApi(String imageName,
      {int imageSize = 0,
      ImageConversion imageConversion = ImageConversion.MEDIA,
      ImageFolder imageFolder = ImageFolder.PROFILE}) {
    if (imageSize > 0 && imageConversion == ImageConversion.MEDIA)
      throw "Change $imageConversion to ImageConversion.THUMB when setting the size of image.";
    var conversion =
        imageConversion == ImageConversion.MEDIA ? "media" : "thumb";
    var folder = imageFolder == ImageFolder.PROFILE
        ? "profiles"
        : imageFolder == ImageFolder.TOL
            ? 'products'
            : "documents";
    return "${ServerAddress.foodList}/$conversion/$folder/$imageName/${imageSize > 0 ? imageSize : ''}";
  }
}
