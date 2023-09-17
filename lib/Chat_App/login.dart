import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> formKey = GlobalKey();

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

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
                "Log in",
                //textAlign: TextAlign.start,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
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
                                  .signInWithEmailAndPassword(
                                      email: emailController.text.toString(),
                                      password:
                                          passwordController.text.toString())
                                  .then((value) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Successes")));
                                // Navigator.pop(context);
                                Navigator.pushNamed(context, "HomePage");
                              });
                            } catch (ex) {
                              await ScaffoldMessenger.of(context).showSnackBar(
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
                          "Login",
                          style: TextStyle(color: Colors.white, fontSize: 22),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  const Text("Don't have an account?"),
                  GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "RegisterPage");
                        //  print("object");
                      },
                      child: const Text(
                        "Register",
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
