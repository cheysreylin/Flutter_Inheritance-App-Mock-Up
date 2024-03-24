import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CloseCommunityView extends StatefulWidget {
  const CloseCommunityView({super.key});

  @override
  CloseCommunityViewState createState() => CloseCommunityViewState();
}

class CloseCommunityViewState extends State<CloseCommunityView> {
  //List<Map<String, dynamic>> itemList = [];
  List<Map<String, dynamic>> closeCommunityItemList = [];
  List<String> selectedOptions = []; // Store the selected options here
  // List<Map<String, dynamic>> publicCommunityItemList = [];

  @override
  void initState() {
    super.initState();
    loadItems();
  }

  // In CloseCommunityView
  void loadItems() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> itemListString = prefs.getStringList('itemList') ?? [];

  setState(() {
    closeCommunityItemList = itemListString
      .where((item) =>
          jsonDecode(item)['viewType'] == 'CloseCommunity')
      .map((item) => jsonDecode(item) as Map<String, dynamic>)
      .toList();

      }
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body: Container(
        color: const Color(0xFFedede9),
        child: GridView.builder(
          itemCount: closeCommunityItemList.length,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            mainAxisExtent: 290,
            maxCrossAxisExtent: 300,
            childAspectRatio: 3 / 2,
            ),
          itemBuilder: (context, index) {
            return Card(
              color: const Color.fromARGB(255, 255, 255, 255),
              elevation: 5,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 220,
                      height: 150, // Adjust the height of the inner Container as needed
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: FileImage(
                            File(closeCommunityItemList[index]['image']),
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
                          closeCommunityItemList[index]['name'] ?? '',
                          style: const TextStyle(
                            color: Color.fromARGB(255, 31, 31, 31),
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          'Quantity: ${closeCommunityItemList[index]['quantity']}',
                          style: const TextStyle(
                            color: Color.fromARGB(255, 31, 31, 31),
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Price: ${closeCommunityItemList[index]['price']}',
                          style: const TextStyle(
                            color: Color.fromARGB(255, 31, 31, 31),
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Date: ${closeCommunityItemList[index]['date']}',
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
            );
          },
        ),
      ),
    );
  }
}