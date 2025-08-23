import 'package:flutter/material.dart';
import 'package:shoping_list/data/dummy_items.dart';

class Home extends StatelessWidget{
  const Home({super.key});
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Groceries"),
      ),
      body: Column(
        children: [
          for(final groceryItem in groceryItems)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Icon(Icons.rectangle, color: groceryItem.category.color),
                const SizedBox(width: 10,),
                Expanded(
                  child: Text(groceryItem.name, style: TextStyle(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.left,
                  ),
                ),
                const SizedBox(width: 10,),
                Text(groceryItem.quantity.toString()),
              ],
            ),
          )
        ],
      ),
    );
  }
}