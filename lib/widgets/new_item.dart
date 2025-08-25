import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shoping_list/data/categories.dart';
import 'package:shoping_list/models/category.dart';
import 'package:shoping_list/models/grocey_item.dart';
// import 'package:shoping_list/models/grocey_item.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});
  @override
  State<NewItem> createState() {
    return _NewItemState();
  }
}
class _NewItemState extends State<NewItem>{
  final _formKey = GlobalKey<FormState>();
  var _enteredName = "";
  var _enteredQuantity = 1;
  var _selectedCategory = categories[Categories.vegetables]!;

  void _saveItem () async{
    if(_formKey.currentState!.validate()){
      _formKey.currentState!.save();
      //post to database firebase
      
      final url = Uri.https('flutterprep-23dd5-default-rtdb.firebaseio.com', 'shoping-list.json');
      final response = await http.post(
        url,
      headers: {
       'Content-Type': "application/json"
        },
      body: json.encode(
        {
           'name': _enteredName,
          'quantity': _enteredQuantity, 
          'category': _selectedCategory.title,
        }
      )
      );

      final Map<String, dynamic> resData = json.decode(response.body);
      print(response.body);
      print(response.body);

      if(!context.mounted){
        return;
      }

      Navigator.of(context).pop(
        GroceryItem(
                  id: DateTime.now().toString(),
         name: _enteredName,
          quantity: _enteredQuantity, 
          category: _selectedCategory!
        )
      );
      // tidak dipakai karena sudah pakai API
      // Navigator.of(context).pop(GroceryItem(
      //   //pakai datetime dulu tapi ini tidak bagus ya tom
        // id: DateTime.now().toString(),
        //  name: _enteredName,
        //   quantity: _enteredQuantity, 
        //   category: _selectedCategory!
      // )
      // );
    }
    
  }
@override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Add a New Item"),
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                  maxLength: 50,
                  decoration: InputDecoration(
                    label: Text(
                      "name"
                    ),
                  ),
                  validator: (value) {
                    if(value== null || value.isEmpty || value.trim().length<=1 || value.trim().length > 50){
                      return "Must be between 1 and 50 characters.";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _enteredName = value!;
                  } ,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            label: Text(
                              "Quantity"
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          initialValue: _enteredQuantity.toString(),
                          validator: (value){
                            if (value == null || value.isEmpty || int.tryParse(value) == null || int.tryParse(value)! <= 0){
                                return "Must be a valid, positive number";
                            }
                            return null;
                          },
                          onSaved: (value){
                            _enteredQuantity = int.parse(value!);
                          },
                        ),
                      ),
                      const SizedBox(width: 8,),
                      Expanded(
                        child: DropdownButtonFormField(
                          value: _selectedCategory,
                          items:[
                            for (final category in categories.entries)
                            DropdownMenuItem(
                              value: category.value,
                              child: Row(
                                children: [
                                  Container(
                                    height: 16,
                                    width: 16,
                                    color: category.value.color,
                                  ),
                                  SizedBox(width: 8,),
                                  Text(category.value.title),
                                ],
                              )
                            )
                          ], 
                          onChanged: (value){
                            setState(() {
                              _selectedCategory =value!;
                            });
                          }
                        
                        ),
                      )
                    ],
              ),
              const SizedBox(height: 12,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: (){
                    _formKey.currentState!.reset();
                  }, 
                  child: Text("Reset"),
                  ),
                  ElevatedButton(onPressed: _saveItem, child: Text("Add Item"))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}