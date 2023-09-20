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
  bool bottomSheet = false;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  Map<String, String> userList = {};
  var groupNameController = TextEditingController();
  var groupFormKey = GlobalKey<FormState>();
  var username;
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
        List<DocumentSnapshot> groupDocuments = [];
        // Handle changes in "Groups" collection
        for (int i = 0; i < groupsSnapshot.data!.docs.length; i++) {
          String? currentUserEmail = FirebaseAuth.instance.currentUser?.email;
          Map<String, dynamic> usersMap = groupsSnapshot.data!.docs[i]['Users'];
          if (usersMap.containsKey(currentUserEmail)) {
            print(
                "User found in group: $currentUserEmail ========================================================================");
            groupDocuments.add(groupsSnapshot.data!.docs[i]);
          } else {
            print(
                "user Not found ========================================================================");
          }
        }

        //List<DocumentSnapshot> groupDocuments = groupsSnapshot.data!.docs;

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
                key: scaffoldKey,
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
                                        else {
                                          username =
                                              userDocuments[index]["UserName"];
                                          return Container();
                                        }
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
                                    shrinkWrap: true,
                                    //  physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      // Group Contact Widget Cont...............
                                      return Padding(
                                        padding: const EdgeInsetsDirectional
                                            .symmetric(horizontal: 15.0),
                                        child: Row(
                                          children: [
                                            CircleAvatar(),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(groupDocuments[index]
                                                ["GroupName"])
                                          ],
                                        ),
                                      );
                                    },
                                    separatorBuilder: (context, index) =>
                                        SizedBox(
                                      height: 10,
                                    ),
                                    itemCount: groupDocuments.length,
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
                floatingActionButton: !Person
                    ? FloatingActionButton(
                        onPressed: () async {
                          // Map<String, String> userList = {};
                          if (bottomSheet) {
                            if (groupFormKey.currentState!.validate()) {
                              userList[FirebaseAuth.instance.currentUser!.email
                                  .toString()] = username.toString();

                              groups.add({
                                "GroupName": groupNameController.text,
                                "Users": userList
                              });

                              userList.forEach((key, value) {
                                print('$key: $value');

                                //groups.doc("Users").update({});
                              });
                              groupNameController.clear();
                              Navigator.pop(context);
                              bottomSheet = false;
                              userList = {};
                            }
                          } else {
                            scaffoldKey.currentState
                                ?.showBottomSheet(elevation: 20, (context) {
                                  return Container(
                                    width: double.infinity,
                                    color: Colors.white,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Form(
                                            key: groupFormKey,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                              child: TextFormField(
                                                controller: groupNameController,
                                                keyboardType:
                                                    TextInputType.text,
                                                validator: (value) {
                                                  if (value!.isEmpty)
                                                    return "Enter Group Name";
                                                  else
                                                    return null;
                                                },
                                                style: const TextStyle(
                                                    fontSize: 15),
                                                decoration: InputDecoration(
                                                    labelText: "Group Name",
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        borderSide:
                                                            const BorderSide(
                                                                color: Colors
                                                                    .blue)),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                              color:
                                                                  Colors.blue,
                                                              width: 2),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    )),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 35.0,
                                                left: 20,
                                                right: 20,
                                                bottom: 50),
                                            child: ListView.separated(
                                                shrinkWrap: true,
                                                scrollDirection: Axis.vertical,
                                                itemBuilder: (context, index) {
                                                  if (userDocuments[index]
                                                          ["email"] !=
                                                      FirebaseAuth.instance
                                                          .currentUser!.email)
                                                    return SelectUsers(
                                                      user:
                                                          userDocuments[index],
                                                      list: userList,
                                                    );
                                                  else
                                                    return Container();
                                                },
                                                separatorBuilder:
                                                    (context, index) {
                                                  if (userDocuments[index]
                                                          ["email"] !=
                                                      FirebaseAuth.instance
                                                          .currentUser!.email)
                                                    return SizedBox(
                                                      height: 10,
                                                    );
                                                  else
                                                    return SizedBox();
                                                },
                                                itemCount:
                                                    userDocuments.length),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                })
                                .closed
                                .then((value) {
                                  bottomSheet = false;
                                  groupNameController.clear();
                                  return;
                                });
                            bottomSheet = true;
                          }
                        },
                        //backgroundColor: Colors.white,
                        child: bottomSheet
                            ? Icon(
                                Icons.add,
                                // color: Colors.grey,
                              )
                            : Icon(
                                Icons.add,
                                //color: Colors.grey,
                                shadows: [
                                  Shadow(color: Colors.white, blurRadius: 0)
                                ],
                              ),
                      )
                    : Container());
          },
        );
      },
    );
  }
}
