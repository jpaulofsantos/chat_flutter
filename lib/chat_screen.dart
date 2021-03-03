import 'dart:io';
import 'dart:io';
import 'package:chat_flutter/text_composer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'chat_message.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    FirebaseUser _currentUser;
    bool _isLoading;


    @override
  void initState() {
      super.initState();

      FirebaseAuth.instance.onAuthStateChanged.listen((user) { //quando usuário logar, joga para _currentUser
        setState(() { //inserindo currentuser no setState para
          _currentUser = user;
        });
      });
//
  }

  Future<FirebaseUser> _getUser() async {

      if(_currentUser != null) return _currentUser;

    try {

      final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn(); //faz o Login com o Google

      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication; //colocou os dados de auth do googleSignInAccount no objeto googleSignInAuthentication

      final AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken); // pegando as credenciais para fazer o login no Firebase

      final AuthResult authResult = await FirebaseAuth.instance.signInWithCredential(credential); //passando credential para authResult (funciona para Google, LinkeIn, Facebook, etc), mudando somente o Provider

      final FirebaseUser user = authResult.user;

      return user;

    } catch (error) {
      return null;
    }
  }



  void _sendMessage({String text, File image}) async { //add msg de texto no Firebase

    final FirebaseUser user = await _getUser();

    if (user == null) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Não foi possível fazer o login. Tente novamente!"),
        backgroundColor: Colors.red,
      ));
    }

    Map<String, dynamic> data = { //add user info no map
      "uid": user.uid,
      "senderName": user.displayName,
      "senderPhotoUrl": user.photoUrl,
      "time": Timestamp.now() //add time para ordenar as mensagem pelo tempo
    };

    if(image != null) { // inserindo imagem no firebase
      StorageUploadTask task = FirebaseStorage.instance.ref().child( // no child, cria-se o nome/pasta para os arquivos e passa o arquivo
        DateTime.now().millisecondsSinceEpoch.toString()).putFile(image);

      setState(() { //carregando a imagem
        _isLoading = true;
      });

      StorageTaskSnapshot snap = await task.onComplete; //fornecer operações com a task concluida acima
      String url = await snap.ref.getDownloadURL();
      data['image'] = url; //add url no map
      print(url);
    }

    setState(() { //imagem carregada
      _isLoading = false;
    });

    if (text != null) data['text'] = text; //add text no mapa

    Firestore.instance.collection('messages').add(data); //passando o map data para o Firebase
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          _currentUser != null ? 'Olá, ${_currentUser.displayName}' : 'Chat App'
        ),
        elevation: 0,
        actions: [
          _currentUser != null ? IconButton( //criando botão para logout
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                FirebaseAuth.instance.signOut(); //logout do Firebase
                googleSignIn.signOut(); //logout Google
                _scaffoldKey.currentState.showSnackBar(SnackBar(
                  content: Text("Logout realizado com sucesso!"),
                ));
              }) : Container()
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: StreamBuilder<QuerySnapshot>( //sempre que algo mudar na coleção, recria a lista
                stream: Firestore.instance.collection("messages").orderBy('time').snapshots(), //ordenando pelo time das msg
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
                          return ChatMessage(docs[index].data, true);

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
