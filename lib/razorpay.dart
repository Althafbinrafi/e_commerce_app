import 'dart:convert';
import 'dart:developer';
import 'package:flutter_application_1/Webservice/webservice.dart';
import 'package:flutter_application_1/home.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Provider/cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

// ignore: must_be_immutable
class PaymentScreen extends StatefulWidget {
  List<CartProduct> cart;
  String amount;
  String paymentmethod;
  String date;
  String name;
  String address;
  String phone;
  PaymentScreen(
      {super.key,
      required this.address,
      required this.amount,
      required this.cart,
      required this.date,
      required this.name,
      required this.paymentmethod,
      required this.phone});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Razorpay? razorpay;
  TextEditingController textEditingController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _loadUsername();
    razorpay = Razorpay();
    razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    flutterpayment('abcd', 10); //10=amount
  }

  @override
  void dispose() {
    super.dispose();
    razorpay!.clear();
  }

  String? username;
  void _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username');
    });
    log('isLoggedin=$username');
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
    try {
      String jsondata = jsonEncode(cart);
      log('jsondata= ${jsondata}');

      final vm = Provider.of<Cart>(context, listen: false);
      final response =
          await http.post(Uri.parse('${Webservice.mainurl}order.php'), body: {
        'username': username,
        'amount': amount,
        'paymentmethod': paymentmethod,
        'quantity': vm.count.toString(),
        'date': date,
        'cart': jsondata,
        'name': name,
        'address': address,
        'phone': phone
      });

      if (response.statusCode == 200) {
        log(response.body);
        if (response.body.contains('Success')) {
          vm.clearCart();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
                    '  Your Order Seccessfully Completed',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              )));
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return HomePage();
          }));
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }

  void flutterpayment(String orderId, int t) {
    var options = {
      'key': 'rzp_test_KBl96fHCU3zqGI',
      'amount': t * 100,
      'name': 'althu',
      'currency': 'INR',
      'description': 'mlaigai',
      'external': {
        'wallets': ['paytm']
      },
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': "8089891475", 'email': 'althafbinrafi@gmail.com'},
    };
    try {
      razorpay!.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    response.orderId;

    successmethod(response.paymentId.toString());

    Fluttertoast.showToast(
        msg: 'SUCCESS:' + response.paymentId!, toastLength: Toast.LENGTH_SHORT);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    log('error==' + response.message.toString());
    Fluttertoast.showToast(
        msg: 'ERROR:' + response.code.toString() + "-" + response.message!,
        toastLength: Toast.LENGTH_SHORT);
  }

  void _handleExternalWallet(PaymentFailureResponse response) {
    log("Wallet");
    //Fluttertoast.showToast(
    //msg:'EXTERNAL_WALLET:'+response.walletName!,
    //toastLength: Toast.LENGTH_SHORT);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(),
    );
  }

  void successmethod(String paymentid) {
    log('success=' + paymentid);
    orderPlace(widget.cart, widget.amount.toString(), widget.paymentmethod,
        widget.date, widget.name, widget.address, widget.phone);
  }
}
