class Article {
  int? id;
  String? name;
  int? category;
  String? description;
  double? price;
  int? quantity;
  String? storage;
  String? photo;

  Article(
      {this.id,
      this.name,
      this.category,
      this.description,
      this.price,
      this.quantity,
      this.storage,
      this.photo});
  factory Article.fromMap(Map<String,dynamic> map)
  => Article(
    id: map['id'],
    name: map['name'],
    category: map['category'],
    description: map['description'],
    price: map['price'] ,
    quantity: map['quantity'],
    storage: map['storage'],
    photo: map['photo']
  );

  Map<String,dynamic> toMap()
  => (id != null)?{
    "id" : id,
    "name":name,
    "category" : category,
    "description" : description,
    "price" : price,
    "quantity": quantity,
    "storage":storage,
    "photo":photo
  }:
  {
    "name":name,
    "category" : category,
    "description" : description,
    "price" : price,
    "quantity": quantity,
    "storage":storage,
    "photo":photo
  };
}
