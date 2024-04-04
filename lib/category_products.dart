import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Webservice/webservice.dart';
import 'package:flutter_application_1/constants.dart';
import 'package:flutter_application_1/details_page.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

// ignore: must_be_immutable
class CategoryProductsPage extends StatefulWidget {
  String catname;
  int catid;
  CategoryProductsPage({required this.catid, required this.catname});

  @override
  State<CategoryProductsPage> createState() => _CategoryProductsPageState();
}

class _CategoryProductsPageState extends State<CategoryProductsPage> {
  @override
  Widget build(BuildContext context) {
    log('Catneme' + widget.catname.toString());
    log('CatId' + widget.catid.toString());
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: groundcolor,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.catname,
          // "Category Name",
          style: TextStyle(
              fontSize: 20, color: const Color.fromARGB(255, 255, 255, 255)),
        ),
      ),
      body: FutureBuilder(
        future: Webservice().fetchCatProducts(widget.catid),
        builder: (context, snapshot) {
          // log('length' + snapshot.data!.length.toString());
          if (snapshot.hasData) {
            return SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: StaggeredGridView.countBuilder(
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                crossAxisCount: 2,
                itemBuilder: (context, index) {
                  final product = snapshot.data![index];
                  return InkWell(
                    onTap: () {
                      log("clicked");

                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return DetailsPage(
                          id: product.id,
                          name: product.productname,
                          image: Webservice().imageurl + product.image,
                          price: product.price,
                          description: product.description,
                        );
                      }));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15)),
                              child: Container(
                                // constraints:
                                //     BoxConstraints(maxHeight: 100, maxWidth: 250),
                                child: Image(
                                  image: NetworkImage(
                                    Webservice().imageurl + product.image,
                                    // "https://images.pexels.com/photos/1027130/pexels-photo-1027130.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
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
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0),
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
                                          "Rs." + product.price.toString(),

                                          // product.price.toString(),
                                          style: const TextStyle(
                                            color: Colors.red,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
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
                staggeredTileBuilder: (context) => const StaggeredTile.fit(1),
              ),
            );
          } else {
            return const Center(child: Text('No data found'));
          }
        },
      ),
    );
  }
}
