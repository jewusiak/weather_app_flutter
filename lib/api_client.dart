import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_app_flutter/constants.dart';
import 'package:weather_app_flutter/exceptions/exception_503.dart';
import 'package:weather_app_flutter/model/autocomplete_item.dart';
import 'package:weather_app_flutter/model/current_conditions_details.dart';
import 'package:weather_app_flutter/model/daily_forecast_details.dart';
import 'package:weather_app_flutter/model/hourly_forecast_details.dart';
import 'package:weather_app_flutter/model/weather_index.dart';

import 'exceptions/request_failure_exception.dart';

class ApiClient {
  static const AUTOCOMPLETE_URL =
      "http://dataservice.accuweather.com/locations/v1/cities/autocomplete";
  static const CURRENT_CONDITIONS_URL =
      "http://dataservice.accuweather.com/currentconditions/v1/";
  static const DAILY_FORECAST_URL =
      "http://dataservice.accuweather.com/forecasts/v1/daily/5day/";
  static const HOURLY_FORECAST_URL =
      "http://dataservice.accuweather.com/forecasts/v1/hourly/12hour/";
  static const INDEX_FORECAST_URL =
      "http://dataservice.accuweather.com/indices/v1/daily/5day/";

  static Future<Iterable<AutocompleteItem>> getAutocompleteHints(
      String q) async {
    final params = {
      'apikey': Constants.API_KEY,
      'q': q,
      //'language': 'en-us'
    };
    var res = await makeGetRequest(
        Uri.parse(AUTOCOMPLETE_URL).replace(queryParameters: params));
    var obj = jsonDecode(res.body);
    var autocompleteItems =
        (obj as List).map((e) => AutocompleteItem.fromJson(e));
    return autocompleteItems;
  }

  static Future<CurrentConditionsDetails> fetchCurrentConditions(
      String locationId) async {
    final params = {
      'apikey': Constants.API_KEY,
      'details': 'true'
      //'language': 'en-us'
    };
    var res = await makeGetRequest(
        Uri.parse(CURRENT_CONDITIONS_URL + locationId)
            .replace(queryParameters: params));
    var obj = jsonDecode(res.body);
    return CurrentConditionsDetails.fromJson(obj[0]);
  }

  static Future<DailyForecastDetails> fetchDailyForecast(
      String locationId) async {
    final params = {
      'apikey': Constants.API_KEY,
      'details': 'false',
      'metric': 'true'
      //'language': 'en-us'
    };
    var res = await makeGetRequest(Uri.parse(DAILY_FORECAST_URL + locationId)
        .replace(queryParameters: params));
    var obj = jsonDecode(res.body);
    return DailyForecastDetails.fromJson(obj);
  }

  static Future<Iterable<HourlyForecastDetails>> fetchHourlyForecast(
      String locationId) async {
    final params = {
      'apikey': Constants.API_KEY,
      'details': 'false',
      'metric': 'true'
      //'language': 'en-us'
    };
    var res = await makeGetRequest(Uri.parse(HOURLY_FORECAST_URL + locationId)
        .replace(queryParameters: params));
    var obj = jsonDecode(res.body);
    var forecastItems =
        (obj as List).map((e) => HourlyForecastDetails.fromJson(e));
    return forecastItems;
  }

  static Future<Iterable<WeatherIndex>> fetchWeatherIndexForecast(
      String locationId, String indexId) async {
    final params = {
      'apikey': Constants.API_KEY,
      'details': 'false'
      //'language': 'en-us'
    };
    var res = await makeGetRequest(
        Uri.parse("$INDEX_FORECAST_URL$locationId/$indexId")
            .replace(queryParameters: params));
    var obj = jsonDecode(res.body);
    var forecastItems =
        (obj as List).map((e) => WeatherIndex.fromJson(e));
    return forecastItems;
  }

  static Future<http.Response> makeGetRequest(Uri uri) async {
    var res = await http.get(uri);
    if ([503, 403, 401].contains(res.statusCode)) {
      throw Exception503();
    } else if (res.statusCode != 200) {
      throw RequestFailureException(
          "Current conditions request failed with code ${res.statusCode}. Message: ${res.body}");
    }

    return res;
  }
}
