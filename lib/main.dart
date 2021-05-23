import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'color_picker/color_picker.dart';

// const String fileId = "606ebaf44b314";
const String fileId = "60795941596bd";
final String endPoint =  kIsWeb
    ? "https://localhost/v1"
    : Platform.isLinux
        ? "https://localhost/v1"
        : "https://10.0.2.2/v1"
    ;
const String project = "6079592215d4e";

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Appwrite Image API',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double borderRadius = 0;
  double borderWidth = 0;
  Color borderColor = Colors.red;
  Color backgroundColor = Colors.white;
  double opacity = 1;
  Client client = Client();
  late Storage storage;

  @override
  void initState() {
    super.initState();
    client
        .setEndpoint(endPoint)
        .setProject(project)
        .setSelfSigned()
        .addHeader("origin", "https://localhost");
    storage = Storage(client);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image API features"),
      ),
      body: ListView(
        children: [
          FutureBuilder<Response>(
            future: storage.getFilePreview(
              fileId: fileId,
              width: 600,
              borderWidth: borderWidth.toInt(),
              borderColor:
                  "${borderColor.value.toRadixString(16).substring(2)}",
              borderRadius: borderRadius.toInt(),
              opacity: opacity,
              background:
                  "${backgroundColor.value.toRadixString(16).substring(2)}",
              output: 'png',
            ),
            builder: (context, snapshot) {
              if (snapshot.hasData)
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.memory(
                    snapshot.data?.data,
                    fit: BoxFit.contain,
                  ),
                );
              return CircularProgressIndicator();
            },
          ),
          Row(
            children: [
              const SizedBox(width: 10.0),
              Text("BR"),
              Expanded(
                child: Slider(
                  label: "$borderRadius",
                  value: borderRadius,
                  min: 0,
                  max: 200,
                  divisions: 10,
                  onChanged: (val) {
                    setState(() {
                      borderRadius = val;
                    });
                  },
                ),
              ),
            ],
          ),
          Row(
            children: [
              const SizedBox(width: 10.0),
              Text("BW"),
              Expanded(
                child: Slider(
                  label: "$borderWidth",
                  value: borderWidth,
                  min: 0,
                  max: 10,
                  divisions: 5,
                  onChanged: (val) {
                    setState(() {
                      borderWidth = val;
                    });
                  },
                ),
              ),
            ],
          ),
          Row(
            children: [
              const SizedBox(width: 10.0),
              Text("OP"),
              Expanded(
                child: Slider(
                  label: "$opacity",
                  value: opacity,
                  min: 0,
                  max: 1,
                  divisions: 5,
                  onChanged: (val) {
                    setState(() {
                      opacity = val;
                    });
                  },
                ),
              ),
            ],
          ),
          Row(
            children: [
              const SizedBox(width: 10.0),
              Text("Border"),
              const SizedBox(width: 10.0),
              Expanded(
                child: FastColorPicker(
                  onColorSelected: (color) {
                    setState(() {
                      borderColor = color;
                    });
                  },
                  selectedColor: borderColor,
                ),
              ),
            ],
          ),
          Row(
            children: [
              const SizedBox(width: 10.0),
              Text("Background"),
              const SizedBox(width: 10.0),
              Expanded(
                child: FastColorPicker(
                  onColorSelected: (color) {
                    setState(() {
                      backgroundColor = color;
                    });
                  },
                  selectedColor: backgroundColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
