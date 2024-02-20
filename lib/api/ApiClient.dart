import 'package:get/get.dart';

import '../common/Common.dart';

class ApiClient extends GetConnect implements GetxService{
  late String token;
  final String appBaseUrl;
  late Map<String, String> _mainHeaders;

  ApiClient({required this.appBaseUrl})
  {
    baseUrl = appBaseUrl;
    timeout = Duration(seconds: 30);
    token = Common.TOKEN;
    _mainHeaders = {
      'Content-type' :'application/json; charset=UTF-8',
      'Authorization' : 'Bearer $token'
    };
  }

  Future<Response> getData(String uri) async
  {
    try
    {
      Response response = await get(uri);
      return response;
    }
    catch(e)
    {
      return Response(
        statusCode: 500,
        statusText: e.toString()
      );
    }
  }
}