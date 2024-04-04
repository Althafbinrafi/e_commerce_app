

class CategoryModel {
  int id;
  String category;

  CategoryModel({
    required this.id,
    required this.category,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json["id"],
        category: json["category"],
      );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "category": category,
//     };
}
