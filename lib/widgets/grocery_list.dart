import 'package:flutter/material.dart';
import 'package:shoping_list/data/dummy_items.dart';
import 'package:shoping_list/widgets/new_item.dart';

class GroceryList extends StatefulWidget{
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  void _addButton(){
    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => NewItem(),
    ),
    );
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Groceries"),
        actions: [
          IconButton(onPressed: _addButton, icon: Icon(Icons.add))
        ],
      ),
      //best choise build
      body: ListView.builder(
        itemCount: groceryItems.length,
        itemBuilder: (ctx, index) =>  ListTile(
          leading: Container(
            width: 24,
            height: 24,
            color: groceryItems[index].category.color,
          ),
          title: Text(groceryItems[index].name),
          trailing: Text(groceryItems[index].quantity.toString()),
        )
      )
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