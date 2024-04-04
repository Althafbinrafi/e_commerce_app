import 'package:flutter/material.dart';
import 'package:flutter_application_1/Provider/cart_provider.dart';
import 'package:flutter_application_1/checkoutpage.dart';
import 'package:flutter_application_1/constants.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartProduct> cartlist = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: groundcolor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: const Color.fromARGB(255, 255, 255, 255),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Cart',
          style: TextStyle(
            fontSize: 25,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        actions: [
          context.watch<Cart>().getItems.isEmpty
              ? const SizedBox()
              : IconButton(
                  onPressed: () {
                    context.read<Cart>().clearCart();
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ))
        ],
      ),
      body: context.watch<Cart>().getItems.isEmpty
          ? Center(
              child: Text('Your Cart is Empty !'),
            )
          : Consumer<Cart>(
              builder: (context, cart, child) {
                cartlist = cart.getItems;

                return ListView.builder(
                    itemCount: cart.count,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        image: DecorationImage(
                                            image: NetworkImage(
                                              cart.getItems[index].imageUrl,
                                            ),
                                            fit: BoxFit.fill),
                                      ),
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
                                          cart.getItems[index].name,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey.shade700,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              cart.getItems[index].price
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red.shade900),
                                            ),
                                            Container(
                                              height: 35,
                                              decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 255, 255, 255),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                              child: Row(
                                                children: [
                                                  IconButton(
                                                      onPressed: () {
                                                        cart.getItems[index]
                                                                    .qty ==
                                                                1
                                                            ? cart.removeItems(
                                                                cart.getItems[
                                                                    index])
                                                            : cart.reduceByOne(
                                                                cart.getItems[
                                                                    index]);
                                                      },
                                                      icon:
                                                          cartlist[index].qty ==
                                                                  1
                                                              ? const Icon(
                                                                  Icons.delete,
                                                                  size: 18,
                                                                )
                                                              : const Icon(
                                                                  Icons.remove,
                                                                  size: 18,
                                                                )),
                                                  Text(
                                                    cart.getItems[index].qty
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      color:
                                                          Colors.red.shade900,
                                                    ),
                                                  ),
                                                  IconButton(
                                                      onPressed: () {
                                                        cart.increment(cart
                                                            .getItems[index]);
                                                      },
                                                      icon: Icon(
                                                        Icons.add,
                                                        size: 18,
                                                      ))
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ))
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              },
            ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total : ' + context.watch<Cart>().totalPrice.toString(),
              style: TextStyle(
                fontSize: 20,
                color: Colors.red.shade900,
                fontWeight: FontWeight.bold,
              ),
            ),
            InkWell(
              onTap: () {
                context.read<Cart>().getItems.isEmpty
                    ? ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        dismissDirection: DismissDirection.horizontal,
                        duration: Duration(seconds: 3),
                        behavior: SnackBarBehavior.floating,
                        margin: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height - 150,
                          left: MediaQuery.of(context).size.width / 4,
                          right: MediaQuery.of(context).size.width / 4,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(40)),
                        ),
                        backgroundColor: const Color.fromARGB(255, 255, 17, 0),
                        content: Row(
                          children: [
                            Icon(Icons.error, color: Colors.white),
                            Text(
                              "  Your Cart is Empty",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )
                        )
                        )
                    : Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                        return CheckoutPage(
                          cart: cartlist,
                        ); //this area
                      }));
              },
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width / 2.2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: groundcolor,
                ),
                child: Center(
                  child: Text(
                    'Order Now',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
