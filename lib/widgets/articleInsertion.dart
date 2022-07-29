import 'dart:io';

import 'package:article_mobile_app/model/article.model.dart';
import 'package:article_mobile_app/model/category.model.dart';
import 'package:article_mobile_app/provider/sqliteDb.provider.dart';
import 'package:article_mobile_app/widgets/categoryDetails.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
class ArticleInsertion extends StatefulWidget {
  int? id ;
  int? idArticle ;//id de l'article
  String? photoArticle;
  String? nameArticle;
  String? descriptionArticle;
  double? priceArticle;
  int? quantityArticle;
  String? storageArticle;
  ArticleInsertion(this.id,
                  this.idArticle,
                  this.photoArticle,
                  this.nameArticle,
                  this.descriptionArticle,
                  this.priceArticle,
                  this.quantityArticle,
                  this.storageArticle,
                  {Key? key}) : super(key: key);

  @override
  State<ArticleInsertion> createState() => _ArticleInsertionState();
}

class _ArticleInsertionState extends State<ArticleInsertion> {
  String? photo;
  String? name;
  int? category;
  String? description;
  double? price;
  int? quantity;
  String? storage;
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController stroreController = TextEditingController();
  GlobalKey<FormState> key = GlobalKey<FormState>();
  final OutlineInputBorder _border = const OutlineInputBorder(
    borderSide: BorderSide(),
  );
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      if(widget.idArticle!=null){
        SQLiteDbProvider().getAllArticles(widget.id!).then((value) async {
          List<Article> articles = value;
          setState(() {
            if (articles.isNotEmpty) {
              articles.forEach(
                      (element) {
                        if(element.id == widget.idArticle){
                          setState(() {
                            photo = element.photo;
                            name = element.name;
                            description = element.description;
                            price = element.price;
                            quantity = element.quantity;
                            storage = element.storage;

                            /****************************/

                            nameController.text=element.name!;
                            descriptionController.text=element.description!;
                            priceController.text= element.price!.toString();
                            quantityController.text = element.quantity!.toString();
                            stroreController.text = element.storage!;
                          });
                        }
                      }
              );
            }
          });
        });
      }
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text((widget.idArticle==null)? 'Add ': 'Update', style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Card(
              elevation: 20.0,
              color: Theme.of(context).primaryColor,
              child: Form(
                key: key,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(height: 10,),
                    Text((widget.idArticle==null)? 'Article Saving': 'Article Updating', textScaleFactor: 1.5,style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                    const SizedBox(height: 10,),
                    (photo ==null)?
                        Image.asset("images/image.jpeg",):
                        Image.file(File(photo!)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(onPressed: ()=>getImage(ImageSource.camera), icon: Icon(Icons.camera_alt_outlined, color: Colors.white),),
                        IconButton(onPressed: () => getImage(ImageSource.gallery), icon: Icon(Icons.photo_library_outlined,color: Colors.white))
                      ],
                    ),
                    Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                SizedBox(height: 10,),
                                textField(TextFieldType[0], "Name"),
                                SizedBox(height: 10,),
                                textField(TextFieldType[1], "Price \$"),
                                SizedBox(height: 10,),
                                textField(TextFieldType[2], "Store"),
                                SizedBox(height: 10,),
                                textField(TextFieldType[3], "Quantity"),
                                SizedBox(height: 10,),
                                textField(TextFieldType[4], "Description"),
                                ButtonBar(
                                  children: [
                                    ElevatedButton(onPressed: ()=>Navigator.pop(context), child: Text('Undo',style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),),),
                                    ElevatedButton(onPressed:   insert,
                                      child: Text('Validate',style: TextStyle( fontWeight: FontWeight.bold))),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                    ),

                  ],

                ),
              ),
            )
          ],
        ) ,
      ),
    );

  }
  TextFormField textField( String type, String label ){
    return TextFormField(
      decoration: InputDecoration(
        hintText: hintLabelType(type),
        labelText: label,
        prefixIcon: iconType(type),
      ),
      keyboardType: keyboardType(type),
      controller: controllerType(type),
      validator: (str){
        if( controllerType(type).text.isEmpty ) return "Field required";else return null;
      },
      onChanged: (String str){
        if(type == TextFieldType[0] ){
          name = str;
          nameController.text =str;
        }else if(type == TextFieldType[1]){
          price = double.tryParse(str);
        }else if(type == TextFieldType[2]){
          storage = str;
        }else if(type == TextFieldType[3]){
          quantity = int.tryParse(str);
        }else if(type == TextFieldType[4]){
          description = str;
        }
      },
    );
  }
  static const List<String> TextFieldType = ["name","price","store","quantity", "description"];
  Icon iconType(String type){
      if(type == TextFieldType[0] ){
        return Icon(Icons.article);
      }else if(type == TextFieldType[1]){
        return Icon(Icons.monetization_on);
      }else if(type == TextFieldType[2]){
        return Icon(Icons.store);
      }else if(type == TextFieldType[3]){
        return Icon(Icons.numbers);
      }else if(type == TextFieldType[4]){
        return Icon(Icons.description);
      }
    return Icon(Icons.article);
  }
  String hintLabelType(type){
    if(type == TextFieldType[0] ){
       if(name==null && widget.idArticle==null){
         return "name";
       }else
       return name.toString();
    }else if(type == TextFieldType[1]){
      if(price==null && widget.idArticle==null) {
        return "price";
      }
      return price.toString();
    }else if(type == TextFieldType[2]){
      if(storage==null && widget.idArticle==null) {
        return "store";
      }
      return storage.toString();
    }else if(type == TextFieldType[3]){
      if(quantity==null && widget.idArticle==null) {
        return "quantity";
      }
      return quantity.toString();
    }else if(type == TextFieldType[4]){
      if(description==null && widget.idArticle==null) {
        return "description";
      }
      return description.toString();
    }
    return '';
  }
  TextInputType keyboardType(type){
    if(type == TextFieldType[0] ){
      return TextInputType.name;
    }else if(type == TextFieldType[1]){
      return TextInputType.number;
    }else if(type == TextFieldType[2]){
      return TextInputType.text;
    }else if(type == TextFieldType[3]){
      return TextInputType.number;
    }else if(type == TextFieldType[4]){
      return TextInputType.text;
    }
    return TextInputType.text;
  }
  TextEditingController controllerType(String type){
    if(type == TextFieldType[0] ){
      return nameController;
    }else if(type == TextFieldType[1]){
      return priceController;
    }else if(type == TextFieldType[2]){
      return stroreController;
    }else if(type == TextFieldType[3]){
      return quantityController;
    }else if(type == TextFieldType[4]){
      return descriptionController;
    }
    return TextEditingController();
  }
  void insert(){
    if(name != null) {
      Map<String,dynamic> map = { "name" : name, "category" : widget.id };
      if(storage != null) {
        map['storage'] = storage;
      }
      if(price != null){
        map['price'] = price;
      }
      if(quantity !=null){
        map['quantity'] = quantity;
      }
      if(description != null){
        map['description'] = description;
      }
      if(photo != null){
        map['photo'] = photo;
      }
      Article article = Article.fromMap(map);
      (widget.idArticle==null)? article.id=null: article.id = widget.idArticle;
      SQLiteDbProvider().upsertArticle(article).then((value) {
        print(value.toMap());
        widget.idArticle =null;
        photo =null;
        name = null;
        storage =null;
        price = null;
        description =null;
        quantity =null;
        Navigator.pop(context);

        SQLiteDbProvider().getAllCategories().then(
                (value) async {
                  Category? cat = Category();
                  for (var element in value) {
                    if(element.id== widget.id) cat = element;
                  }
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>CategoryDetails(cat)));
                });
        Navigator.pop(context);
      });
    }

  }

  Future getImage(ImageSource source) async {
    ImagePicker _picker = ImagePicker();
    var newImage = await _picker.pickImage(source: source);
    setState(() {
      photo = newImage?.path;
    });
  }
}
