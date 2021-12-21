import 'package:covidapp/CovidData.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Ontario Covid Detail"),
        ),
        body: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var t2 = 0;
  TextStyle textStyle() {
    return const TextStyle(
      fontSize: 20,
    );
  }

  Future<List<CovidData>> _getData() async {
    debugPrint("Hello");
    var data = await http.get(
        Uri.parse("https://api.opencovid.ca/timeseries?stat=cases&loc=ON"));
    var jsonData = json.decode(data.body);
    var jsonCases = jsonData["cases"];
    // debugPrint((jsonData["cases"][0]["cases"]).toString());
    List<CovidData> covid = [];

    for (var i = 0; i < jsonCases.length; i++) {
      if (i >= jsonCases.length - 7) {
        covid.add(CovidData(
            cases: jsonCases[i]["cases"], date: jsonCases[i]["date_report"]));
      }
    }
    //debugPrint("covid.length = ${covid.length}");
    return covid;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.data == null) {
          return const Center(
            child: Text("Loading..."),
          );
        } else {
          return Column(
            children: [
              SizedBox(
                height: 600,
                child: ListView.builder(
                  reverse: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (ctx, index) {
                    var total = 0;

                    for (var i = 0; i < snapshot.data.length; i++) {
                      total = snapshot.data[i].cases;
                      t2 += total;
                    }
                    return Column(
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Cases: ",
                                    style: textStyle(),
                                  ),
                                  Text(
                                    (snapshot.data[index].cases).toString(),
                                    style: textStyle().copyWith(
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Date : ",
                                    style: textStyle(),
                                  ),
                                  Text(
                                    (snapshot.data[index].date).toString(),
                                    style: textStyle().copyWith(
                                      color: Colors.green,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const Divider(
                              color: Colors.amber,
                            )
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Total 7 days Cases : ",
                      style: textStyle(),
                    ),
                    Text(
                      t2.toString(),
                      style: textStyle().copyWith(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        }
      },
    );
  }
}
