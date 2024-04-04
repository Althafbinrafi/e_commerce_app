import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants.dart';
import 'package:flutter_application_1/home.dart';
import 'dart:developer';
import 'package:flutter_application_1/registration.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late String username, password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _localCounter();
  }

  void _localCounter() async {
    final prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool("isLoggedIn") ?? false;
    log("isLoggedIn=" + isLoggedIn.toString());
    if (isLoggedIn) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => HomePage()));
    }
  }

  //login Function//
  login(String username, String password) async {
    print("webservice");
    print(username);
    print(password);

    var result;
    final Map<String, dynamic> loginData = {
      'username': username,
      'password': password,
    };

    final response = await http.post(
      Uri.parse("http://bootcamp.cyralearnings.com/login.php"),
      body: loginData,
    );

    print(response.statusCode);
    if (response.statusCode == 200) {
      if (response.body.contains("success")) {
        log("Login Successfully Completed");
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool("isLoggedIn", true);
        prefs.setString("username", username);
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return HomePage();
        }));
      } else {
        log("Login Failed");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            dismissDirection: DismissDirection.horizontal,
            duration: Duration(seconds: 10),
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: "Dismiss",
              disabledTextColor: Colors.white,
              textColor: Colors.yellow,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height - 100,
                left: 20,
                right: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(40)),
            ),
            backgroundColor: const Color.fromARGB(255, 255, 17, 0),
            content: Row(
              children: [
                Icon(Icons.error, color: Colors.white),
                Text(
                  "  Check Your Username or Password",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ],
            )));
      }
    } else {
      result = {log(json.decode(response.body)['error'].toString())};
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 24, 45, 84),
      body: Builder(
        builder: (context) {
          return SingleChildScrollView(
            child: Form(
                key: _formKey,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 200),
                      const Text(
                        "Shopzy",
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        "Login with your username and password",
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255)),
                      ),
                      const SizedBox(height: 50),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 50, right: 50, top: 8),
                        child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: basecolor,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: Center(
                                child: TextFormField(
                              style: const TextStyle(fontSize: 15),
                              decoration: const InputDecoration.collapsed(
                                  hintText: "Username"),
                              onChanged: (text) {
                                setState(() {
                                  username = text;
                                });
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Enter Your Username Please";
                                }
                                return null;
                              },
                            )),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 50, right: 50, top: 8),
                        child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: basecolor,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: Center(
                                  child: TextFormField(
                                obscureText: true,
                                style: const TextStyle(fontSize: 15),
                                decoration: const InputDecoration.collapsed(
                                    hintText: "Password"),
                                onChanged: (text) {
                                  setState(() {
                                    password = text;
                                  });
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Enter Your Password Please";
                                  }
                                  return null;
                                },
                              ))),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Padding(
                          padding: const EdgeInsets.all(8),
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width / 3,
                              height: 40,
                              child: TextButton(
                                  // ignore: sort_child_properties_last
                                  child: const Text(
                                    "Login",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                  ),
                                  style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(40)),
                                    backgroundColor: basecolor,
                                  ),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      log("username =$username");
                                      log("password=$password");

                                      login(username.toString(),
                                          password.toString());
                                    }
                                  }))),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account?   ",
                            style: TextStyle(
                              fontSize: 16,
                              color: basecolor,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return RegistraionPage();
                                },
                              ));
                              log("Go to Register");
                            },
                            child: Text(
                              "Go to Register",
                              style: TextStyle(
                                fontSize: 16,
                                color: basecolor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )),
          );
        },
      ),
      bottomSheet: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0),
          color: groundcolor,
        ),
        child: Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Copyright ',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Color.fromARGB(255, 75, 87, 110),
              ),
            ),
            Icon(
              Icons.copyright,
              color: Color.fromARGB(255, 75, 87, 110),
            ),
            Text(
              ' althafbinrafi ',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Color.fromARGB(255, 75, 87, 110),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
