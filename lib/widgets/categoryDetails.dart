
import 'dart:io';

import 'package:article_mobile_app/model/article.model.dart';
import 'package:article_mobile_app/model/category.model.dart';
import 'package:article_mobile_app/provider/sqliteDb.provider.dart';
import 'package:article_mobile_app/widgets/articleInsertion.dart';
import 'package:article_mobile_app/widgets/emptyData.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
class CategoryDetails extends StatefulWidget {
  Category? category;
   CategoryDetails(this.category , {Key? key,}) : super(key: key);

  @override
  State<CategoryDetails> createState() => _CategoryDetailsState();
}

class _CategoryDetailsState extends State<CategoryDetails> {
List<Article>? articles;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    toGet();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        bottomNavigationBar: BottomAppBar(

            child: Container(
              height: 50,

              child: BottomAppBar(
                color: Theme.of(context).primaryColor,
                notchMargin: 4,
                shape: CircularNotchedRectangle(),
              ),
            )
        ),
        floatingActionButton: FloatingActionButton(
          elevation: 30,
          tooltip: "Ajouter",
          child: Icon(Icons.add),
          onPressed: (){
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context){
                  print(widget.category!.id);
                  return ArticleInsertion(widget.category!.id, null,null,null,null,null,null,null);
                }
                )).then((value) => toGet());
          },
        ),
      appBar: AppBar(
        title: Text("${widget.category!.name}"),

      ),
      body: (articles==null || articles!.isEmpty)?
      const EmptyData():
          ListView.builder(
            itemCount: articles!.length,
              itemBuilder: (context,i){
                Article article = articles![i];
                return Container(
                  padding: EdgeInsets.all(2),
                  height: 150,
                  child: Card(
                    elevation: 15,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          child: (article.photo == null)?
                          Image.asset("images/image.jpeg" ,fit: BoxFit.cover,):
                          Image.file(File(article.photo!), fit: BoxFit.contain,),
                        ),
                        Expanded(
                            flex: 3,
                            child: Container(
                              padding: EdgeInsets.all(1),
                              child: MaterialButton(
                                onPressed: null,
                                onLongPress: () {
                                  showDialog(context: context,
                                      builder: (BuildContext buildContext) =>
                                          AlertDialog(
                                            title: Text('Actions '),
                                            content: Text('Update or Delete ${article.name}'),
                                            actions: [
                                              ElevatedButton(onPressed: ()=> Navigator.pop(context),
                                                  child: Icon(Icons.undo, ),
                                              ),
                                              ElevatedButton(onPressed: () {
                                                setState(() {
                                                  Navigator.pop(context);
                                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                                      ArticleInsertion(
                                                          article.category,
                                                          article.id,
                                                          article.photo,
                                                          article.name,
                                                          article.description,
                                                          article.price,
                                                          article.quantity,
                                                          article.storage)));
                                                  toGet();
                                                });
                                              }, child: Icon(Icons.edit, )
                                              ),
                                              ElevatedButton(
                                                  onPressed: (){
                                                      SQLiteDbProvider().delete(article.id!, 'articles').then(
                                                      (value) {
                                                      print("id = $value");
                                                      toGet();
                                                      Navigator.pop(context);
                                                      }
                                                      );
                                                      },
                                                  child: Icon(Icons.delete,color: Colors.red,),

                                              ),
                                            ],
                                          ),
                                    barrierDismissible: false
                                  );
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text("${article.name!.toUpperCase()}", style: TextStyle(fontWeight: FontWeight.bold ,color: Theme.of(context).primaryColor),maxLines: 2,),

                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text((article.price == null)?"price is not set": "Price : ",style: TextStyle(fontWeight: FontWeight.bold, )),
                                        Text('${article.price} \$',)
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text((article.quantity == null)? "quantity is not set": "Quantity : ",style: TextStyle(fontWeight: FontWeight.bold)),
                                        Text('${article.quantity}')
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text((article.storage == null)? "storage is not set": "Storage : ",style: TextStyle(fontWeight: FontWeight.bold)),
                                        Expanded(child: Text('${article.storage}',maxLines: 2,))
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      textBaseline: TextBaseline.ideographic,
                                      children: [
                                        Text((article.price!=null && article.quantity!=null)? "Total (\$) : ": "quantity or price not set", style: TextStyle(fontWeight: FontWeight.bold)),
                                        Expanded(
                                            child: Text('${article.price!*article.quantity!} \$',maxLines: 2,)
                                        )
                                      ],
                                    ),
                                    Row(

                                      children: [
                                        Text((article.description == null)? "description is not set ":"Details :",style: TextStyle(fontWeight: FontWeight.bold)),
                                        Expanded(child: Text('${article.description }', maxLines: 1,))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                        )
                      ],
                    ),
                  ),
                );
                /*Card(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Card(
                        child: ListTile(
                          tileColor: Colors.pink,
                          title: Text("${article.name}", style: TextStyle(fontWeight: FontWeight.bold),),

                        ),
                      ),
                      Card(
                        child: (article.photo == null)?
                        Image.asset("images/image.jpeg" ,fit: BoxFit.cover,):
                        Image.file(File(article.photo!)),
                      ),
                      Text((article.price == null)?"price is not set": "Price : ${article.price} \$"),
                      Text((article.quantity == null)? "quantity is not set": "Quantity : ${article.quantity}"),
                      Text((article.storage == null)? "storage is not set": "Storage : ${article.storage}"),
                      Text((article.price!=null && article.quantity!=null)? "Total price : ${article.price!*article.quantity!} \$": "quantity or price not set"),
                      Text((article.description == null)? "description is not set ":"Description : ${article.description}"),
                      Expanded(
                        child: Card(
                          child: ListTile(
                            tileColor: Theme.of(context).primaryColor,
                            leading: IconButton(icon: Icon(Icons.edit), onPressed: null,),
                            trailing: IconButton(icon: Icon(Icons.delete), onPressed: null,),
                          ),
                        ),
                      ),
                    ],
                  ),
                );*/
              }
          )
      /*GridView.builder(
        itemCount: articles!.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (context,i){
            Article article = articles![i];
            return  Card(
              child: GridTile (
                  header: Text("${article.name}"),
                  footer: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text((article.price == null)?"price is not set": "Price : ${article.price} \$"),
                      Text((article.quantity == null)? "quantity is not set": "Quantity : ${article.quantity}"),
                      Text((article.storage == null)? "storage is not set": "Storage : ${article.storage}"),
                      Text((article.price!=null && article.quantity!=null)? "Total price : ${article.price!*article.quantity!} \$": "quantity or price not set"),
                      // Text((article.description == null)? "description is not set ":"Description : ${article.description}"),
                    ],
                  ),
                  child: (article.photo == null)?
                  Image.asset("images/image.jpeg" ,fit: BoxFit.contain,):
                  Image.file(File(article.photo!)),

              ),
            );
          }
      ),*/
    );
  }

  void toGet() {
    SQLiteDbProvider().getAllArticles(widget.category!.id!).then((listArticles){
      setState(() {
        articles = listArticles;
      });
    });
  }
}



