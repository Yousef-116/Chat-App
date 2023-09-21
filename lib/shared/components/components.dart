import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
//import 'package:learn_bloc/To_Do_App/Cubit/cubit.dart';
import 'package:learn_bloc/models/MessageModel.dart';

import 'constans.dart';

class ChatMessageSend extends StatelessWidget {
//  ChatMessageSend({super.key, required this.msm, required this.printUsername});
  ChatMessageSend({super.key, required this.msm});

  final Message msm;
  //final printUsername;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          decoration: BoxDecoration(
              //color: Color(0xffe0ecff),
              color: sendMessageColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomLeft: Radius.circular(15))),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  msm.message,
                  style: TextStyle(fontSize: 16, color: TextColor),
                ),
                Row(
                  children: [
                    Text(
                      DateFormat('h:mm a').format(msm.Time.toDate()).toString(),
                      // DateFormat('MMM d, EEE h:mm a')
                      //     .format(msm.Time.toDate())
                      //     .toString(),
                      style: TextStyle(color: Color(0xff929396), fontSize: 11),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    msm.isRead
                        ? Icon(
                            Icons.fiber_smart_record_rounded,
                            color: Colors.blue.shade300,
                            size: 9,
                          )
                        : Icon(
                            Icons.circle,
                            color: Colors.grey.shade300,
                            size: 9,
                          ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ChatMessageReceive extends StatelessWidget {
  const ChatMessageReceive(
      {super.key, required this.msm, required this.printUsername});
  final Message msm;
  final bool printUsername;

  @override
  Widget build(BuildContext context) {
    if (msm.isRead == false) {
      final messageRef =
          FirebaseFirestore.instance.collection('Message').doc(msm.id);
      messageRef.update({
        'isRead': true,
      }).then((value) {
        print('Message marked as read successfully');
      }).catchError((error) {
        print('Failed to mark message as read: $error');
      });
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
              // color: Colors.white,
              color: ReceiveMessageColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1), // shadow color
                  spreadRadius: 1, // spread radius
                  blurRadius: 7, // blur radius
                  offset: Offset(1, 0), // changes position of shadow
                ),
              ],
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomRight: Radius.circular(15))),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                printUsername
                    ? (Text(
                        msm.SenderName,
                        style: TextStyle(fontSize: 12, color: Colors.green),
                      ))
                    : SizedBox(
                        height: 0,
                      ),
                Text(
                  msm.message,
                  style: TextStyle(fontSize: 16, color: TextColor),
                ),
                Text(
                  DateFormat('h:mm a').format(msm.Time.toDate()).toString(),
                  // DateFormat('MMM d, EEE h:mm a')
                  //     .format(msm.Time.toDate())
                  //     .toString(),

                  style: TextStyle(color: Color(0xff929396), fontSize: 11),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
//============================================================

//============================================================

class SelectUsers extends StatefulWidget {
  SelectUsers({super.key, required this.user, required this.list});
  var user;
  Map<String, String> list;
  @override
  State<SelectUsers> createState() => _SelectUsersState();
}

class _SelectUsersState extends State<SelectUsers> {
  bool select = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(widget.user["UserName"]),
        Container(
          height: 25,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: select
                    ? Colors.blue
                    : Colors.grey, // Set your desired border color here
                width: 2.0,
              )),
          child: MaterialButton(
            height: 25,
            onPressed: () {
              if (select) {
                widget.list.remove(widget.user["email"]);
              } else {
                widget.list[widget.user["email"]] = widget.user["UserName"];
              }

              select = !select;
              // widget.list.forEach((key, value) {
              //   print('$key: $value');
              // });
              setState(() {});
            },
            child: select
                ? Text(
                    "Unselected",
                    style: TextStyle(color: Colors.blue),
                  )
                : Text(
                    "Select",
                    style: TextStyle(color: Colors.grey),
                  ),
            //  focusColor: Colors.blue,
          ),
        )
      ],
    );
  }
}

class ChatContact extends StatelessWidget {
  ChatContact({super.key, required this.user});
  var user;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        List<String> emails = [
          user["email"],
          FirebaseAuth.instance.currentUser!.email.toString()
        ];
        emails.sort();

        code = emails[0] + emails[1];

        chatUser = user["UserName"];

        Navigator.pushNamed(context, "ChatPage");
      },
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 8),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey.shade300,
              child: Text(
                "${user["UserName"][0]}",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
              radius: 35,
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user["UserName"],
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: TextColor),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Hello My friend",
                    style: TextStyle(color: Colors.grey.shade600),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

//============================================================
class GroupContact extends StatelessWidget {
  GroupContact({
    super.key,
    required this.groupDocuments,
  });

  final DocumentSnapshot<Object?> groupDocuments;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        code = groupDocuments.id.toString();
        chatUser = groupDocuments["GroupName"];

        Navigator.pushNamed(context, "ChatPage");
      },
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey.shade300,
            child: Text(
              "${groupDocuments["GroupName"][0]}",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            ),
            radius: 35,
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  groupDocuments["GroupName"],
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: TextColor),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Hello My friend",
                  style: TextStyle(color: Colors.grey.shade600),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
