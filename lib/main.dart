import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

Future<List<Data>> fetchData() async {
  var url =
      Uri.parse('https://countriesnow.space/api/v0.1/countries/flag/unicode');
  final response = await http.get(url);
  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    final jsonResponse = jsonData['data'] as List;
    final a = jsonResponse.map((data) => Data.fromJson(data)).toList();
    return a;
  } else {
    throw Exception('Unexpected error occured!');
  }
}

class Data {
  final String name;
  final String unicodeFlag;

  Data({required this.name, required this.unicodeFlag});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      name: json['name'],
      unicodeFlag: json['unicodeFlag'],
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'List Item',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Country List'),
        centerTitle: true,
      ),
      body: const Body(),
    );
  }
}

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Data>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(10),
              child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        Text(
                          snapshot.data![index].unicodeFlag,
                          style: const TextStyle(
                            fontSize: 30,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Text(
                          snapshot.data![index].name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 25,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    );
                  }),
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return const CircularProgressIndicator();
        });
  }
}
