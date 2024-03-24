import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:inheritance_app/utils/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FamilyTreeView extends StatefulWidget {
  const FamilyTreeView({super.key});

  @override
  FamilyTreeViewState createState() => FamilyTreeViewState();
}

class FamilyTreeViewState extends State<FamilyTreeView> {
  List<Map<String, dynamic>> relativeInfoSaved = [];
  bool isSwitched = true;

  @override
  void initState() {
    super.initState();
    loadRelativeInfo();
  }

  void loadRelativeInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> infoListString = prefs.getStringList("relativeInfoList") ?? [];

    List<Map<String, dynamic>> updatedRelativeInfo = infoListString
        .map((relativeInfo) => jsonDecode(relativeInfo) as Map<String, dynamic>)
        .toList();

    setState(() {
      relativeInfoSaved = updatedRelativeInfo;
    });
  }

  void deleteRelative(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> infoListString = prefs.getStringList("relativeInfoList") ?? [];

    infoListString.removeAt(index);
    await prefs.setStringList("relativeInfoList", infoListString);

    loadRelativeInfo(); // Refresh the UI after deletion
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.Purple,
        actions: [
          Transform.scale(
            scale: 0.65,
            child: Switch(
              value: isSwitched,
              onChanged: (value) {
                setState(() {
                  isSwitched = value;
                });
              },
              activeColor: Colors.white,
              inactiveThumbColor: AppColor.Purple,
            ),
          ),
        ],
      ),
      body: GridView.builder(
        itemCount: relativeInfoSaved.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.5,
        ),
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => const RelativeRegisterView(),
              //   ),
              // );
            },
            child: Card(
              color: isSwitched ? Colors.white : AppColor.Purple,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 70,
                          height: 70,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.file(
                              File(relativeInfoSaved[index]['image']),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${relativeInfoSaved[index]['relationship']}",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: isSwitched
                                      ? AppColor.Purple
                                      : Colors.white,
                                ),
                              ),
                              Text(
                                relativeInfoSaved[index]['relativeName'] +
                                    " | " +
                                    "${relativeInfoSaved[index]['Dead'] == 'Dead' ? "Dead" : "Alive"}",
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ButtonBar(
                            buttonPadding: EdgeInsets.zero,
                            children: <Widget>[
                              TextButton.icon(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.edit,
                                  size: 16,
                                  color: isSwitched
                                      ? AppColor.Purple
                                      : Colors.white,
                                ),
                                label: Text(
                                  'Edit',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isSwitched
                                        ? AppColor.Purple
                                        : Colors.white,
                                  ),
                                ),
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                      const EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 6)),
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                                      if (states
                                          .contains(MaterialState.pressed)) {
                                        return Colors.grey;
                                      }
                                      return Colors.transparent;
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 2.0),
                                child: TextButton.icon(
                                  onPressed: () {
                                    deleteRelative(index);
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    size: 16,
                                    color: isSwitched
                                        ? AppColor.Purple
                                        : Colors.white,
                                  ),
                                  label: Text(
                                    'Delete',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isSwitched
                                          ? AppColor.Purple
                                          : Colors.white,
                                    ),
                                  ),
                                  style: ButtonStyle(
                                    padding: MaterialStateProperty.all(
                                        const EdgeInsets.symmetric(
                                            vertical: 4, horizontal: 6)),
                                    backgroundColor: MaterialStateProperty
                                        .resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                        if (states
                                            .contains(MaterialState.pressed)) {
                                          return Colors.grey;
                                        }
                                        return Colors.transparent;
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
