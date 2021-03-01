import 'package:chat_flutter/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '';

void main() async{

  runApp(Home());

  // Firestore.instance.collection("mensagens").document().setData({"texto": "Tudo bem?", "from": "JP2", "read": true }); //escrevendo no banco de dados, pode ser feito coleção/documento/colecao/documento, de acordo com o necessário
  //
  // QuerySnapshot snapshot = await Firestore.instance.collection('mensagens').getDocuments(); //lendo os registros do banco
  // snapshot.documents.forEach((element) {
  //   print(element.data);
  // });
  //
  // snapshot.documents.forEach((element) {
  //   element.reference.updateData({"read": false}); //alterando "read" para todos os registros
  // });
  //
  // DocumentSnapshot snapshot1 = await Firestore.instance.collection('mensagens').document("IIhmnSQLovMtc8U2wBt7").get(); //lendo um id no banco
  // print(snapshot1.data);
  //
  // Firestore.instance.collection('mensagens').snapshots().listen((dado) { //chama a função quando houver alterações na coleção
  //   dado.documents.forEach((element) {
  //     print(element.data);
  //   });
  // });
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Chat Flutter",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          iconTheme: IconThemeData(
              color: Colors.blue
          )
      ),
      home: ChatScreen(),
    );
  }
}
