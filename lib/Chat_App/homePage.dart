import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learn_bloc/shared/components/constans.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../shared/components/components.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool Person = true;

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    CollectionReference groups =
        FirebaseFirestore.instance.collection('Groups');
    return StreamBuilder<QuerySnapshot>(
      stream: groups
          .snapshots(), // Listen for real-time updates on "Groups" collection
      builder: (context, groupsSnapshot) {
        if (groupsSnapshot.connectionState == ConnectionState.waiting) {
          // return CircularProgressIndicator(); // Show a loading indicator while waiting for initial data
          return ModalProgressHUD(inAsyncCall: true, child: Container());
        }

        // Handle changes in "Groups" collection
        List<DocumentSnapshot> groupDocuments = groupsSnapshot.data!.docs;
        // Process and use the groupDocuments as needed

        return StreamBuilder<QuerySnapshot>(
          stream: users
              .snapshots(), // Listen for real-time updates on "Users" collection
          builder: (context, usersSnapshot) {
            if (usersSnapshot.connectionState == ConnectionState.waiting) {
              return ModalProgressHUD(
                  inAsyncCall: true,
                  child:
                      Container()); // Show a loading indicator while waiting for initial data
            }

            // Handle changes in "Users" collection
            List<DocumentSnapshot> userDocuments = usersSnapshot.data!.docs;
            // Process and use the userDocuments as needed

            // Build your UI using the combined data from "Groups" and "Users" collections
            return Scaffold(
              appBar: AppBar(
                toolbarHeight: 100,
                elevation: 0,
//                backgroundColor: const Color(0xff158fd3),
                backgroundColor: primeColor,

                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Image.asset('images/ChatAppLogo.png',
                    //    height: 70, width: 70, fit: BoxFit.fitHeight),
                    Image.network("https://i.imgur.com/GvODQ4X.png",
                        height: 70, width: 70, fit: BoxFit.fitHeight)
                  ],
                ),
                actions: [
                  Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: IconButton(
                          onPressed: () {
                            setState(() {
                              if (Mode)
                                darkMode();
                              else
                                lightMode();

                              Mode = !Mode;
                            });
                          },
                          icon: Mode
                              ? Icon(Icons.nightlight_round_sharp)
                              : Icon(Icons.sunny)))
                ],
              ),
              body: Container(
                //color: Color(0xff158fd3),
                color: primeColor,
                child: Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  padding: EdgeInsets.only(
                      //top: 15,
                      //  left: 15,
                      //    right: 15
                      ),
                  decoration: BoxDecoration(
                      //color: Color(0xFFFAFAFA),
                      color: backgroundColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      )),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: MaterialButton(
                              onPressed: () {
                                setState(() {
                                  Person = true;
                                });
                              },
                              child: Icon(
                                Icons.person,
                                color: Person ? Colors.blue : Colors.grey,
                              ),
                              height: 45,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                            ),
                          ),
                          Expanded(
                            child: MaterialButton(
                              onPressed: () {
                                setState(() {
                                  Person = false;
                                });
                              },
                              child: Icon(
                                Icons.groups,
                                color: !Person ? Colors.blue : Colors.grey,
                              ),
                              height: 45,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Person
                          ? Expanded(
                              child: Container(
                                child: ListView.separated(
                                    itemBuilder: (context, index) {
                                      if (userDocuments[index]["email"] !=
                                          FirebaseAuth
                                              .instance.currentUser!.email)
                                        return ChatContact(
                                          user: userDocuments[index],
                                        );
                                      else
                                        return Container();
                                    },
                                    separatorBuilder: (context, index) =>
                                        SizedBox(
                                          height: 10,
                                        ),
                                    itemCount: userDocuments.length),
                              ),
                            )
                          : Expanded(
                              child: Container(
                                child: ListView.separated(
                                    itemBuilder: (context, index) {
                                      return Container();
                                    },
                                    separatorBuilder: (context, index) =>
                                        SizedBox(
                                          height: 10,
                                        ),
                                    itemCount: 1),
                              ),
                            )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    // return FutureBuilder<QuerySnapshot>(
    //     future: users.get(),
    //     builder: (context, snapshot) {
    //       if (snapshot.hasData) {
    //         snapshot.data?.docs[0];
    //         return ModalProgressHUD(
    //           inAsyncCall: snapshot.hasData ? false : true,
    //           child: Scaffold(
    //             appBar: AppBar(
    //               toolbarHeight: 100,
    //               elevation: 0,
    //               backgroundColor: const Color(0xff158fd3),
    //               title: Row(
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 children: [
    //                   // Image.asset('images/ChatAppLogo.png',
    //                   //    height: 70, width: 70, fit: BoxFit.fitHeight),
    //                   Image.network("https://i.imgur.com/GvODQ4X.png",
    //                       height: 70, width: 70, fit: BoxFit.fitHeight)
    //                 ],
    //               ),
    //               actions: [
    //                 IconButton(onPressed: () {}, icon: Icon(Icons.sunny))
    //               ],
    //             ),
    //             body: Container(
    //               color: Color(0xff158fd3),
    //               child: Container(
    //                 clipBehavior: Clip.antiAliasWithSaveLayer,
    //                 padding: EdgeInsets.only(
    //                     //top: 15,
    //                     //  left: 15,
    //                     //    right: 15
    //                     ),
    //                 decoration: BoxDecoration(
    //                     color: Color(0xFFFAFAFA),
    //                     borderRadius: BorderRadius.only(
    //                       topLeft: Radius.circular(50),
    //                       topRight: Radius.circular(50),
    //                     )),
    //                 child: Column(
    //                   children: [
    //                     Row(
    //                       children: [
    //                         Expanded(
    //                           child: MaterialButton(
    //                             onPressed: () {
    //                               setState(() {
    //                                 Person = true;
    //                               });
    //                             },
    //                             child: Icon(
    //                               Icons.person,
    //                               color: Person ? Colors.blue : Colors.grey,
    //                             ),
    //                             height: 45,
    //                             clipBehavior: Clip.antiAliasWithSaveLayer,
    //                           ),
    //                         ),
    //                         Expanded(
    //                           child: MaterialButton(
    //                             onPressed: () {
    //                               setState(() {
    //                                 Person = false;
    //                               });
    //                             },
    //                             child: Icon(
    //                               Icons.groups,
    //                               color: !Person ? Colors.blue : Colors.grey,
    //                             ),
    //                             height: 45,
    //                             clipBehavior: Clip.antiAliasWithSaveLayer,
    //                           ),
    //                         ),
    //                       ],
    //                     ),
    //                     SizedBox(
    //                       height: 5,
    //                     ),
    //                     Expanded(
    //                       child: Container(
    //                         child: ListView.separated(
    //                             itemBuilder: (context, index) {
    //                               if (snapshot.data?.docs[index]["email"] !=
    //                                   FirebaseAuth.instance.currentUser!.email)
    //                                 return ChatContact(
    //                                   user: snapshot.data?.docs[index],
    //                                 );
    //                               else
    //                                 return Container();
    //                             },
    //                             separatorBuilder: (context, index) => SizedBox(
    //                                   height: 10,
    //                                 ),
    //                             itemCount: snapshot.data!.docs.length),
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ),
    //           ),
    //         );
    //       } else {
    //         return ModalProgressHUD(inAsyncCall: true, child: Container());
    //       }
    //     });
  }
}
