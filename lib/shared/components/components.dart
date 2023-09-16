import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
//import 'package:learn_bloc/To_Do_App/Cubit/cubit.dart';
import 'package:learn_bloc/models/MessageModel.dart';

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
              color: Color(0xffe0ecff),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomLeft: Radius.circular(15))),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // printUsername
                //     ? (Text(
                //         msm.SenderEmail,
                //         style: TextStyle(fontSize: 12, color: Colors.blue),
                //       ))
                //     : SizedBox(
                //         height: 0,
                //       ),
                Text(
                  msm.message,
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  DateFormat('h:mm a').format(msm.Time.toDate()).toString(),
                  // DateFormat('MMM d, EEE h:mm a')
                  //     .format(msm.Time.toDate())
                  //     .toString(),
                  style: TextStyle(color: Color(0xff929396), fontSize: 11),
                )
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
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
                  bottomLeft: Radius.circular(15))),
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
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  DateFormat('h:mm a').format(msm.Time.toDate()).toString(),
                  // DateFormat('MMM d, EEE h:mm a')
                  //     .format(msm.Time.toDate())
                  //     .toString(),

                  style: TextStyle(color: Color(0xff929396), fontSize: 11),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
