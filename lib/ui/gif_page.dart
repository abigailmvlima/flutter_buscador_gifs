import 'package:flutter/material.dart';

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
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Image.network(_gifData["images"]["fixed_height"]["url"]),
      ),
    );
  }
}
