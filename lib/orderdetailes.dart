import 'package:flutter_application_1/Webservice/webservice.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

class OrderDetails extends StatefulWidget {
  const OrderDetails({super.key});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  // String? username;

  // void initState() {
  //   super.initState();
  //   _loadUsername();
  // }

  // void _loadUsername() async {
  //   final prefs = await SharedPreferences.getInstance();

  //   setState(() {
  //     username = prefs.getString('username');
  //   });
  //   log("isloggedin =" + username.toString());
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color.fromARGB(255, 5, 42, 71),
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
            'Order Details',
            style: TextStyle(
              fontSize: 25,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
        ),
        body: FutureBuilder(
          future: Webservice().fetchOrderDetails(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    log(snapshot.data!.length.toString());
                    // ignore: non_constant_identifier_names
                    final Order_details = snapshot.data![index];
                    return Padding(
                      padding: EdgeInsets.all(10),
                      child: Card(
                        elevation: 0,
                        color: Color.fromARGB(255, 255, 255, 255),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: ExpansionTile(
                          trailing: Icon(Icons.arrow_drop_down),
                          textColor: Colors.black,
                          collapsedTextColor: Colors.black,
                          iconColor: Colors.red,
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                DateFormat.yMMMEd().format(Order_details.date),
                                //Order_details.date.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                Order_details.paymentmethod.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.green.shade300,
                                    fontWeight: FontWeight.w300),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                Order_details.totalamount.toString() + '/-',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w300),
                              )
                            ],
                          ),
                          children: [
                            ListView.separated(
                                itemCount: Order_details.products.length,
                                shrinkWrap: true,
                                padding: EdgeInsets.only(top: 25),
                                physics: NeverScrollableScrollPhysics(),
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return SizedBox(
                                    height: 10,
                                  );
                                },
                                itemBuilder: (BuildContext context, int index) {
                                  //List<Option> option = quiz.option;
                                  return Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: SizedBox(
                                      height: 100,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            height: 80,
                                            width: 100,
                                            child: Padding(
                                              padding: EdgeInsets.only(left: 9),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20)),
                                                    image: DecorationImage(
                                                        image: NetworkImage(
                                                            Webservice()
                                                                    .imageurl +
                                                                Order_details
                                                                    .products[
                                                                        index]
                                                                    .image
                                                            // 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT8ISYJZGXBrnQUPzdsnEJwBWFL8SbCghWFrpj8ak27i0WhklgGN9I-k2upA93HTlnng8M&usqp=CAU',
                                                            ),
                                                        fit: BoxFit.fill)),
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                              child: Padding(
                                            padding: EdgeInsets.all(6),
                                            child: Wrap(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.all(8),
                                                  child: Text(
                                                    Order_details
                                                        .products[index]
                                                        .productname,
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Color.fromARGB(
                                                            255, 0, 0, 0)),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 8, right: 8),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        Order_details
                                                            .products[index]
                                                            .price
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.red),
                                                      ),
                                                      Text(
                                                        Order_details
                                                            .products[index]
                                                            .quantity
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    10,
                                                                    201,
                                                                    57)),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ))
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ],
                        ),
                      ),
                    );
                  });
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }
}
