import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_linkify/flutter_linkify.dart';

import 'package:imes/blocs/user_notifier.dart';

import 'package:bubble/bubble.dart';
import 'package:imes/widgets/support/support_app_bar.dart';

import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:validators/sanitizers.dart';

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
        appBar: SupportAppBar(),
        body: Column(
          children: <Widget>[
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('sessions')
                      .doc('${userNotifier.user.id}')
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
                          return Center(child: CircularProgressIndicator());
                        }

                        // if (snapshot.data?.docs?.isEmpty ?? true) {
                        //   return Center(
                        //     child: Text('Повідомлення відсутні'),
                        //   );
                        // }
                        //

                        final isFromUser = snapshot.data?.docs[index]?.data()['fromUser'] ?? false;
                        final content = trim(snapshot.data?.docs[index]?.data()['content'] ?? '');

                        if (content != null && content.isNotEmpty) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Bubble(
                              style: BubbleStyle(
                                nip: isFromUser ? BubbleNip.rightTop : BubbleNip.leftTop,
                                alignment: isFromUser ? Alignment.topRight : Alignment.topLeft,
                                color: isFromUser
                                    ? Color(0xFF00B7FF) // TODO: extract colors to theme
                                    : Color(0xFFE5E6EA), // TODO: extract colors to theme
                              ),
                              child: SelectableLinkify(
                                text: content,
                                onOpen: (link) async {
                                  if (await canLaunch(link.url)) {
                                    await launch(link.url);
                                  }
                                },
                                linkStyle: TextStyle(
                                  color: isFromUser ? Colors.white : Colors.black,
                                  decoration: TextDecoration.underline,
                                ),
                                style: TextStyle(
                                  color: isFromUser ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                          );
                        }
                        return SizedBox();
                      },
                    );
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).dividerColor),
                  borderRadius: BorderRadius.circular(8.0),
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
                      onTap: () async {
                        if (_textEditingController.text.trim().isNotEmpty) {
                          final sessionDocumentRef =
                              FirebaseFirestore.instance.collection('sessions').doc('${userNotifier.user.id}');
                          final docSnapshot = await sessionDocumentRef.get();
                          if (!docSnapshot.exists) {
                            await sessionDocumentRef.set({'unreadCount': 1});
                          } else {
                            var unreadCount = docSnapshot.data()['unreadCount'] + 1;
                            sessionDocumentRef.update({'unreadCount': unreadCount});
                          }

                          final documentRef = sessionDocumentRef
                              .collection('messages')
                              .doc(DateTime.now().millisecondsSinceEpoch.toString());

                          final result = await FirebaseFirestore.instance.runTransaction((tx) async {
                            tx.set(documentRef, {
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
                      child: InkResponse(
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0xFF00B7FF)),
                          child: const Icon(Icons.send, size: 13.0, color: Colors.white),
                        ),
                      ),
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
