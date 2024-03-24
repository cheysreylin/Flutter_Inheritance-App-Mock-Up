import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:inheritance_app/utils/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PublicView extends StatefulWidget {
  const PublicView({super.key});

  @override
  PublicViewState createState() => PublicViewState();
}

class PublicViewState extends State<PublicView> {
  List<Map<String, dynamic>> publicCommunityItemList = [];
  List<String> selectedOptions = []; // Store the selected options here

  @override
  void initState() {
    super.initState();
    loadItems();
  }

  // In CloseCommunityView
  void loadItems() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> itemListString = prefs.getStringList('itemList') ?? [];
    // List<Map<String, dynamic>> closeCommunityItemList = [];

    setState(() {
      publicCommunityItemList = itemListString
          .where((item) => jsonDecode(item)['viewType'] == 'OpenCommunity')
          .map((item) => jsonDecode(item) as Map<String, dynamic>)
          .toList();
    });
    print("Public community ${publicCommunityItemList}");
  }

  @override
  Widget build(BuildContext context) {
    // final TextEditingController searchController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: AppColor.Purple,
        title: Padding(
          padding: const EdgeInsets.fromLTRB(5, 20, 5, 25),
          child: TextField(
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 13),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                suffixIcon: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide:
                        const BorderSide(width: 1, color: Colors.white)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide:
                        const BorderSide(width: 1, color: Colors.white)),
                hintText: "Search",
                border: InputBorder.none,
                hintStyle: TextStyle(color: AppColor.White)),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.notifications,
                  color: AppColor.White,
                )),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Container(
          color: const Color(0xFFedede9),
          child: GridView.builder(
            itemCount: publicCommunityItemList.length,
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
                        height:
                            150, // Adjust the height of the inner Container as needed
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: FileImage(
                              File(publicCommunityItemList[index]['image']),
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
                            publicCommunityItemList[index]['name'] ?? '',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 31, 31, 31),
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            'Quantity: ${publicCommunityItemList[index]['quantity']}',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 31, 31, 31),
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Price: ${publicCommunityItemList[index]['price']}',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 31, 31, 31),
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Date: ${publicCommunityItemList[index]['date']}',
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
      ),
    );
  }
}
