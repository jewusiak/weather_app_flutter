import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app_flutter/api_client.dart';
import 'package:weather_app_flutter/model/autocomplete_item.dart';
import 'package:weather_app_flutter/model/current_conditions_details.dart';
import 'package:weather_app_flutter/model/daily_forecast_details.dart';
import 'package:weather_app_flutter/model/hourly_forecast_details.dart';
import 'package:weather_app_flutter/model/weather_index.dart';
import 'package:weather_app_flutter/widgets/indices_forecast_widget.dart';
import 'package:weather_app_flutter/widgets/weather_forecast_bars_widget.dart';
import 'package:weather_app_flutter/widgets/weather_hourly_table.dart';

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
                padding: EdgeInsets.only(top: 25, left: 20, right: 20),
                child: Container(
                  width: 400,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.location_on_outlined, size: 18),
                          SizedBox(
                            width: 5,
                          ),
                          Text("${widget._requestedItem.localizedName ?? "n/a"} (${widget._requestedItem.administrativeArea?.localizedName ?? ''}, ${widget._requestedItem.country?.localizedName ?? ''})")
                        ],
                      ),
                      Text(
                        "${_currentConditions?.temperature?.metric?.value?.round() ?? "-"}°",
                        style: GoogleFonts.spaceGrotesk(fontSize: 150),
                      ),
                      Text(
                        "${_currentConditions?.weatherText ?? ""}",
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 20),
                      Text("Next days"),
                      SizedBox(height: 5,),
                      WeatherForecastBarsWidget(_dailyForecast),
                      SizedBox(height: 20),
                      Text("Today"),
                      SizedBox(height: 5,),
                      WeatherHourlyTable(_hourlyForecast),
                      SizedBox(height: 20),
                      IndicesForecastWidget(_uvIndexForecast, _airQualityIndexForecast),
                      SizedBox(height: 80,)
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
