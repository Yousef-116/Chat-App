import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

// ignore: must_be_immutable
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var emailController = TextEditingController();

  var passwordController = TextEditingController();
  var usernameController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: loading,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                "Register",
                //textAlign: TextAlign.start,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    //==============================
                    //Username form Field
                    TextFormField(
                      controller: usernameController,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty)
                          // ignore: curly_braces_in_flow_control_structures
                          return "Enter your Username";
                        else {
                          return null;
                        }
                      },
                      style: const TextStyle(fontSize: 15),
                      decoration: InputDecoration(
                          // prefixIcon: Icon(Icons.email),
                          labelText: "UserName",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(color: Colors.blue)),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.blue, width: 2),
                            borderRadius: BorderRadius.circular(20),
                          )),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    //==============================
                    //Email form field
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty)
                          // ignore: curly_braces_in_flow_control_structures
                          return "Enter your Email";
                        else {
                          return null;
                        }
                      },
                      style: const TextStyle(fontSize: 15),
                      decoration: InputDecoration(
                          // prefixIcon: Icon(Icons.email),
                          labelText: "Email",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(color: Colors.blue)),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.blue, width: 2),
                            borderRadius: BorderRadius.circular(20),
                          )),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    //Password form field
                    //==============================
                    TextFormField(
                      controller: passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      validator: (value) {
                        if (value!.isEmpty)
                          // ignore: curly_braces_in_flow_control_structures
                          return "Enter your Password";
                        else {
                          return null;
                        }
                      },
                      style: const TextStyle(fontSize: 15),
                      decoration: InputDecoration(
                          //prefixIcon: Icon(Icons.email),
                          labelText: "Password",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(color: Colors.blue)),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.blue, width: 2),
                            borderRadius: BorderRadius.circular(20),
                          )),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Container(
                      decoration: (BoxDecoration(
                          borderRadius: BorderRadius.circular(15))),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: MaterialButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            setState(() {
                              loading = true;
                            });
                            try {
                              await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                // email: emailController.text.toLowerCase(),
                                email: emailController.text,

                                password: passwordController.text,
                              )
                                  .then((value) {
                                //Navigator.pushNamed(context, "LoginPage");
                                //print(
                                //  "Email From Text control :  ${emailController.text.toLowerCase()} ");
                                CollectionReference Users = FirebaseFirestore
                                    .instance
                                    .collection('Users');
                                Users.add({
                                  "email": FirebaseAuth
                                      .instance.currentUser?.email
                                      .toString(),
                                  "UserName": usernameController.text.toString()
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Success")));
                                Navigator.pop(context);
                                Navigator.pushNamed(context, "ChatPage");
                              });
                            } catch (ex) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(ex.toString())));
                            }
                            setState(() {
                              loading = false;
                            });
                          }
                        },
                        minWidth: double.infinity,
                        height: 60,
                        color: Colors.blue,
                        child: const Text(
                          "Register",
                          style: TextStyle(color: Colors.white, fontSize: 22),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  const Text("Already have an account?"),
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Log In",
                        style: TextStyle(color: Colors.blue, fontSize: 20),
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
