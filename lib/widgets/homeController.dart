import 'dart:math';

import 'package:article_mobile_app/provider/sqliteDb.provider.dart';
import 'package:article_mobile_app/widgets/articleInsertion.dart';
import 'package:article_mobile_app/widgets/categoryDetails.dart';
import 'package:article_mobile_app/widgets/emptyData.dart';
import 'package:banner_listtile/banner_listtile.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

import '../model/category.model.dart';

class HomeController extends StatefulWidget {
  const HomeController({Key? key, required this.title}) : super(key: key);



  final String title;

  @override
  State<HomeController> createState() => _HomeControllerState();
}

class _HomeControllerState extends State<HomeController> {
  GlobalKey<FormState> key = GlobalKey<FormState>();
  TextEditingController categoryNameController = TextEditingController();
  String? newCategory ;
  List<Category>? categories;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    toGet();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
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
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: FloatingActionButton(

          tooltip: "Add a category",
          child: Icon(Icons.add),
          onPressed: (){
            categoryNameController.text="";
            insert(Category());
          },
        ),
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: (categories==null || categories!.length==0)
            ? const EmptyData() :
        ListView.builder(
            itemCount: categories!.length,
            itemBuilder: (context,int? i) {
              Category category = categories![i!];
              return Card(
                elevation: 10,
                color: Theme.of(context).primaryColor,
                child: ListTile(
                  style: ListTileStyle.list,
                  iconColor: Colors.white,
                  autofocus: true,
                  title: Text(category.name!,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  ),
                  ),
                  dense: true,
                  trailing: IconButton(
                    icon :Icon(Icons.delete, color: Colors.red,),
                    onPressed: (){
                      showDialog(context: context,
                          builder: (context) => AlertDialog(
                            content: Text('Are you sure to delete ${category.name}?'),
                            actions: [
                              TextButton(onPressed: ()=>Navigator.pop(context), child: Text('No')),
                              TextButton(onPressed: (){
                                SQLiteDbProvider().delete(category.id!, 'categories').
                                then((value) {
                                  toGet();
                                  Navigator.pop(context);
                                });
                              }, child: Text('Yes'))
                            ],
                          ),
                        barrierDismissible: false
                      );
                    },
                  ),
                  leading: IconButton(
                    icon :Icon(Icons.edit,),
                    onPressed: (){
                      categoryNameController.text =category.name!;
                      insert(category);
                    },
                  ),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => CategoryDetails(category)));
                  },
                ),
              );
            }
        )
    );


  }
  Future<void> insert(Category category)  async{
    showDialog(context: context,
        barrierDismissible: false,
        builder: (BuildContext buildContext)
        =>  AlertDialog(
          title: Text((categoryNameController.text=="")?'Category Saving':'Category Update'),
          content: Form(
            key: key,
            child: TextFormField(
              validator: (str){
                if(str ==null){
                  return "name required";
                }else if(str.length<=1){
                  return "Name is to short";
                }
              },
              controller: categoryNameController,
                decoration:  InputDecoration(
                    labelText: "Category",
                    hintText: (category == null)? "new category":category.name,
                ),
                onChanged: (String? str) {
                  setState(() {
                    newCategory=(category == null)? str:categoryNameController.text;
                    print(newCategory);
                  });
                }
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(buildContext), child: Text("Undo")),
            TextButton(onPressed: () {
              if(key.currentState!.validate()){
                setState(() {
                  if(newCategory  != null){
                    if(category == null){
                      category = Category();
                      Map<String,dynamic> map = {'name':newCategory};
                      category = Category.fromMap(map);
                    }else {
                      category.name = newCategory;
                    }
                    SQLiteDbProvider().upsertCategory(category).then((i) => toGet());
                    newCategory = null;
                  }

                  Navigator.pop(buildContext);
                });
              }

            }, child: Text("Validate"))
          ],
        )
    );
  }

  void toGet(){
    SQLiteDbProvider().getAllCategories().then(
            (categories) async{
              setState(() {
                this.categories = categories;
              });
            });
  }
}
