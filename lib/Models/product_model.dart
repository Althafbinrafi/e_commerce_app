class ProductModel {
  int id;
  int catid;
  String productname;
  String price;
  String image;
  String description;

  ProductModel({
    required this.id,
    required this.catid,
    required this.productname,
    required this.price,
    required this.image,
    required this.description,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"],
        catid: json["catid"],
        productname: json["productname"],
        price: json["price"].toString(),
        image: json["image"],
        description: json["description"],
      );

  // Map<String, dynamic> toJson() => {
  //     "id": id,
  //     "catid": catid,
  //     "productname": productname,
  //     "price": price,
  //     "image": image,
  //     "description": description,
  // };
}
