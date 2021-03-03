import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {

  ChatMessage(this.data, this.mine);

  final Map<String, dynamic> data;
  final bool mine;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        children: [
          !mine ? //condição que define de quem é a mensagem enviada (se for minha, alinhamento à direto, senão, alinhamento à esquerda
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(data['senderPhotoUrl']),
            ),
          ) : Container(),
          Expanded(
              child: Column(
                crossAxisAlignment: mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  data['image'] != null ?
                      Image.network(data['image'], width: 250,) //definindo o tamanho da imagem
                      :
                      Text(
                        data['text'],
                        textAlign: mine ? TextAlign.end : TextAlign.start,
                        style: TextStyle(
                          fontSize: 16.0
                        ),
                      ),
                  // Text(
                  //   data['senderName'],
                  //   style: TextStyle(
                  //     fontSize: 13.0,
                  //     fontWeight: FontWeight.w500
                  //   ),
                  // )
                ],
              )
          ),
          mine ?
          Padding(
            padding: const EdgeInsets.only(left: 16.0), //alinhando a esquerda
            child: CircleAvatar(
              backgroundImage: NetworkImage(data['senderPhotoUrl']),
            ),
          ) : Container()
        ],
      ),
    );
  }
}
