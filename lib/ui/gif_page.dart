import 'package:flutter/material.dart';

import 'package:flutter_share/flutter_share.dart';

class GifPage extends StatelessWidget {
  
  final Map _gifData;
  
  const GifPage(this._gifData, {super.key});
  
  @override
  Widget build(BuildContext context) {

    print(_gifData);

    // Remove espaços em branco do título
    final String title = (_gifData["title"] ?? 'GIF').trim();

    return Scaffold(
      appBar: AppBar(
        title: Text(title.isNotEmpty ? title : 'GIF',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(), // Volta para a tela anterior
        ),
        actions: [
          IconButton(onPressed: () {
            FlutterShare.share(title: _gifData["images"]["fixed_height"]["url"]);
          },
              icon: const Icon(Icons.share, color: Colors.white,),
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Image.network(_gifData["images"]["fixed_height"]["url"]),
      ),
    );
  }
}
