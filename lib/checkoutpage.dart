import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/Models/user_model.dart';
import 'package:flutter_application_1/Provider/cart_provider.dart';
import 'package:flutter_application_1/Webservice/webservice.dart';
import 'package:flutter_application_1/constants.dart';
import 'package:flutter_application_1/home.dart';
import 'package:flutter_application_1/razorpay.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class CheckoutPage extends StatefulWidget {
  List<CartProduct> cart;
  CheckoutPage({required this.cart});
  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  int selecteValue = 1;

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  String? username;

  void _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username');
    });
    log('is logged in' + username.toString());
  }

  orderPlace(
    List<CartProduct> cart,
    String amount,
    String paymentmethod,
    String date,
    String name,
    String address,
    String phone,
  ) async {
    String jsondata = jsonEncode(cart);
    log('jsondata =${jsondata}');

    final vm = Provider.of<Cart>(context, listen: false);
    final response =
        await http.post(Uri.parse(Webservice.mainurl + "order.php"), body: {
      "username": username,
      "amount": amount,
      "paymentmethod": paymentmethod,
      "date": date,
      "quantity": vm.count.toString(),
      "cart": jsondata,
      "name": name,
      "address": address,
      "phone": phone
    });

    if (response.statusCode == 200) {
      log(response.body);
      if (response.body.contains('Success')) {
        vm.clearCart();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              dismissDirection: DismissDirection.horizontal,
              duration: Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height - 150,
                  left: 20,
                  right: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(40)),
              ),
              backgroundColor: Colors.green,
              content: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.white,
                  ),
                  Text(
                    '  Your Order Successfully Completed',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              )
              ),
        );
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return HomePage();
        }));
      }
    }
  }

  String? name, address, phone;
  String? paymentmethod = "Cash on delivery";
  Widget build(BuildContext context) {
    final vm = Provider.of<Cart>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: groundcolor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'CheckOut',
          style: TextStyle(
            fontSize: 25,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.all(8),
                child: FutureBuilder<UserModel>(
                    future: Webservice().fetchUser(username.toString()),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        name = snapshot.data!.name;
                        phone = snapshot.data!.phone;
                        address = snapshot.data!.address;
                        return Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Name : ',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      name.toString(),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Phone : ',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      phone.toString(),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Address : ',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width /
                                          1.5,
                                      child: Text(
                                        address.toString(),
                                        maxLines: 4,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return const CircularProgressIndicator();
                    })),
            SizedBox(
              height: 10,
            ),
            RadioListTile(
              activeColor: groundcolor,
              value: 1,
              groupValue: selecteValue,
              onChanged: (int? value) {
                setState(() {
                  selecteValue = value!;
                  paymentmethod = 'Cash on delivery';
                });
              },
              title: const Text(
                'Cash on delivery',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text('Pay cash at Home'),
            ),
            RadioListTile(
              activeColor: groundcolor,
              value: 2,
              groupValue: selecteValue,
              onChanged: (int? value) {
                setState(() {
                  selecteValue = value!;
                  paymentmethod = 'Online';
                });
              },
              title: const Text(
                'Pay Now',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text('Online Payment'),
            ),
          ],
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            String datetime = DateTime.now().toString();
            log(datetime.toString());

            if (paymentmethod == 'Online') {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return PaymentScreen(
                    address: address.toString(),
                    amount: vm.totalPrice.toString(),
                    cart: widget.cart,
                    date: datetime.toString(),
                    name: name.toString(),
                    paymentmethod: paymentmethod.toString(),
                    phone: phone.toString());
              }));
            } else if (paymentmethod == 'Cash on delivery') {
              orderPlace(widget.cart, vm.totalPrice.toString(), paymentmethod!,
                  datetime, name!, address!, phone!);
            }
          },
          child: Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: groundcolor,
            ),
            child: Center(
              child: Text(
                'CheckOut',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
