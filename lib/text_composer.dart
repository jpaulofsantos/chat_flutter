import 'package:flutter/material.dart';

class TextComposer extends StatefulWidget {
  @override
  _TextComposerState createState() => _TextComposerState();
}

bool _isComposing = false;

class _TextComposerState extends State<TextComposer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          IconButton(
              icon: Icon(Icons.camera_alt), color: Colors.blue,
              onPressed: null),
          Expanded( //campo do texto para ocupar o maior espaço possivel da linha
              child: TextField(
                decoration: InputDecoration.collapsed(hintText: "Enviar uma mensagem"),
                onChanged: (text) {
                  setState(() {
                    _isComposing = text.isNotEmpty; //se o texto estiver vazio, não estou escrevendo
                  });
                },
                onSubmitted: (text) {

                },
              )
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _isComposing ? () {

            } : null,
          )
        ],
      ),
    );
  }
}
