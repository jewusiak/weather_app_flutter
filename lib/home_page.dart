import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:weather_app_flutter/api_client.dart';
import 'package:weather_app_flutter/model/autocomplete_item.dart';

import 'details_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _uuidGenerator = Uuid();
  AutocompleteItem? _selectedOption;
  String? _requestDelayKey;
  Iterable<AutocompleteItem> _hints = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "Weather app",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.purple),
      body: Align(
        alignment: Alignment.topCenter,
        child: Padding(
            padding: EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("What's the weather like in...?"),
                Container(
                  width: 300,
                  child: Autocomplete<AutocompleteItem>(
                    optionsBuilder: (value) async {
                      if (value.text == "") return [];
                      var requestUuid = _uuidGenerator.v4();
                      _requestDelayKey = requestUuid;
                      await Future.delayed(const Duration(milliseconds: 500));
                      if (requestUuid == _requestDelayKey) {
                        _hints =
                            await ApiClient.getAutocompleteHints(value.text);
                      }
                      return _hints;
                    },
                    displayStringForOption: (option) =>
                        option.localizedName ?? "",
                    optionsViewBuilder: (context, onSelected, options) => Align(
                      alignment: Alignment.topLeft,
                      child: Material(
                        elevation: 4.0,
                        // size works, when placed here below the Material widget
                        child: Container(
                          width: 300,
                          height: 500,
                          child: ListView.separated(
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(8.0),
                            itemCount: options.length,
                            separatorBuilder: (context, i) => Divider(),
                            itemBuilder: (BuildContext context, int index) {
                              var option = options.elementAt(index);
                              return ListTile(
                                  onTap: () => onSelected(option),
                                  title: Text(option.localizedName ?? ""),
                                  subtitle: Text(
                                    "${option.administrativeArea?.localizedName ?? ''}, ${option.country?.localizedName ?? ''}",
                                    softWrap: true,
                                  ));
                            },
                          ),
                        ),
                      ),
                    ),
                    onSelected: (option) {
                      _selectedOption = option;
                    },
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                ElevatedButton(
                  child: Text("Go!"),
                  onPressed: () async => await handleSelect(_selectedOption),
                )
              ],
            )),
      ),
    );
  }

  Future handleSelect(AutocompleteItem? selectedOption) async {
    if (selectedOption == null) return;
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => DetailsPage(selectedOption!),
    ));
  }
}
