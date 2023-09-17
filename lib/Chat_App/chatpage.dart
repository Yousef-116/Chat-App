// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:learn_bloc/shared/components/constans.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../models/MessageModel.dart';
import '../shared/components/components.dart';

// ignore: must_be_immutable
class ChatPage extends StatelessWidget {
  ChatPage({super.key});
  //========================
  final FocusNode textFormFieldFocusNode = FocusNode();
  final ScrollController scrollController = ScrollController();
  var printUser = true;
  var messageController = TextEditingController();
  bool messageType = false;
  //========================
  CollectionReference Messages =
      FirebaseFirestore.instance.collection('Message');
  CollectionReference Users = FirebaseFirestore.instance.collection('Users');
  //========================
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Messages.orderBy("Time", descending: true).snapshots(),
        builder: (context, snapshot) {
          List<Message> messagesList = [];
          if (snapshot.hasData)
            for (int i = 0; i < snapshot.data!.docs.length; i++) {
              dynamic sms = snapshot.data!.docs[i];
              try {
                if (sms["code"].toString() == code.toString()) {
                  messagesList.add(Message.fromJson(snapshot.data!.docs[i]));
                }
              } catch (e) {
                print("error in chat page : ${e.toString()}");
              }
            }

          return ModalProgressHUD(
            inAsyncCall: snapshot.hasData ? false : true,
            child: Scaffold(
              appBar: AppBar(
                toolbarHeight: 100,
                elevation: 0,
                backgroundColor: const Color(0xff158fd3),
                title: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Chat App",
                    ),
                  ],
                ),
              ),
              body: Container(
                color: const Color(0xff158fd3),
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Color(0xfffafafa),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(50),
                              topRight: Radius.circular(50),
                            )),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              //top: 10,
                              left: 20,
                              right: 20,
                              bottom: 5),
                          child: ListView.separated(
                              reverse: true,
                              controller: scrollController,
                              itemBuilder: (context, index) {
                                if (index < messagesList.length - 1) {
                                  if (messagesList[index].SenderEmail !=
                                      messagesList[index + 1].SenderEmail)
                                    printUser = true;
                                  else
                                    printUser = false;
                                }
                                return messagesList[index].SenderEmail !=
                                        FirebaseAuth.instance.currentUser?.email
                                    ? ChatMessageReceive(
                                        msm: messagesList[index],
                                        printUsername: printUser,
                                      )
                                    : ChatMessageSend(
                                        msm: messagesList[index],
                                      );
                              },
                              separatorBuilder: (context, index) {
                                if (DateFormat.yMd()
                                        .format(
                                            messagesList[index].Time.toDate())
                                        .toString() !=
                                    DateFormat.yMd()
                                        .format(messagesList[index + 1]
                                            .Time
                                            .toDate())
                                        .toString()) {
                                  return Center(
                                    child: Container(
                                      // color: Colors.deepOrange,
                                      child: Text(DateFormat.yMd()
                                          .format(
                                              messagesList[index].Time.toDate())
                                          .toString()),
                                    ),
                                  );
                                } else if (!printUser) {
                                  return SizedBox(
                                    height: 2,
                                  );
                                } else {
                                  return SizedBox(
                                    height: 20,
                                  );
                                }
                              },
                              itemCount: messagesList.length),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5), // shadow color
                            spreadRadius: 5, // spread radius
                            blurRadius: 7, // blur radius
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      padding: const EdgeInsetsDirectional.all(20),
                      child: TextFormField(
                        focusNode: textFormFieldFocusNode,
                        //textDirection: TextDirection.LTR,
                        //textAlign: TextAlign.end,
                        onFieldSubmitted: (data) {
                          Send();
                        },
                        controller: messageController,
                        keyboardType: TextInputType.text,
                        style: const TextStyle(fontSize: 15),
                        decoration: InputDecoration(
                            suffixIcon: GestureDetector(
                                onTap: Send, child: const Icon(Icons.send)),
                            hintText: "Start typing",
                            filled: true,
                            fillColor: Colors.grey.shade200,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                    color: Colors.grey.shade200, width: 0)),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey.shade200, width: 0),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade200),
                              borderRadius: BorderRadius.circular(20),
                            )),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  void Send() {
    String text = messageController.text;
    messageController.clear();
    textFormFieldFocusNode.requestFocus();
    var username;
    print(
        "Email From Auth: ${FirebaseAuth.instance.currentUser?.email.toString()}");
    if (text != "") {
      FirebaseFirestore.instance
          .collection("Users")
          .where("email",
              isEqualTo: FirebaseAuth.instance.currentUser?.email.toString())
          .get()
          .then((QuerySnapshot<Map<String, dynamic>> snapshot) async {
        if (snapshot.size == 1) {
          username = await snapshot.docs[0].data()["UserName"];
          print("Username: $username");
        } else {
          print("User not found.");
          print(username.toString());
        }
      }).catchError((error) {
        print("Error getting username: $error");
      }).then((value) {
        Messages.add({
          "message": text,
          "SenderEmail": FirebaseAuth.instance.currentUser?.email,
          "SenderName": username.toString(),
          "Time": DateTime.now(),
          "code": code
        }).then((value) {
          messageController.clear();
          scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        });
      });
    }
  }
}
