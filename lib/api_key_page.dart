import 'package:flutter/material.dart';
import 'package:weather_app_flutter/constants.dart';
import 'package:weather_app_flutter/navigator_service.dart';

class ApiKeyPage extends StatelessWidget {
  ApiKeyPage({super.key});

  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
              "Weather app",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.purple),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Input new apikey:"),
              SizedBox(
                height: 50,
              ),
              TextFormField(
                controller: _textController,
              ),
              SizedBox(
                height: 50,
              ),
              ElevatedButton(
                child: Text("Save"),
                onPressed: () {
                  Constants.API_KEY = _textController.value.text;
                  Navigator.of(NavigatorService.navigatorKey.currentContext!).popUntil((route) => route.isFirst);
                },
              )
            ],
          ),
        ));
  }
}
