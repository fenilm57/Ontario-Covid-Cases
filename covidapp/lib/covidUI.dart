import 'package:covidapp/bloc.dart';
import 'package:covidapp/database/database.dart';
import 'package:covidapp/models/covidData.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CovidUI extends StatefulWidget {
  const CovidUI({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<CovidUI> {
  TextStyle textStyle() {
    return const TextStyle(
      fontSize: 20,
    );
  }

  final dataBloc = CovidBloc();

  @override
  void initState() {
    super.initState();
    dataBloc.eventSink.add(CovidInfo.Fetch);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ontario 7 Days Covid Cases"),
      ),
      body: StreamBuilder<List<CovidData>>(
          stream: dataBloc.dataStream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height - 100,
                  child: ListView.builder(
                    // reverse: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (ctx, index) {
                      return Column(
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
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          }),
    );
  }
}
