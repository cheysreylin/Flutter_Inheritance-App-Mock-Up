import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:inheritance_app/utils/theme/theme.dart';
import 'package:inheritance_app/widgets/components/button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrivateView extends StatefulWidget {
  const PrivateView({super.key});

  @override
  PrivateViewState createState() => PrivateViewState();
}

class PrivateViewState extends State<PrivateView> {
  //List<Map<String, dynamic>> itemList = [];

  // In PrivateView
  List<Map<String, dynamic>> privateItemList = [];

  @override
  void initState() {
    super.initState();
    loadItems();
  }

  // In PrivateView
  void loadItems() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> itemListString = prefs.getStringList('itemList') ?? [];

    setState(() {
      privateItemList = itemListString
          .where((item) => jsonDecode(item)['viewType'] == 'private')
          .map((item) => jsonDecode(item) as Map<String, dynamic>)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Container(
        color: const Color(0xFFedede9),
        child: GridView.builder(
          itemCount: privateItemList.length,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            mainAxisExtent: 290,
            maxCrossAxisExtent: 300,
            childAspectRatio: 3 / 2,
          ),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap:() {
                showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Container(
        
                      height: 145.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: const Color(0xFFFFFF),
                        borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButtonStyling(
                            color: AppColor.Purple, 
                            width: 180, 
                            height: 30, 
                            text: "Favourite", 
                            textColor: AppColor.White,
                            icon: Icons.favorite,
                            iconColor: AppColor.White,
                          ),
                          TextButtonStyling(
                            color: AppColor.Blue, 
                            width: 180, 
                            height: 30, 
                            text: "Edit", 
                            textColor: AppColor.White,
                            icon: Icons.edit,
                            iconColor: AppColor.White,
                          ),
                          TextButtonStyling(
                            color: AppColor.Red, 
                            width: 180, 
                            height: 30, 
                            text: "Delete", 
                            textColor: AppColor.White,
                            icon: Icons.delete,
                            iconColor: AppColor.White,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
              },
              child: Card(
                color: const Color.fromARGB(255, 255, 255, 255),
                elevation: 5,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 220,
                        height:
                            150, // Adjust the height of the inner Container as needed
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: FileImage(
                              File(privateItemList[index]['image']),
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            privateItemList[index]['name'] ?? '',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 31, 31, 31),
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            'Quantity: ${privateItemList[index]['quantity']}',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 31, 31, 31),
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Price: ${privateItemList[index]['price']}',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 31, 31, 31),
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Date: ${privateItemList[index]['date']}',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 31, 31, 31),
                              fontSize: 16,
                            ),
                          ),
                          // Text(
                          //   'Option: ${publicCommunityItemList[index]['option']}',
                          //   style: const TextStyle(
                          //     color: Colors.white,
                          //     fontSize: 16,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
  
}
