class Category{
  int? id;
  String? name;

  Category({this.id, this.name});

  factory Category.fromMap(Map<String,dynamic> map)
      => Category( id: map['id'], name: map['name'] );

  Map<String,dynamic> toMap() => (id!=null)?{"id" : id, "name":name }:{"name":name };
}