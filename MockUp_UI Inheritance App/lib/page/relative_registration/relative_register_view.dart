import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inheritance_app/page/family_chart/test.dart';
import 'package:inheritance_app/utils/text/medium_size.dart';
import 'package:inheritance_app/utils/text/small_size.dart';
import 'package:inheritance_app/utils/theme/theme.dart';

import 'package:inheritance_app/widgets/components/button.dart';
import 'package:inheritance_app/widgets/components/relative_drop_down_item.dart';
import 'package:intl/intl.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RelativeRegisterView extends StatefulWidget {
  const RelativeRegisterView({
    Key? key,
  }) : super(key: key);

  @override
  RelativeRegistrationState createState() => RelativeRegistrationState();
}

class RelativeRegistrationState extends State<RelativeRegisterView> {
  // ignore: non_constant_identifier_names
  final TextEditingController DOBController = TextEditingController();
  List<String> dropdownItems = ['Alive', 'Dead'];
  String imagePath = '';
  final TextEditingController relationshipController = TextEditingController();
  final TextEditingController relativenameController = TextEditingController();
  DateTime? selectedDate;
  final TextEditingController selectedOptionController =
      TextEditingController();

  final TextEditingController statusController = TextEditingController();
  String statusSelectedOption = 'Alive'; // Initialize the selected option
  final TextEditingController storyController = TextEditingController();

  void onOptionSelected(String option) {
    setState(() {
      selectedOptionController.text = option;
    });
  }

  Future<void> getImage(ImageSource source) async {
    // ignore: deprecated_member_use
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
      DOBController.text = DateFormat('yyyy/MM/dd').format(pickedDate);
    }
  }

  void saveRelativeInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final directory = await getApplicationDocumentsDirectory();
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final path = '${directory.path}/$fileName';

    if (imagePath != '') {
      await File(imagePath).copy(path);
    }

    final info = {
      'relative_image': imagePath != '' ? path : '',
      'relative_name': relativenameController.text,
      'relationship': relationshipController.text,
      'DOB': DOBController.text,
      'Dead': statusController.text,
      'story': storyController.text,
    };

    List<String> relativeInfo = prefs.getStringList('relativeInfo') ?? [];
    relativeInfo.add(jsonEncode(info));

    await prefs.setStringList('relativeInfo', relativeInfo);
    //print('Relative Info Saved: $relativeInfor');

    setState(() {
      imagePath = '';
    });
    relativenameController.text = '';
    relationshipController.text = '';
    storyController.text = '';
    DOBController.text = '';
    statusController.text = '';
  }

  void saveItem() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
              'Do you want to proceed with registering your relative information?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Relative's name: ${relativenameController.text}"),
                Text("Relations: ${relationshipController.text}"),
                Text("DOB: ${DOBController.text}"),
                Text("Relative's Status: ${statusController.text}"),
                Text("Thier Story: ${storyController.text}"),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                clearTextFields();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Register'),
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

                // When saving an item
                final item = {
                  'image': imagePath != '' ? path : '',
                  'relativeName': relativenameController.text,
                  'relationship': relationshipController.text,
                  'DOB': DOBController.text,
                  'relativeStatus': statusController.text,
                  'relativeStory': statusController.text,
                };
                // Add the item to the itemList
                List<String> relativeInfoList =
                    prefs.getStringList('relativeInfoList') ?? [];
                relativeInfoList.add(jsonEncode(item));
                await prefs.setStringList('relativeInfoList', relativeInfoList);

                imagePath = '';
                clearTextFields();

                // Return the new data to TreeViewPage.
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TreeViewPage()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void clearTextFields() {
    relativenameController.clear();
    relationshipController.clear();
    storyController.clear();
    DOBController.clear();
    statusController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF7209b7),
      appBar: AppBar(
        backgroundColor: Color(0xFF7209b7),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              LineAwesomeIcons.angle_left,
              color: Colors.white,
            )),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              elevation: 10,
              child: Container(
                width: 310,
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
                  padding: const EdgeInsets.fromLTRB(12, 20, 12, 20),
                  child: Column(
                    children: [
                      imagePath == ''
                          ? Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: MediumText(
                                text: "Upload your relative's image",
                                color: AppColor.White,
                              ),
                            )
                          : Image.file(File(imagePath)),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButtonStyling(
                                textColor: AppColor.Brown,
                                color: AppColor.White,
                                width: 120,
                                height: 40,
                                text: "Camera",
                                onPressed: () => getImage(ImageSource.camera)),
                            TextButtonStyling(
                                textColor: AppColor.Brown,
                                color: AppColor.White,
                                width: 120,
                                height: 40,
                                text: "File Upload",
                                onPressed: () => getImage(ImageSource.gallery)),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 17),
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(00),
                          topRight: Radius.circular(40)),
                      boxShadow: [
                        BoxShadow(
                            color: Color(0xFF354f52),
                            blurRadius: 2.0,
                            offset: Offset(0, -2))
                      ],
                    ),
                    child: Card(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(00),
                              topRight: Radius.circular(45))),
                      color: Color.fromARGB(255, 255, 255, 255),
                      margin: const EdgeInsets.all(0),
                      elevation: 3,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(27.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // SmallText(
                              //   text: "Enter your relative's name",
                              //   color: AppColor.White,
                              // ),
                              TextFormField(
                                controller: relativenameController,
                                decoration: InputDecoration(
                                  suffixIcon: Icon(
                                    Icons.person,
                                    color: AppColor.LightBrown,
                                  ),
                                  hintText: "Enter relative's name",
                                  hintStyle: TextStyle(
                                      fontSize: 14, color: AppColor.LightBrown),
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 13),
                                  prefixText: '     ',
                                  filled: true,
                                  fillColor: Colors.white,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(
                                        color: Color(0xFF4C0082), width: 1.0),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(0xFF4C0082), width: 1.0),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Enter relative's name";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 30),
                              // SmallText(
                              //   text: "Your relative's relationship with you",
                              //   color: AppColor.White,
                              // ),
                              TextFormField(
                                controller: relationshipController,
                                decoration: InputDecoration(
                                  suffixIcon: Icon(
                                    Icons.people,
                                    color: AppColor.LightBrown,
                                  ),
                                  hintText: "Enter relative's relationship",
                                  hintStyle: TextStyle(
                                      fontSize: 14, color: AppColor.LightBrown),
                                  prefixText: '     ',
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 13),
                                  filled: true,
                                  fillColor: Colors.white,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(
                                        color: Color(0xFF4C0082), width: 1.0),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(0xFF4C0082), width: 1.0),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Enter relation's relation";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    // Add Expanded here
                                    child: Column(
                                      children: [
                                        Container(
                                          alignment: Alignment.topLeft,
                                          child: const SmallText(
                                            color: Colors.black,
                                            text: "Date of Birth",
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () => pickDate(context),
                                          child: AbsorbPointer(
                                            child: TextFormField(
                                              textAlign: TextAlign.center,
                                              controller: DOBController,
                                              decoration: InputDecoration(
                                                hintText: "Choose Date",
                                                suffixIcon: Icon(
                                                  Icons.date_range,
                                                  color: AppColor.LightBrown,
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  borderSide: const BorderSide(
                                                      color: Color(0xFF4C0082),
                                                      width: 1.0),
                                                ),
                                                focusedBorder:
                                                    const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Color(0xFF4C0082),
                                                      width: 1.0),
                                                ),
                                                prefixText: '  ',
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 13),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                filled: true,
                                                fillColor: Colors.white,
                                              ),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return "...";
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    // Add Expanded here
                                    child: Column(
                                      children: [
                                        Container(
                                          alignment: Alignment.topLeft,
                                          child: const SmallText(
                                            color: Colors.black,
                                            text: "Current Status ?",
                                          ),
                                        ),
                                        Container(
                                          height: 50,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                width: 1,
                                                color: AppColor.Purple,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: RelativeDropdownItems(
                                            dropdownValue: statusSelectedOption,
                                            items: dropdownItems,
                                            onOptionSelected: (selectedOption) {
                                              setState(() {
                                                statusSelectedOption =
                                                    selectedOption;
                                                selectedOptionController.text =
                                                    selectedOption;
                                                // check the selection and let user set the date accordingly
                                                if (selectedOption == "Alive") {
                                                  // set the latest date
                                                  statusController.text =
                                                      DateFormat('yyyy-MM-dd')
                                                          .format(
                                                              DateTime.now());
                                                  selectedDate =
                                                      null; // Clear the selectedDate when user selects "Alive"
                                                } else if (selectedOption ==
                                                    'Dead') {
                                                  // Show the date picker when "Dead" is selected
                                                  showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime.now(),
                                                    firstDate: DateTime(1900),
                                                    lastDate: DateTime.now(),
                                                  ).then((pickedDate) {
                                                    if (pickedDate != null) {
                                                      setState(() {
                                                        selectedDate =
                                                            pickedDate;
                                                        String formattedDate =
                                                            DateFormat(
                                                                    'yyyy-MM-dd')
                                                                .format(
                                                                    selectedDate!);
                                                        statusController.text =
                                                            formattedDate;
                                                      });
                                                    }
                                                  });
                                                }
                                              });
                                            },
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        if (selectedOptionController.text ==
                                            'Dead')
                                          TextField(
                                            textAlign: TextAlign.center,
                                            controller: statusController,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 13),
                                              filled: true,
                                              fillColor: Colors.white,
                                              border:
                                                  const OutlineInputBorder(),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                borderSide: const BorderSide(
                                                    color: Color(0xFF4C0082),
                                                    width: 1.0),
                                              ),
                                              focusedBorder:
                                                  const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xFF4C0082),
                                                    width: 1.0),
                                              ),
                                            ),
                                          ),
                                        if (selectedOptionController.text ==
                                            'Alive')
                                          TextField(
                                            textAlign: TextAlign.center,
                                            controller: statusController,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 13),
                                              border:
                                                  const OutlineInputBorder(),
                                              filled: true,
                                              fillColor: Colors.white,
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                borderSide: const BorderSide(
                                                    color: Color(0xFF4C0082),
                                                    width: 1.0),
                                              ),
                                              focusedBorder:
                                                  const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xFF4C0082),
                                                    width: 1.0),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              // SmallText(
                              //   text: "Enter his/her story",
                              //   color: AppColor.White,
                              // ),
                              TextFormField(
                                controller: storyController,
                                maxLines: 5,
                                // minLines: 1,
                                decoration: InputDecoration(
                                  hintText: "Enter his/her story...",
                                  hintStyle: TextStyle(
                                      fontSize: 14, color: AppColor.LightBrown),
                                  prefixText: '     ',
                                  contentPadding:
                                      const EdgeInsets.symmetric(vertical: 13),
                                  filled: true,
                                  fillColor: Colors.white,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(
                                        color: Color(0xFF4C0082), width: 1.0),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(0xFF4C0082), width: 1.0),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Enter your relaltive story";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  TextButtonStyling(
                                      textColor: AppColor.White,
                                      color: AppColor.Red,
                                      width: 140,
                                      height: 40,
                                      text: "Cancel",
                                      onPressed: clearTextFields),
                                  TextButtonStyling(
                                    textColor: AppColor.White,
                                    color: AppColor.Purple,
                                    width: 140,
                                    height: 40,
                                    text: "Register",
                                    onPressed: () {
                                      saveItem(); // Call the saveItem function first
                                    },
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
