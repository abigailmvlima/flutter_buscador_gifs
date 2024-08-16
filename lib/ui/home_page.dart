import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late final String _search = "";
  final int _offset = 0;

  Future<Map> _getGifs() async {
    http.Response response;

    if (_search.isEmpty) {
      response = await http.get(Uri.parse(
          "https://api.giphy.com/v1/gifs/trending?api_key=R7D2pBUVOX8Rff7r4YVwPFWdZSCYjL41&limit=20&offset=75&rating=g&bundle=messaging_non_clips"));
    } else {
      response = await http.get(Uri.parse(
          "https://api.giphy.com/v1/gifs/search?api_key=R7D2pBUVOX8Rff7r4YVwPFWdZSCYjL41&q=$_search&limit=20&offset=$_offset&rating=g&lang=en&bundle=messaging_non_clips"));

    }

    return json.decode(response.body);

    }

  @override
  void initState() {
    super.initState();

    _getGifs().then((map){
      print(map);
    });
  }
  

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
