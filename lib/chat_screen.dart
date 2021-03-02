import 'dart:io';

import 'package:chat_flutter/text_composer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {



  void _sendMessage({String text, File image}) async { //add msg de texto no Firebase

    Map<String, dynamic> data = Map();

    if(image != null) { // inserindo imagem no firebase
      StorageUploadTask task = FirebaseStorage.instance.ref().child( // no child, cria-se o nome/pasta para os arquivos e passa o arquivo
        DateTime.now().millisecondsSinceEpoch.toString()).putFile(image);

      StorageTaskSnapshot snap = await task.onComplete; //fornecer operações com a task concluida acima
      String url = await snap.ref.getDownloadURL();
      data['image'] = url; //add url no map
      print(url);
    }

    if (text != null) data['text'] = text; //add text no mapa

    Firestore.instance.collection('messages').add(data); //passando o map data para o Firebase
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Olá"),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
              child: StreamBuilder<QuerySnapshot>( //sempre que algo mudar na coleção, recria a lista
                stream: Firestore.instance.collection("messages").snapshots(),
                builder: (context, snapshot) {
                  switch(snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    default:
                      List<DocumentSnapshot> docs = snapshot.data.documents.reversed.toList(); // ordenando a lista de mensagens que aparecem no chat

                      return ListView.builder(
                        itemCount: docs.length,
                          reverse: true,
                          itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                              docs[index].data['text']
                            ),
                          );

                          }
                      );
                  }
                },
              )
          ),
          TextComposer((_sendMessage)

        ),
        ],
      ),
    );
  }
}
