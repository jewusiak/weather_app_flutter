import 'package:flutter/material.dart';
import 'package:weather_app_flutter/navigator_service.dart';

import '../api_key_page.dart';

class Exception503 implements Exception{
  Exception503(){
    Navigator.of(NavigatorService.navigatorKey.currentContext!).popUntil((route) => route.isFirst);
    Navigator.of(NavigatorService.navigatorKey.currentContext!).push(MaterialPageRoute(builder: (context) => ApiKeyPage(),));
  }
}