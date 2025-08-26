import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shoping_list/data/categories.dart';
import 'package:shoping_list/data/dummy_items.dart';
// import 'package:shoping_list/data/dummy_items.dart';
//tidak dipakai lagi karena sudah ada kondisi kalau kosong string munculPlease add item, there is no item
// import 'package:shoping_list/data/dummy_items.dart';
import 'package:shoping_list/models/grocey_item.dart';
import 'package:shoping_list/widgets/new_item.dart';
import 'package:http/http.dart' as http;

class GroceryList extends StatefulWidget{
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
   List<GroceryItem> _groceryItems = [];
  var _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadItem();
  }

  void _loadItem() async{
    final url = Uri.https(
      'flutterprep-23dd5-default-rtdb.firebaseio.com', 'shoping-list.json'
    );

    final response = await http.get(url);

    if(response.statusCode>=400){
      setState(() {
        _error = 'Failed to fetch data. Please try again later';
      });
    }
    
    if(response.body == 'null'){
      setState(() {
        _isLoading =false;
      });
      return;
    }


    final Map<String,dynamic> listdata =json.decode(response.body);

    final List<GroceryItem> loadedItems=[];
    for(final item in listdata.entries){
      final category = categories.entries.firstWhere((catItem)=> catItem.value.title == item.value['category']).value;
      loadedItems.add(GroceryItem(id: item.key, name: item.value['name'], quantity: item.value['quantity'], category: category));
    }

    setState(() {
      _groceryItems = loadedItems;
      _isLoading = false;
    });
  }

  void _addButton() async {
   final newItems =  await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(builder: (ctx) => NewItem(),
     ),
    );
     
    //tidak dipakai lagi
    setState(() {
      if(newItems == null){
        return ;
      }
      _groceryItems.add(newItems);
    });
  }

  void _remmoveItem(GroceryItem groceryItem) async{
      final groceryIndex = _groceryItems.indexOf(groceryItem);

      setState(() {
        _groceryItems.remove(groceryItem);
      });



       final url = Uri.https(
      'flutterprep-23dd5-default-rtdb.firebaseio.com', 'shoping-list/${groceryItem.id}.json'
    );

      final response = await http.delete(url);

      if(response.statusCode >=400){
        setState(() {
          _groceryItems.insert(groceryIndex, groceryItem);
        });
      }

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 3),
          content: const Text("Item deleted.", style: TextStyle( 
            color: Colors.blue,
          ),),
          action: SnackBarAction(
            label: "Undo",
            onPressed: () async{
              setState(() {
                  _groceryItems.insert(groceryIndex, groceryItem);
              });

              final url =Uri.https('flutterprep-23dd5-default-rtdb.firebaseio.com',
      'shoping-list/${groceryItem.id}.json',);
              await http.put(
                url,
                headers: {'Content-type' : 'application/json'},
                body: json.encode({
                  'name' : groceryItem.name,
                  'quantity' : groceryItem.quantity,
                  'category' : groceryItem.category.title,
                }),
              );
            }
          ),
        )
      );

  }

  
 
  @override
  Widget build(BuildContext context) {
     Widget mainContext = Center(child: Text('No Items found. Starting adding some !'),);
    
    if(_isLoading){
      mainContext = const Center(child: CircularProgressIndicator(),);
    }

  if(_groceryItems.isNotEmpty){
    mainContext = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (ctx, index) =>  Dismissible(
          key: ValueKey(_groceryItems[index].id),
          background: Container(
            color: Colors.redAccent,
            margin: EdgeInsets.symmetric(horizontal: 16),
          ),
          child: ListTile(
            leading: Container(
              width: 24,
              height: 24,
              color: _groceryItems[index].category.color,
            ),
            title: Text(_groceryItems[index].name),
            trailing: Text(_groceryItems[index].quantity.toString()),
          ),
          onDismissed: (direction){
            setState(() {
              _remmoveItem(_groceryItems[index]);
            });
          },
        ),
      );
  }

  if(_error != null){
    mainContext= Center(child: ErrorWidget.withDetails(message: _error.toString(),));
  }

    
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Groceries"),
        actions: [
          IconButton(onPressed: _addButton, icon: Icon(Icons.add))
        ],
      ),
      //best choise build
      body: mainContext
      //another choice
      // Column(
      //   children: [
      //     for(final groceryItem in groceryItems)
      //     Padding(
      //       padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
      //       child: Row(
      //         children: [
      //           Row(
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: [
      //               Icon(Icons.rectangle, color: groceryItem.category.color),
      //               const SizedBox(width: 14,),
      //               Text(groceryItem.name, style: TextStyle(
      //               color: Colors.white,
      //             ),
      //             textAlign: TextAlign.left,
      //             ),
      //             ],
      //           ),
      //           Spacer(),
      //           Text(groceryItem.quantity.toString()),
      //         ],
      //       ),
      //     )
      //   ],
      // ),
    );
  }
}