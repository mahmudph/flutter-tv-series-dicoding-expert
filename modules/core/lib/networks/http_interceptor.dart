import 'dart:convert';

import 'package:core/core.dart';
import 'package:flutter/rendering.dart';
import 'package:http_interceptor/http/interceptor_contract.dart';
import 'package:http_interceptor/models/request_data.dart';
import 'package:http_interceptor/models/response_data.dart';

class AppInterceptor implements InterceptorContract {
  final String apiKey;
  AppInterceptor({required this.apiKey});

  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    data.params['apikey'] = apiKey;
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    if (data.statusCode != 200 || data.statusCode == 201) {
      final payload = data.body != null ? json.decode(data.body!) : {};

      final hasErrorMessage = payload.containsKey('status_message');
      final errorMessage = hasErrorMessage ? payload['status_message'] : null;

      debugPrint(errorMessage);
      throw ServerException(message: errorMessage);
    }
    return data;
  }
}
