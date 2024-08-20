import 'dart:convert';

import 'package:buscador_gifs/ui/gif_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:http/http.dart' as http;
import 'package:transparent_image/transparent_image.dart'; // Importação correta

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String _search = "";
  int _offset = 0;
  List<dynamic> _gifs = [];
  bool _isLoadingMore = false;

  Future<void> _getGifs() async {
    final String url = _search.isEmpty
        ? "https://api.giphy.com/v1/gifs/trending?api_key=R7D2pBUVOX8Rff7r4YVwPFWdZSCYjL41&limit=20&offset=$_offset&rating=g&bundle=messaging_non_clips"
        : "https://api.giphy.com/v1/gifs/search?api_key=R7D2pBUVOX8Rff7r4YVwPFWdZSCYjL41&q=$_search&limit=20&offset=$_offset&rating=g&lang=en&bundle=messaging_non_clips";

    final http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        if (_offset == 0) {
          _gifs = data["data"];
        } else {
          _gifs.addAll(data["data"]);
        }
        _isLoadingMore = false;
      });
    } else {
      throw Exception('Failed to load GIFs');
    }
  }

  @override
  void initState() {
    super.initState();
    _getGifs();
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
              onSubmitted: (text) {
                setState(() {
                  _search = text;
                  _offset = 0;
                  _getGifs();
                });
              },
            ),
          ),
          Expanded(
            child: _gifs.isEmpty && !_isLoadingMore
                ? const Center(child: Text('No GIFs found'))
                : GridView.builder(
              padding: const EdgeInsets.all(10.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemCount: _search.isEmpty
                  ? _gifs.length
                  : _gifs.length + 1,
              itemBuilder: (context, index) {
                if (_search.isEmpty || index < _gifs.length) {
                  final String imageUrl = _gifs[index]["images"]["fixed_height"]["url"];
                  return GestureDetector(
                    child: FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage, // Uso correto do placeholder
                      image: imageUrl,
                      height: 300.0,
                      fit: BoxFit.cover,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GifPage(_gifs[index]),
                        ),
                      );
                    },
                    onLongPress: () {
                      FlutterShare.share(title: imageUrl);
                    },
                  );
                } else {
                  if (!_isLoadingMore) {
                    _isLoadingMore = true;
                    _offset += 19; // Ajuste o valor conforme necessário
                    _getGifs();
                  }
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
