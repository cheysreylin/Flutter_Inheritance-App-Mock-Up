import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inheritance_app/utils/text/medium_size.dart';
import 'package:inheritance_app/utils/text/small_size.dart';
import 'package:inheritance_app/utils/theme/theme.dart';
import 'package:inheritance_app/widgets/components/button.dart';
import 'package:inheritance_app/widgets/components/multi_selection.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UploadView extends StatefulWidget {
  const UploadView({Key? key}) : super(key: key);

  @override
  UploadViewState createState() => UploadViewState();
}

class UploadViewState extends State<UploadView> {
  // Private and Close Community and Open Community
  List<Map<String, dynamic>> AllOptionsItemList = [];

  // Close Community and  OpenCommunity
  List<Map<String, dynamic>> closeAndopenCommunityItemList = [];

  // In CloseCommunityView
  List<Map<String, dynamic>> closeCommunityItemList = [];

  final TextEditingController dateController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String imagePath = '';
  final TextEditingController nameController = TextEditingController();
  final numericFormatter = FilteringTextInputFormatter.allow(RegExp(r'[0-9]'));
  // In PublicCommunityView
  List<Map<String, dynamic>> openCommunityItemList = [];

  final TextEditingController priceController = TextEditingController();
  // In Private and OpenCommunity
  List<Map<String, dynamic>> privateAndOpenItemList = [];

  // In Private and Close Community
  List<Map<String, dynamic>> privateAndcloseCommunityItemList = [];

  // In PrivateView
  List<Map<String, dynamic>> privateItemList = [];

  final TextEditingController quantityController = TextEditingController();

  List<String> _selectedItems = [];
  // Add this function to add ¥ sign to price
  final _yenSignFormatter =
      TextInputFormatter.withFunction((oldValue, newValue) {
    if (newValue.text.length == 1 && newValue.text != '¥') {
      return TextEditingValue(
        text: '¥${newValue.text}',
        selection: TextSelection.collapsed(offset: newValue.selection.end + 1),
      );
    }
    return newValue;
  });

  Future<void> getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().getImage(source: source);

    setState(() {
      if (pickedFile != null) {
        imagePath = pickedFile.path;
      }
    });
  }

  Future<void> pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      dateController.text = DateFormat('yyyy/MM/dd').format(pickedDate);
    }
  }

  void clearTextFields() {
    nameController.clear();
    quantityController.clear();
    priceController.clear();
    dateController.clear();
  }

  void saveItem() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Do you want to proceed with uploading your item?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Item's name: ${nameController.text}"),
                Text("Item's quantity: ${quantityController.text}"),
                Text("Item's price: ${priceController.text}"),
                Text("Item's selling date: ${dateController.text}"),
                Text("Item's selling option: $_selectedItems"),
              ],
            ),
          ),
          actions: <Widget>[
            TextButtonStyling(
              color: AppColor.Red, 
              width: 100, 
              height: 35, 
              text: "Cancel", 
              textColor: AppColor.White, 
              onPressed: () {
                clearTextFields();
                Navigator.of(context).pop();
              },
            ),
            TextButtonStyling(
              color: AppColor.Purple, 
              width: 100, 
              height: 35, 
              text: "Submit", 
              textColor: AppColor.White, 
              onPressed: () async {
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                final directory = await getApplicationDocumentsDirectory();
                final fileName =
                    DateTime.now().millisecondsSinceEpoch.toString();
                final path = '${directory.path}/$fileName';

                if (imagePath != '') {
                  await File(imagePath).copy(path);
                }

                // String viewType = "";
                List<String> itemList = prefs.getStringList('itemList') ?? [];

                if (_selectedItems.contains("Private") &&
                    _selectedItems.contains("Close Community") &&
                    _selectedItems.contains("Open Community")) {
                  final item1 = {
                    'image': imagePath != '' ? path : '',
                    'name': nameController.text,
                    'quantity': quantityController.text,
                    'price': priceController.text,
                    'date': dateController.text,
                    'option': _selectedItems,
                    'viewType': "private"
                  };
                  itemList.add(jsonEncode(item1));
                  final item2 = {
                    'image': imagePath != '' ? path : '',
                    'name': nameController.text,
                    'quantity': quantityController.text,
                    'price': priceController.text,
                    'date': dateController.text,
                    'option': _selectedItems,
                    'viewType': "CloseCommunity"
                  };
                  itemList.add(jsonEncode(item2));
                  final item3 = {
                    'image': imagePath != '' ? path : '',
                    'name': nameController.text,
                    'quantity': quantityController.text,
                    'price': priceController.text,
                    'date': dateController.text,
                    'option': _selectedItems,
                    'viewType': "OpenCommunity"
                  };
                  itemList.add(jsonEncode(item3));

                  await prefs.setStringList('itemList', itemList);
                } else if (_selectedItems.contains("Close Community") &&
                    _selectedItems.contains("Open Community")) {
                  final item1 = {
                    'image': imagePath != '' ? path : '',
                    'name': nameController.text,
                    'quantity': quantityController.text,
                    'price': priceController.text,
                    'date': dateController.text,
                    'option': _selectedItems,
                    'viewType': "CloseCommunity"
                  };
                  itemList.add(jsonEncode(item1));

                  final item2 = {
                    'image': imagePath != '' ? path : '',
                    'name': nameController.text,
                    'quantity': quantityController.text,
                    'price': priceController.text,
                    'date': dateController.text,
                    'option': _selectedItems,
                    'viewType': "OpenCommunity"
                  };
                  itemList.add(jsonEncode(item2));

                  // Add the item to the itemList
                  await prefs.setStringList('itemList', itemList);
                } else if (_selectedItems.contains("Close Community") &&
                    _selectedItems.contains("Private")) {
                  final item1 = {
                    'image': imagePath != '' ? path : '',
                    'name': nameController.text,
                    'quantity': quantityController.text,
                    'price': priceController.text,
                    'date': dateController.text,
                    'option': _selectedItems,
                    'viewType': "CloseCommunity"
                  };
                  itemList.add(jsonEncode(item1));

                  final item2 = {
                    'image': imagePath != '' ? path : '',
                    'name': nameController.text,
                    'quantity': quantityController.text,
                    'price': priceController.text,
                    'date': dateController.text,
                    'option': _selectedItems,
                    'viewType': "private"
                  };
                  itemList.add(jsonEncode(item2));

                  // Add the item to the itemList
                  await prefs.setStringList('itemList', itemList);
                } else if (_selectedItems.contains("Private") &&
                    _selectedItems.contains("Open Community")) {
                  final item1 = {
                    'image': imagePath != '' ? path : '',
                    'name': nameController.text,
                    'quantity': quantityController.text,
                    'price': priceController.text,
                    'date': dateController.text,
                    'option': _selectedItems,
                    'viewType': "OpenCommunity"
                  };
                  itemList.add(jsonEncode(item1));

                  final item2 = {
                    'image': imagePath != '' ? path : '',
                    'name': nameController.text,
                    'quantity': quantityController.text,
                    'price': priceController.text,
                    'date': dateController.text,
                    'option': _selectedItems,
                    'viewType': "private"
                  };
                  itemList.add(jsonEncode(item2));

                  // Add the item to the itemList
                  await prefs.setStringList('itemList', itemList);
                } else if (_selectedItems.contains("Open Community")) {
                  final item1 = {
                    'image': imagePath != '' ? path : '',
                    'name': nameController.text,
                    'quantity': quantityController.text,
                    'price': priceController.text,
                    'date': dateController.text,
                    'option': _selectedItems,
                    'viewType': "OpenCommunity"
                  };
                  itemList.add(jsonEncode(item1));

                  await prefs.setStringList('itemList', itemList);
                } else if (_selectedItems.contains("Close Community")) {
                  final item1 = {
                    'image': imagePath != '' ? path : '',
                    'name': nameController.text,
                    'quantity': quantityController.text,
                    'price': priceController.text,
                    'date': dateController.text,
                    'option': _selectedItems,
                    'viewType': "OpenCommunity"
                  };
                  itemList.add(jsonEncode(item1));
                  await prefs.setStringList('itemList', itemList);
                } else if (_selectedItems.contains("Private Community")) {
                  final item1 = {
                    'image': imagePath != '' ? path : '',
                    'name': nameController.text,
                    'quantity': quantityController.text,
                    'price': priceController.text,
                    'date': dateController.text,
                    'option': _selectedItems,
                    'viewType': "private"
                  };
                  itemList.add(jsonEncode(item1));
                  await prefs.setStringList('itemList', itemList);

                  await prefs.setStringList('itemList', itemList);
                } else if (_selectedItems.contains("Close Community") &&
                    _selectedItems.contains("Open Community")) {
                  final item1 = {
                    'image': imagePath != '' ? path : '',
                    'name': nameController.text,
                    'quantity': priceController.text,
                    'price': priceController.text,
                    'date': dateController.text,
                    'option': _selectedItems,
                    'viewType': "CloseCommunity"
                  };
                  itemList.add(jsonEncode(item1));

                  final item2 = {
                    'image': imagePath != '' ? path : '',
                    'name': nameController.text,
                    'quantity': priceController.text,
                    'price': priceController.text,
                    'date': dateController.text,
                    'option': _selectedItems,
                    'viewType': "OpenCommunity"
                  };
                  itemList.add(jsonEncode(item2));

                  // Add the item to the itemList
                  await prefs.setStringList('itemList', itemList);
                } else if (_selectedItems.contains("Close Community") &&
                    _selectedItems.contains("Private")) {
                  final item1 = {
                    'image': imagePath != '' ? path : '',
                    'name': nameController.text,
                    'quantity': priceController.text,
                    'price': priceController.text,
                    'date': dateController.text,
                    'option': _selectedItems,
                    'viewType': "CloseCommunity"
                  };
                  itemList.add(jsonEncode(item1));

                  final item2 = {
                    'image': imagePath != '' ? path : '',
                    'name': nameController.text,
                    'quantity': priceController.text,
                    'price': priceController.text,
                    'date': dateController.text,
                    'option': _selectedItems,
                    'viewType': "private"
                  };
                  itemList.add(jsonEncode(item2));

                  // Add the item to the itemList
                  await prefs.setStringList('itemList', itemList);
                } else if (_selectedItems.contains("Private") &&
                    _selectedItems.contains("Open Community")) {
                  final item1 = {
                    'image': imagePath != '' ? path : '',
                    'name': nameController.text,
                    'quantity': priceController.text,
                    'price': priceController.text,
                    'date': dateController.text,
                    'option': _selectedItems,
                    'viewType': "OpenCommunity"
                  };
                  itemList.add(jsonEncode(item1));

                  final item2 = {
                    'image': imagePath != '' ? path : '',
                    'name': nameController.text,
                    'quantity': priceController.text,
                    'price': priceController.text,
                    'date': dateController.text,
                    'option': _selectedItems,
                    'viewType': "private"
                  };
                  itemList.add(jsonEncode(item2));

                  // Add the item to the itemList
                  await prefs.setStringList('itemList', itemList);
                } else if (_selectedItems.contains("Open Community")) {
                  final item1 = {
                    'image': imagePath != '' ? path : '',
                    'name': nameController.text,
                    'quantity': priceController.text,
                    'price': priceController.text,
                    'date': dateController.text,
                    'option': _selectedItems,
                    'viewType': "OpenCommunity"
                  };
                  itemList.add(jsonEncode(item1));

                  await prefs.setStringList('itemList', itemList);
                } else if (_selectedItems.contains("Close Community")) {
                  final item1 = {
                    'image': imagePath != '' ? path : '',
                    'name': nameController.text,
                    'quantity': priceController.text,
                    'price': priceController.text,
                    'date': dateController.text,
                    'option': _selectedItems,
                    'viewType': "OpenCommunity"
                  };
                  itemList.add(jsonEncode(item1));
                  await prefs.setStringList('itemList', itemList);
                } else if (_selectedItems.contains("Private")) {
                  final item1 = {
                    'image': imagePath != '' ? path : '',
                    'name': nameController.text,
                    'quantity': priceController.text,
                    'price': priceController.text,
                    'date': dateController.text,
                    'option': _selectedItems,
                    'viewType': "private"
                  };
                  itemList.add(jsonEncode(item1));
                  await prefs.setStringList('itemList', itemList);
                }

                imagePath = '';
                clearTextFields();
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showMultiOptionSelect() async {
    final List<String> items = ["Private", "Close Community", "Open Community"];
    final List<String>? results = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return MultiSelectionOption(
            items: items,
          );
        });

    // update the UI
    if (results != null && results.isNotEmpty) {
      setState(() {
        _selectedItems = results;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.Purple,
        toolbarHeight: 80,
        title: Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                        "https://media.licdn.com/dms/image/D5603AQEZaSwvW_9Izw/profile-displayphoto-shrink_800_800/0/1687784508908?e=2147483647&v=beta&t=RdbIgobDt7NTamSe5sxpiH71HZPZktbtxQg2UpnGE_U"),
                  ),
                  SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SmallText(
                        text: "Hello, ",
                        color: Colors.white,
                      ),
                      MediumText(
                        text: "Chey Sreylin",
                        color: Colors.white,
                      )
                    ],
                  )
                ],
              ),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.notifications,
                    color: Colors.white,
                  ))
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Card(
                elevation: 10,
                child: Container(
                  width: 320,
                  // height: 140,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 80, 6, 107),
                          Color.fromARGB(255, 31, 3, 48),
                        ],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      )),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 20, 12, 0),
                    child: Column(
                      children: [
                        imagePath == ''
                            ? MediumText(
                                text: "Upload your relative's image",
                                color: AppColor.White,
                              )
                            : Image.file(File(imagePath)),
                        const SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 15, 10, 22),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButtonStyling(
                                  textColor: AppColor.Brown,
                                  color: AppColor.White,
                                  width: 120,
                                  height: 40,
                                  text: "Camera",
                                  onPressed: () =>
                                      getImage(ImageSource.camera)),
                              TextButtonStyling(
                                  textColor: AppColor.Brown,
                                  color: AppColor.White,
                                  width: 120,
                                  height: 40,
                                  text: "File Upload",
                                  onPressed: () =>
                                      getImage(ImageSource.gallery)),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Form(
                key: formKey,
                child: Card(
                  color: Color.fromARGB(255, 255, 255, 255),
                  shadowColor: Colors.black,
                  elevation: 10,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(26.0, 0, 26, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: nameController,
                              decoration: const InputDecoration(
                                suffixIcon: Icon(Icons.add_shopping_cart, color: Color.fromARGB(255, 150, 150, 150)),
                                hintText: "Enter item's name",
                                hintStyle: TextStyle(fontSize: 14, color: Color.fromARGB(255, 150, 150, 150)),
                                prefixText: '     ',
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 13),
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Enter item's name";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            
                            TextFormField(
                              controller: quantityController,
                              decoration: const InputDecoration(
                                suffixIcon: Icon(Icons.shopping_cart, color: Color.fromARGB(255, 150, 150, 150)),
                                hintText: "Enter item's quantity",
                                hintStyle: TextStyle(fontSize: 14, color: Color.fromARGB(255, 150, 150, 150)),
                                prefixText: '     ',
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 13),
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                numericFormatter
                              ], // Use the numeric formatter here
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Enter item's quantity";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: priceController,
                              decoration: const InputDecoration(
                                suffixIcon: Icon(Icons.price_change, color: Color.fromARGB(255, 150, 150, 150)),
                                hintText: "Enter item's selling price",
                                hintStyle: TextStyle(fontSize: 14, color: Color.fromARGB(255, 150, 150, 150)),
                                prefixText: '     ',
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 13),
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              // Add the formatter here
                              inputFormatters: [_yenSignFormatter],
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    !value.startsWith('¥')) {
                                  return "Enter item's price";
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 20),
                            
                            GestureDetector(
                              onTap: () => pickDate(context),
                              child: AbsorbPointer(
                                child: TextFormField(
                                  controller: dateController,
                                  decoration: const InputDecoration(
                                    suffixIcon: Icon(Icons.date_range, color: Color.fromARGB(255, 150, 150, 150)),
                                    hintText: "Enter item's selling date",
                                    hintStyle: TextStyle(fontSize: 14, color: Color.fromARGB(255, 150, 150, 150)),
                                    prefixText: '     ',
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 13),
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Enter item's selling date";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextButtonStyling(
                              color: AppColor.Purple,
                              width: 60,
                              height: 30,
                              text: "Select your selling Options",
                              onPressed: _showMultiOptionSelect,
                              textColor: AppColor.White,
                            ),
                            const Divider(
                              height: 10,
                            ),
                            // display selected items
                            Text(
                              " ${_selectedItems.join(', ')}",
                            ),

                            const SizedBox(height: 4),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 26),
                                child: TextButtonStyling(
                                    textColor: AppColor.White,
                                    onPressed: saveItem,
                                    color: AppColor.Purple,
                                    width: 140,
                                    height: 45,
                                    text: "Upload Item"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
