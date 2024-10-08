import 'package:awesome_place_search/awesome_place_search.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PredictionModel? prediction;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: AwesomePlacesSearch(
        controller: AwesomePlaceSearchController(
          requester: (Uri uri) {
            throw Exception();
          },
          location: '',
          radius: null,
          countries: '',
          types: [],
        ),
        onSelected: (v) {},
        itemBuilder: (context, title, address, onTap) {
          return ListTile(title: Text(title), subtitle: Text(address), onTap: onTap);
        },
        searchBuilder: (context, onChanged) {
          return TextFormField(
            onChanged: onChanged,
          );
        },
        emptyBuilder: (context) {
          return Container(color: Colors.white, child: const Text("Empty"));
        },
        loadingBuilder: (context) {
          return Container(color: Colors.white, child: const CircularProgressIndicator());
        },
        invalidKeyBuilder: (context) {
          return Container(color: Colors.white, child: const Text("Invalid API Key"));
        },
        errorBuilder: (context) {
          return Container(color: Colors.white, child: const Text("Error"));
        },
        noneBuilder: (BuildContext context) {
          return Container(color: Colors.white, child: const Text("Start searching"));
        },
      ),
    );
  }

  Widget _line({required String title, required String subTitle}) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "$title: ",
            style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.black, fontSize: 20),
          ),
          TextSpan(
            text: " $subTitle",
            style: const TextStyle(color: Colors.black, fontSize: 15),
          ),
        ],
      ),
    );
  }
}
