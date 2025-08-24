import 'package:flutter/material.dart';
//tidak dipakai lagi karena sudah ada kondisi kalau kosong string munculPlease add item, there is no item
// import 'package:shoping_list/data/dummy_items.dart';
import 'package:shoping_list/models/grocey_item.dart';
import 'package:shoping_list/widgets/new_item.dart';

class GroceryList extends StatefulWidget{
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  final List<GroceryItem> _groceryItems = [];


  void _addButton() async {
    final newItems = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(builder: (ctx) => NewItem(),
     ),
    );
    setState(() {
      if(newItems == null){
        return ;
      }
      _groceryItems.add(newItems);
    });
  }

  void _remmoveItem(GroceryItem groceryItem){
      final groceryIndex = _groceryItems.indexOf(groceryItem);

      setState(() {
        _groceryItems.remove(groceryItem);
      });

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 3),
          content: const Text("Item deleted.", style: TextStyle( 
            color: Colors.blue,
          ),),
          action: SnackBarAction(
            label: "Undo",
            onPressed: (){
              setState(() {
                  _groceryItems.insert(groceryIndex, groceryItem);
              });
            }
          ),
        )
      );

  }

  
 
  @override
  Widget build(BuildContext context) {
     Widget mainContext = Center(child: Text('No Items found. Starting adding some !'),);

  if(_groceryItems.isNotEmpty){
    mainContext = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (ctx, index) =>  Dismissible(
          key: ValueKey(_groceryItems[index]),
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