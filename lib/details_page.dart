import 'package:flutter/material.dart';
import 'package:weather_app_flutter/api_client.dart';
import 'package:weather_app_flutter/model/autocomplete_item.dart';
import 'package:weather_app_flutter/model/current_conditions_details.dart';
import 'package:weather_app_flutter/model/daily_forecast_details.dart';
import 'package:weather_app_flutter/model/hourly_forecast_details.dart';
import 'package:weather_app_flutter/model/weather_index.dart';

class DetailsPage extends StatefulWidget {
  final AutocompleteItem _requestedItem;

  DetailsPage(this._requestedItem, {super.key});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  CurrentConditionsDetails? _currentConditions;
  DailyForecastDetails? _dailyForecast;
  Iterable<HourlyForecastDetails>? _hourlyForecast;
  Iterable<WeatherIndex>? _uvIndexForecast;
  Iterable<WeatherIndex>? _airQualityIndexForecast;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "Weather app",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.purple),
      body: FutureBuilder(
        future: _fetchAllData(widget._requestedItem.key!),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Align(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                padding: EdgeInsets.only(top: 25),
                child: Container(
                  width: 400,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                          "Temp: ${_currentConditions?.temperature?.metric?.value ?? "n/a"} °C"),
                      Text(
                          "Tomorrow temp: ${_dailyForecast?.dailyForecasts?[0].temperature?.minimum?.value ?? "n/a"} °C"),
                      Text(
                          "Next hourly temp: ${_hourlyForecast?.first.temperature?.value ?? "n/a"} °C @ ${_hourlyForecast?.first.dateTime ?? "n/a"}"),
                      Text(
                          "UV index: ${_uvIndexForecast?.first.value ?? "n/a"}/10.0 = ${_uvIndexForecast?.first.category ?? "n/a"}"),
                      Text(
                          "AQ index: ${_airQualityIndexForecast?.first.value ?? "n/a"}/10.0 = ${_airQualityIndexForecast?.first.category ?? "n/a"}"),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Future _fetchAllData(String locationId) async {
    _currentConditions = await ApiClient.fetchCurrentConditions(locationId);
    _dailyForecast = await ApiClient.fetchDailyForecast(locationId);
    _hourlyForecast = await ApiClient.fetchHourlyForecast(locationId);
    _uvIndexForecast =
        await ApiClient.fetchWeatherIndexForecast(locationId, "-15");
    _airQualityIndexForecast =
        await ApiClient.fetchWeatherIndexForecast(locationId, "-10");
  }
}
