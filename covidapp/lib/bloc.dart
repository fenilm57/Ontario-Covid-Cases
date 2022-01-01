import 'dart:async';
import 'package:covidapp/database/database.dart';
import 'package:covidapp/models/covidData.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

enum CovidInfo { Fetch }

class CovidBloc {
  final _stateStreamController = StreamController<List<CovidData>>();
  StreamSink<List<CovidData>> get _dataSink => _stateStreamController.sink;
  Stream<List<CovidData>> get dataStream => _stateStreamController.stream;

  final _eventStreamController = StreamController<CovidInfo>();
  StreamSink<CovidInfo> get eventSink => _eventStreamController.sink;
  Stream<CovidInfo> get _eventStream => _eventStreamController.stream;

  CovidBloc() {
    _eventStream.listen((event) async {
      if (event == CovidInfo.Fetch) {
        List<CovidData> show = await _getData();
        _dataSink.add(show);
      }
    });
  }

  Future<List<CovidData>> _getData() async {
    debugPrint("Hello");
    var data = await http.get(
        Uri.parse("https://api.opencovid.ca/timeseries?stat=cases&loc=ON"));
    var jsonData = json.decode(data.body);
    var jsonCases = jsonData["cases"];

    List<CovidData> show2 = await dataDisplay();

    //Check if there are already cases or not if there is then updates else inserts Data

    if (show2.isEmpty) {
      for (var i = 0; i < jsonCases.length; i++) {
        if (i >= jsonCases.length - 7) {
          await insertData(CovidData(
              cases: jsonCases[i]["cases"], date: jsonCases[i]["date_report"]));
        }
      }
    } else {
      for (var i = 0; i < jsonCases.length; i++) {
        if (i >= jsonCases.length - 7) {
          await updatedata(CovidData(
              cases: jsonCases[i]["cases"], date: jsonCases[i]["date_report"]));
        }
      }
    }

    List<CovidData> show = await dataDisplay();
    return show.reversed.toList();
  }
}
