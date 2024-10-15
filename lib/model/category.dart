class Subcategory {
  final int id;
  final String name;

  Subcategory({required this.id, required this.name});

  factory Subcategory.fromJson(Map<String, dynamic> json) {
    return Subcategory(
      id: json['id'],
      name: json['name'],
    );
  }
}

class Category {
  final int id;
  final String name;
  final List<Subcategory>? subcategories; // Nullable subcategories

  Category({required this.id, required this.name, this.subcategories});

  factory Category.fromJson(Map<String, dynamic> json) {
    List<Subcategory>? subcategories;

    // Check if 'subcategories' exists and is not null
    if (json['subcategories'] != null) {
      var subcategoryList = json['subcategories'] as List;
      subcategories =
          subcategoryList.map((i) => Subcategory.fromJson(i)).toList();
    }

    return Category(
      id: json['id'],
      name: json['name'],
      subcategories: subcategories,
    );
  }
}
