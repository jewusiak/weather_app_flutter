import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/daily_forecast_details.dart';

class WeatherForecastBarsWidget extends StatelessWidget {
  final DailyForecastDetails? _dailyForecast;

  const WeatherForecastBarsWidget(this._dailyForecast, {super.key});

  @override
  Widget build(BuildContext context) {
    if (_dailyForecast == null) return Container();
    try {
      var low = double.maxFinite;
      var high = double.maxFinite * -1.0;
      _dailyForecast!.dailyForecasts!
          .map((e) => e.temperature!)
          .forEach((temp) {
        if (temp.minimum!.value! < low) {
          low = temp.minimum!.value!;
        }
        if (temp.maximum!.value! > high) {
          high = temp.maximum!.value!;
        }
      });
      return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: mapForecasts(low, high),
      );
    } catch (e) {
      return Container();
    }
  }

  List<Widget> mapForecasts(low, high) {
    List<Widget> forecasts = [];
    _dailyForecast!.dailyForecasts!.forEach((e) {
      forecasts.add(WeatherForecastColumn(e, low, high));
      forecasts.add(SizedBox(
        width: 5,
      ));
    });
    if (forecasts.isNotEmpty) forecasts.removeLast();
    forecasts.insert(0, Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(" "),
        Text("Low:"),
        Text("High:")
      ],
    ));
    return forecasts;
  }
}

class WeatherForecastColumn extends StatelessWidget {
  final double _low;
  final double _high;
  final DailyForecasts _dailyForecast;

  const WeatherForecastColumn(this._dailyForecast, this._low, this._high,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(getDayNameFromDate(_dailyForecast.date!)),
        Text("${_dailyForecast.temperature!.minimum!.value}°"),
        Text("${_dailyForecast.temperature!.maximum!.value}°")
      ],
    );
  }

  String getDayNameFromDate(String dateString) {
  try {
    final dateTime = DateTime.parse(dateString);
    final formatter = DateFormat('EEE', 'en_US');
    final dayName = formatter.format(dateTime);

    return dayName;
  } catch (e) {
    return "";
  }
}
}
