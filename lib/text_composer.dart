import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TextComposer extends StatefulWidget {

  TextComposer(this.sendMessage);
  final Function({String text, File image}) sendMessage;

  @override
  _TextComposerState createState() => _TextComposerState();
}

class _TextComposerState extends State<TextComposer> {

  final TextEditingController _textController = TextEditingController();
  bool _isComposing = false;

  void _resetFields() {
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          IconButton(
              icon: Icon(Icons.camera_alt_rounded),
              onPressed: () async {
                final File image = await ImagePicker.pickImage(source: ImageSource.camera); //abrindo a câmera ao clicar
                if(image == null) return;
                widget.sendMessage(image: image);
              }
          ),
          Expanded( //campo do texto para ocupar o maior espaço possivel da linha
              child: TextField( //enviar com ok do teclado
                controller: _textController,
                decoration: InputDecoration.collapsed(hintText: "Enviar uma mensagem"),
                onChanged: (text) {
                  setState(() {
                    _isComposing = text.isNotEmpty; //se o texto estiver vazio, não estou escrevendo
                  });
                },
                onSubmitted: (text) {
                  widget.sendMessage(text: text); //pega o texto digitado, joga para a função sendmessage, que joga para o TextComposer
                  _resetFields();
                },
              )
          ),
          IconButton( //botao enviar do widget
            icon: Icon(Icons.send),
            color: Colors.blueAccent,
            onPressed: _isComposing ? () {
              widget.sendMessage(text: _textController.text);
              _resetFields();
            } : null,
          )
        ],
      ),
    );
  }
}
