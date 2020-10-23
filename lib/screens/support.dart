import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:imes/blocs/user_notifier.dart';

import 'package:bubble/bubble.dart';

import 'package:provider/provider.dart';

class SupportPage extends StatefulWidget {
  @override
  _SupportPageState createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<UserNotifier>(builder: (context, userNotifier, _) {
      return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: <Widget>[
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('sessions')
                      .doc('${userNotifier.user.username}')
                      .collection('messages')
                      .orderBy('time', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    return ListView.builder(
                        reverse: true,
                        controller: _scrollController,
                        itemCount: snapshot.data?.docs?.length ?? 1,
                        itemBuilder: (context, index) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }

//                          if (snapshot.data?.documents?.isEmpty ?? true) {
//                            return Center(
//                              child: Text('Повідомлення відсутні'),
//                            );
//                          }

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Bubble(
                              style: BubbleStyle(
                                  nip: snapshot.data?.docs[index]?.data()['fromUser'] ?? false
                                      ? BubbleNip.rightTop
                                      : BubbleNip.leftTop,
                                  alignment: snapshot.data?.docs[index]?.data()['fromUser'] ?? false
                                      ? Alignment.topRight
                                      : Alignment.topLeft,
                                  color: snapshot.data?.docs[index]?.data()['fromUser'] ?? false
                                      ? Color(0xFF10DE50)
                                      : Color(0xFFE5E6EA)),
                              child: Text(
                                snapshot.data?.docs[index]?.data()['content'] ?? '',
                                style: TextStyle(
                                    color: snapshot.data?.docs[index]?.data()['fromUser'] ?? false
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ),
                          );
                        });
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFFC8C7CC)),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Row(
                  children: <Widget>[
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: TextField(
                        controller: _textEditingController,
                        decoration:
                            InputDecoration.collapsed(border: InputBorder.none, hintText: 'Введіть ваше повідомлення'),
                      ),
                    ),
                    InkWell(
                      child: Container(
                        padding: const EdgeInsets.all(4.0),
                        decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF8A8A8F)),
                        child: const Icon(Icons.send, size: 13, color: Colors.white),
                      ),
                      onTap: () async {
                        if (_textEditingController.text.trim().isNotEmpty) {
                          final sessionDocumentRef =
                              FirebaseFirestore.instance.collection('sessions').doc('${userNotifier.user.username}');
                          final docSnapshot = await sessionDocumentRef.get();
                          if (!docSnapshot.exists) {
                            await sessionDocumentRef.set({'unreadCount': 1});
                          } else {
                            var unreadCount = docSnapshot.data()['unreadCount'];
                            unreadCount++;
                            sessionDocumentRef.update({'unreadCount': unreadCount});
                          }

                          final documentRef = sessionDocumentRef
                              .collection('messages')
                              .doc(DateTime.now().millisecondsSinceEpoch.toString());

                          final result = await FirebaseFirestore.instance.runTransaction((tx) async {
                            await tx.set(documentRef, {
                              'content': _textEditingController.text,
                              'fromUser': true,
                              'isRead': false,
                              'time': DateTime.now().millisecondsSinceEpoch.toString(),
                            });
                          });

                          _scrollController.animateTo(0.0,
                              duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                          _textEditingController.clear();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
