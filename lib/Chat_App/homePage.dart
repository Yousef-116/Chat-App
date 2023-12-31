import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learn_bloc/shared/components/constans.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../shared/components/components.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ignore: non_constant_identifier_names
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
    //  CollectionReference messages =
    //    FirebaseFirestore.instance.collection('Message');

    // groups =================================================================

    return StreamBuilder<QuerySnapshot>(
      stream: groups.snapshots(),
      builder: (context, groupsSnapshot) {
        if (groupsSnapshot.connectionState == ConnectionState.waiting) {
          // return CircularProgressIndicator();
          return ModalProgressHUD(inAsyncCall: true, child: Container());
        }
        List<DocumentSnapshot> groupDocuments = [];

        for (int i = 0; i < groupsSnapshot.data!.docs.length; i++) {
          String? currentUserEmail = FirebaseAuth.instance.currentUser?.email;
          Map<String, dynamic> usersMap = groupsSnapshot.data!.docs[i]['Users'];
          if (usersMap.containsKey(currentUserEmail))
            groupDocuments.add(groupsSnapshot.data!.docs[i]);
        }

        //List<DocumentSnapshot> groupDocuments = groupsSnapshot.data!.docs;
        // messages =================================================================

        // return StreamBuilder<QuerySnapshot>(
        //   stream: messages.snapshots(),
        //   builder: (context, messagesSnapshot) {
        //     if (messagesSnapshot.connectionState == ConnectionState.waiting) {
        //       // return CircularProgressIndicator();
        //       return ModalProgressHUD(inAsyncCall: true, child: Container());
        //     }

        // users =================================================================

        return StreamBuilder<QuerySnapshot>(
          stream: users.snapshots(),
          builder: (context, usersSnapshot) {
            if (usersSnapshot.connectionState == ConnectionState.waiting) {
              return ModalProgressHUD(inAsyncCall: true, child: Container());
            }

            List<DocumentSnapshot> userDocuments = usersSnapshot.data!.docs;

            return Scaffold(
                key: scaffoldKey,
                appBar: AppBar(
                  leading: IconButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          'LoginPage',
                          (route) => false,
                        );
                      },
                      icon: const Icon(Icons.arrow_back_ios_new)),
                  toolbarHeight: 100,
                  elevation: 0,
                  backgroundColor: primeColor,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(ImageLogo,
                          height: 70, width: 70, fit: BoxFit.fitHeight)
                    ],
                  ),
                  actions: [
                    Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                if (Mode) {
                                  darkMode();
                                } else {
                                  lightMode();
                                }

                                Mode = !Mode;
                              });
                            },
                            icon: Mode
                                ? const Icon(Icons.nightlight_round_sharp)
                                : const Icon(Icons.sunny)))
                  ],
                ),
                body: Container(
                  color: primeColor,
                  child: Container(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: const BorderRadius.only(
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
                                height: 45,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: Icon(
                                  Icons.person,
                                  color: Person ? Colors.blue : Colors.grey,
                                ),
                              ),
                            ),
                            Expanded(
                              child: MaterialButton(
                                onPressed: () {
                                  setState(() {
                                    Person = false;
                                  });
                                },
                                height: 45,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: Icon(
                                  Icons.groups,
                                  color: !Person ? Colors.blue : Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Person
                            ? Expanded(
                                child: Container(
                                  child: ListView.separated(
                                      itemBuilder: (context, index) {
                                        if (userDocuments[index]["email"] !=
                                            FirebaseAuth
                                                .instance.currentUser!.email) {
                                          return ChatContact(
                                            user: userDocuments[index],
                                          );
                                        } else {
                                          username =
                                              userDocuments[index]["UserName"];
                                          return Container();
                                        }
                                      },
                                      separatorBuilder: (context, index) {
                                        if (userDocuments[index]["email"] !=
                                            FirebaseAuth
                                                .instance.currentUser!.email) {
                                          return const SizedBox(
                                            height: 10,
                                          );
                                        } else {
                                          return const SizedBox();
                                        }
                                      },
                                      itemCount: userDocuments.length),
                                ),
                              )
                            : Expanded(
                                child: Container(
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    //  physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsetsDirectional
                                            .symmetric(horizontal: 15.0),
                                        child: GroupContact(
                                            groupDocuments:
                                                groupDocuments[index]),
                                      );
                                    },
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(
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

                              // userList.forEach((key, value) {
                              //   print('$key: $value');
                              //
                              //   //groups.doc("Users").update({});
                              // });
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
                                    color: backgroundColor,
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
                                                  if (value!.isEmpty) {
                                                    return "Enter Group Name";
                                                  } else {
                                                    return null;
                                                  }
                                                },
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: TextColor),
                                                decoration: InputDecoration(
                                                    labelText: "Group Name",
                                                    labelStyle: TextStyle(
                                                        color: Colors.grey),
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
                                                          .currentUser!.email) {
                                                    return SelectUsers(
                                                      user:
                                                          userDocuments[index],
                                                      list: userList,
                                                    );
                                                  } else {
                                                    return Container();
                                                  }
                                                },
                                                separatorBuilder:
                                                    (context, index) {
                                                  if (userDocuments[index]
                                                          ["email"] !=
                                                      FirebaseAuth.instance
                                                          .currentUser!.email) {
                                                    return const SizedBox(
                                                      height: 10,
                                                    );
                                                  } else {
                                                    return const SizedBox();
                                                  }
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
                        backgroundColor: primeColor,
                        child: bottomSheet
                            ? const Icon(
                                Icons.add,
                                // color: Colors.grey,
                              )
                            : const Icon(
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
    // },
    //);
  }
}
