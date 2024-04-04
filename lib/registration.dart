import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants.dart';
import 'package:flutter_application_1/login.dart';
import 'package:http/http.dart' as http;

class RegistraionPage extends StatefulWidget {
  const RegistraionPage({super.key});

  @override
  State<RegistraionPage> createState() => _RegistraionPageState();
}

class _RegistraionPageState extends State<RegistraionPage> {
  String? name, phone, address, username, password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //registraion function//

  registration(String name, phone, address, username, password) async {
    print('webservice');
    print(username);
    print(password);

    var result;
    final Map<String, dynamic> Data = {
      "name": name,
      "phone": phone,
      "address": address,
      "username": username,
      "password": password,
    };
    final response = await http.post(
      Uri.parse("http://bootcamp.cyralearnings.com/registration.php"),
      body: Data,
    );

    print(response.statusCode);
    if (response.statusCode == 200) {
      if (response.body.contains("success")) {
        log("Registration Successfully completed");

        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return LoginPage();
        }));
      } else {
        log("Registration Failed");
      }
    } else {
      result = {log(json.decode(response.body)['error'.toString()])};
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 24, 45, 84),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Text(
                  style: TextStyle(
                    color: basecolor,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  'Registration Page'),
              Text(
                  style: TextStyle(
                    color: basecolor,
                  ),
                  'Complete your details'),
              SizedBox(
                height: 70,
              ),
              Form(
                  key: _formKey,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 50, right: 50, top: 8),
                          child: Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: basecolor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 25),
                                child: Center(
                                    child: TextFormField(
                                  onChanged: (text) {
                                    setState(() {
                                      name = text;
                                    });
                                  },
                                  style: TextStyle(fontSize: 15),
                                  decoration: InputDecoration.collapsed(
                                    hintText: ('Enter your Name'),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter your name';
                                    }
                                    return null;
                                  },
                                ))),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(left: 50, right: 50, top: 15),
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: basecolor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 25),
                              child: Center(
                                child: TextFormField(
                                  keyboardType: TextInputType.phone,
                                  onChanged: (text) {
                                    setState(() {
                                      phone = text;
                                    });
                                  },
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                  decoration: InputDecoration.collapsed(
                                      hintText: 'Phone Number'),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Enter your phone number";
                                    } else if (value.length < 10 ||
                                        value.length > 10) {
                                      return 'Please enter a valid phone number';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                            padding:
                                EdgeInsets.only(top: 15, left: 50, right: 50),
                            child: Container(
                              height: 85,
                              decoration: BoxDecoration(
                                color: basecolor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 10),
                                  child: TextFormField(
                                    maxLines: 2,
                                    onChanged: (text) {
                                      setState(() {
                                        address = text;
                                      });
                                    },
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                    decoration: InputDecoration.collapsed(
                                        hintText: 'Address'),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter your address';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            )),
                        Padding(
                          padding:
                              EdgeInsets.only(left: 50, right: 50, top: 15),
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: basecolor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 25),
                                child: TextFormField(
                                  onChanged: (text) {
                                    setState(() {
                                      username = text;
                                    });
                                  },
                                  style: TextStyle(fontSize: 15),
                                  decoration: InputDecoration.collapsed(
                                      hintText: 'Create a Username'),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please create a Username';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(left: 50, right: 50, top: 15),
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: basecolor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 25),
                                child: TextFormField(
                                  obscureText: true,
                                  onChanged: (text) {
                                    setState(() {
                                      password = text;
                                    });
                                  },
                                  style: TextStyle(fontSize: 15),
                                  decoration: InputDecoration.collapsed(
                                      hintText: 'Create a Password'),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Enter Your Password Please";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Container(
                            height: 40,
                            width: MediaQuery.of(context).size.width / 3,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                backgroundColor: basecolor,
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  log('Name=' + name.toString());
                                  log('Phone=' + phone.toString());
                                  log('Address=' + address.toString());
                                  log('Username=' + username.toString());
                                  log('Password=' + password.toString());

                                  registration(name!, phone, address, username,
                                      password);
                                }
                              },
                              child: Text(
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                  'Register'),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Do you have already an account?   ',
                                style: TextStyle(
                                  color: basecolor,
                                  fontSize: 16,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return LoginPage();
                                      },
                                    ),
                                  );
                                },
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                    color: basecolor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            ])
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
