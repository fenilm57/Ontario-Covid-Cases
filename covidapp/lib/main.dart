import 'package:covidapp/covidUI.dart';
import 'package:covidapp/database/database.dart';
import 'package:flutter/material.dart';

void main() async {
  await initializeDB();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Ontario 7 Days Covid Cases"),
        ),
        body: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: const Text('See Cases'),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CovidUI(),
            ),
          );
        },
      ),
    );
  }
}
