import 'dart:developer';
import 'package:http_interceptor/http/interceptor_contract.dart';
import 'package:http_interceptor/models/request_data.dart';
import 'package:http_interceptor/models/response_data.dart';

class AppLogInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    final path = data.baseUrl;
    final method = data.method;
    final payload = data.body;

    log(
      '''
        http request
        path => $path
        method => $method
        payload => $payload
      ''',
    );

    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    log('received data from request url ${data.request?.url} with status code ${data.statusCode}');
    return data;
  }
}
