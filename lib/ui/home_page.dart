import 'dart:convert';

import 'package:buscador_gifs/ui/gif_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String _search = "";
  final int _offset = 0;

  Future<Map<String, dynamic>> _getGifs() async {
    final String url = _search.isEmpty
        ? "https://api.giphy.com/v1/gifs/trending?api_key=R7D2pBUVOX8Rff7r4YVwPFWdZSCYjL41&limit=20&offset=75&rating=g&bundle=messaging_non_clips"
        : "https://api.giphy.com/v1/gifs/search?api_key=R7D2pBUVOX8Rff7r4YVwPFWdZSCYjL41&q=$_search&limit=20&offset=$_offset&rating=g&lang=en&bundle=messaging_non_clips";

    final http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load GIFs');
    }
  }

  @override
  void initState() {
    super.initState();

    _getGifs().then((map) {
      print(map);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network(
            "https://developers.giphy.com/branch/master/static/header-logo-0fec0225d189bc0eae27dac3e3770582.gif"),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: "Pesquise Aqui",
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(color: Colors.white, fontSize: 18.0),
              textAlign: TextAlign.center,
              onSubmitted: (text){
               setState(() {
                 _search = text;
               });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<Map<String, dynamic>>(
              future: _getGifs(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return const Center(
                      child: SizedBox(
                        width: 200.0,
                        height: 200.0,
                        child: CircularProgressIndicator(
                          valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 5.0,
                        ),
                      ),
                    );
                  default:
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      return _createGifTable(context, snapshot.data);
                    }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _createGifTable(BuildContext context, Map<String, dynamic>? data) {
    if (data == null || data["data"] == null) {
      return const Center(child: Text('No GIFs found'));
    }

    final List<dynamic> gifs = data["data"];

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Número de colunas
        crossAxisSpacing: 10.0, // Espaçamento horizontal
        mainAxisSpacing: 10.0, // Espaçamento vertical
      ),
      itemCount: gifs.length,
      itemBuilder: (context, index) {
        final String imageUrl = gifs[index]["images"]["fixed_height"]["url"];
        return GestureDetector(
          child: Image.network(
            imageUrl,
            height: 300.0,
            fit: BoxFit.cover,
          ),
          onTap: () {
            Navigator.push(context,
              MaterialPageRoute(builder: (context) => GifPage(gifs[index]),
            ),
            );
          },
          onLongPress: () {
            FlutterShare.share(title: gifs[index]["images"]["fixed_height"]["url"]);
          },
        );
      },
    );
  }
}
