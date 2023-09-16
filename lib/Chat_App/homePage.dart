import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../shared/components/components.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');

    return FutureBuilder<QuerySnapshot>(
        future: users.get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            snapshot.data?.docs[0];
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
                        "Chats",
                      ),
                    ],
                  ),
                ),
                body: Container(
                  color: Color(0xff158fd3),
                  child: Container(
                    padding: EdgeInsets.only(top: 15, left: 15, right: 15),
                    decoration: BoxDecoration(
                        color: Color(0xFFFAFAFA),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50),
                        )),
                    child: ListView.separated(
                        itemBuilder: (context, index) => ChatContact(
                              user: snapshot.data?.docs[index],
                            ),
                        separatorBuilder: (context, index) => SizedBox(
                              height: 10,
                            ),
                        itemCount: snapshot.data!.docs.length),
                  ),
                ),
              ),
            );
          } else {
            return ModalProgressHUD(inAsyncCall: true, child: Container());
          }
        });
  }
}
