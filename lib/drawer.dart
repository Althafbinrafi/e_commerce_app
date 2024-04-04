import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Provider/cart_provider.dart';
import 'package:flutter_application_1/cartpage.dart';
import 'package:flutter_application_1/constants.dart';
import 'package:flutter_application_1/home.dart';
import 'package:flutter_application_1/login.dart';
import 'package:flutter_application_1/orderdetailes.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: library_prefixes
import 'package:badges/badges.dart' as Badges;

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                "Shopzy",
                style: TextStyle(
                  color: groundcolor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Divider(
              color: Color.fromARGB(255, 24, 45, 84),
            ),
            SizedBox(
              height: 20,
            ),
            ListTile(
              leading: const Icon(
                Icons.home,
                color: Color.fromARGB(255, 24, 45, 84),
              ),
              title: const Text(
                "Home",
                style: TextStyle(fontSize: 15),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 15,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Badges.Badge(
                showBadge: context.read<Cart>().getItems.isEmpty ? false : true,
                badgeStyle: const BadgeStyle(badgeColor: Colors.red),
                badgeContent: Text(
                  context.watch<Cart>().getItems.length.toString(),
                  style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
                child: Icon(
                  Icons.shopping_cart,
                  color: Color.fromARGB(255, 24, 45, 84),
                ),
              ),
              title: Text(
                "Cart",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 15,
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return CartPage();
                }));
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.receipt,
                color: Color.fromARGB(255, 24, 45, 84),
              ),
              title: Text(
                "Order Details",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 15,
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return OrderDetails();
                }));
              },
            ),
            Expanded(
              child: SizedBox(),
            ),
            Column(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.settings,
                    color: Color.fromARGB(255, 24, 45, 84),
                  ),
                  title: Text(
                    "Settings",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 15,
                  ),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(
                    Icons.exit_to_app,
                    color: Color.fromARGB(255, 24, 45, 84),
                  ),
                  title: Text(
                    "Log out",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 15,
                  ),
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                    prefs.setBool("isLoggedIn", false);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
