import 'package:flutter/material.dart';
import 'package:flutter_application_1/details_page.dart';
import 'package:flutter_application_1/Webservice/webservice.dart';
import 'package:flutter_application_1/category_products.dart';
import 'package:flutter_application_1/constants.dart';
import 'package:flutter_application_1/drawer.dart';
import 'dart:developer';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'dart:core';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        toolbarHeight: 60,
        elevation: 0,
        centerTitle: true,
        backgroundColor: groundcolor,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Shopzy",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      drawer: DrawerWidget(),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder(
                future: Webservice().fetchCategory(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      height: 65,
                      // color: groundcolor,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8),
                            child: InkWell(
                              onTap: () {
                                log('Clicked');

                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return CategoryProductsPage(
                                    catid: snapshot.data![index].id,
                                    catname: snapshot.data![index].category,
                                  );
                                }));
                              },
                              child: Container(
                                padding: EdgeInsets.only(right: 20, left: 20),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(40)),
                                    color: groundcolor),
                                child: Center(
                                  child: Text(
                                    snapshot.data![index].category,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                }),
            SizedBox(
              height: 10,
            ),
            Text(
              '  Recommended for You',
              style: TextStyle(
                fontSize: 18,
                color: Color.fromARGB(255, 24, 45, 84),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: FutureBuilder(
                  future: Webservice().fetchProducts(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      log("length == " + snapshot.data!.length.toString());
                      return Container(
                        child: StaggeredGridView.countBuilder(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          // itemCount: 12,
                          itemCount: snapshot.data!.length,
                          crossAxisCount: 2,
                          itemBuilder: (context, index) {
                            final product = snapshot.data![index];
                            return InkWell(
                              onTap: () {
                                log('Clicked');
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return DetailsPage(
                                    id: product.id,
                                    name: product.productname,
                                    image:
                                        Webservice().imageurl + product.image,
                                    price: product.price,
                                    description: product.description,
                                  );
                                }));
                              },
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15),
                                        ),
                                        child: Container(
                                          constraints: BoxConstraints(
                                              // maxHeight: 100,
                                              // maxWidth: 250,
                                              ),
                                          child: Image(
                                            // fit: BoxFit.cover,
                                            image: NetworkImage(
                                              Webservice().imageurl +
                                                  product.image,
                                              // "https://media.istockphoto.com/id/803246686/photo/red-casual-shoes.jpg?s=612x612&w=0&k=20&c=pxd1BjHHGwO6EAQNeHiNEKN5VTonZc08N4ChDcG78eU=",
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Column(
                                          children: [
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                product.productname,
                                                // "Shoes",
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            Column(
                                              children: [
                                                Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Text(
                                                    "Rs." +
                                                        product.price
                                                            .toString(),
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          staggeredTileBuilder: (context) =>
                              const StaggeredTile.fit(1),
                        ),
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }
}
