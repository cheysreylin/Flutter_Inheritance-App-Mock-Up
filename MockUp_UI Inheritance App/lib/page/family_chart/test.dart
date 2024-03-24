import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';
import 'package:inheritance_app/page/relative_registration/relative_register_view.dart';
import 'package:inheritance_app/utils/text/medium_size.dart';
import 'package:inheritance_app/utils/text/small_size.dart';
import 'package:inheritance_app/utils/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';


// Define a class to hold relative information
class RelativeInfo {
  String relativeImage;
  String relativeName;

  RelativeInfo({required this.relativeImage, required this.relativeName});
}

class TreeViewPage extends StatefulWidget {
  @override
  _TreeViewPageState createState() => _TreeViewPageState();
}

class _TreeViewPageState extends State<TreeViewPage> {
  BuchheimWalkerConfiguration builder = BuchheimWalkerConfiguration();
  bool canAddSingleChild = false;
  int childNodeCount = 0;
  final Graph graph = Graph()..isTree = true;
  List<Map<String, dynamic>> relativeInfoSaved = [];

  double _scale = 1.0;

  @override
  void initState() {
    super.initState();
    loadRelativeInfo();

    final node1 = Node.Id(1);
    graph.addNode(node1);

    // Grand Parent Mother side
    final node2 = Node.Id(2);
    final node3 = Node.Id(3);
    graph.addEdge(node1, node2);
    graph.addEdge(node1, node3);

    // Grand Parent Father side
    final node4 = Node.Id(4);
    final node5 = Node.Id(5);
    graph.addEdge(node1, node4);
    graph.addEdge(node1, node5);

    // Mother
    final node6 = Node.Id(6);
    graph.addEdge(node2, node6);
    graph.addEdge(node3, node6);

    // // Father
    final node7 = Node.Id(7);
    graph.addEdge(node4, node7);
    graph.addEdge(node5, node7);

    // // User
    final node8 = Node.Id(8);
    graph.addEdge(node6, node8);
    graph.addEdge(node7, node8);

    builder
  ..siblingSeparation = (30)
  ..levelSeparation = (50)
  ..subtreeSeparation = (12)
  ..orientation = (BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM);

  }

 
  void loadRelativeInfo() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> infoListString = prefs.getStringList("relativeInfoList") ?? [];

  setState(() {
    relativeInfoSaved = infoListString
        .map((relativeInfo) => jsonDecode(relativeInfo) as Map<String, dynamic>)
        .toList();
  });
}


  void deleteRelative(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> infoListString = prefs.getStringList("relativeInfoList") ?? [];

    infoListString.removeAt(index);
    await prefs.setStringList("relativeInfoList", infoListString);

    loadRelativeInfo(); // Refresh the UI after deletion
  }

  Widget rectangleWidget(Node node) {
    bool isFirstNode = node.key!.value == 1;
    if (isFirstNode) {
      return Column(
        children: [
          ElevatedButton(
            onPressed: () {
              final newNode1 = Node.Id(graph.nodeCount() + 1);
              graph.addEdge(node, newNode1);
              canAddSingleChild = true; // Allow adding a single child node below
              setState(() {});
            },
            child: Text('Click to create family chart'),
          ),
        ],
      );
    }
    else {
      if (relativeInfoSaved.isNotEmpty) {
        final relativeInfo = relativeInfoSaved;
        return Column(
          children: [
            Wrap(
              children: List.generate(1, (index) {
                final relativeInfo = relativeInfoSaved[index];
                return GestureDetector(
                  onTap: () async{
                    final newData = await Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => RelativeRegisterView())
                    );

                    // When you receive new data from RelativeRegisterView:
                    if (newData != null) {
                      setState(() {
                        // Add the new data to your list.
                        relativeInfoSaved.add(newData);
                      });
                    }
                  },
                  child: Card(
                    elevation: 5,
                    child: Container(
                      width: 135,
                      height: 167,
                      child: Stack(
                        children: [
                          // Add card content here
                          Column(
                            children: [
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(9, 20, 9, 0),
                                  child: SizedBox(
                                    height: 90,
                                    width: 90,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Image.file(
                                        File(relativeInfo['image']),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 1),
                                    Center(child: Text(relativeInfo['relativeName'])),
                                  ],
                                ),
                              ),
                               Padding(
                                padding: EdgeInsets.fromLTRB(0, 3, 0, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 1),
                                    Center(child: Text(relativeInfo['relationship'])),
                                  ],
                                ),
                              ),
                              //  Padding(
                              //   padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                              //   child: Column(
                              //     crossAxisAlignment: CrossAxisAlignment.start,
                              //     children: [
                              //       SizedBox(height: 1),
                              //       Center(child: Text(relativeInfo['DOB'])),
                              //     ],
                              //   ),
                              // ),
                              // Padding(
                              //   padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                              //   child: Column(
                              //     crossAxisAlignment: CrossAxisAlignment.start,
                              //     children: [
                              //       SizedBox(height: 1),
                              //       Center(child: Text(relativeInfo['relativeStatus'])),
                              //     ],
                              //   ),
                              // ),
                              // Padding(
                              //   padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                              //   child: Column(
                              //     crossAxisAlignment: CrossAxisAlignment.start,
                              //     children: [
                              //       SizedBox(height: 1),
                              //       Center(child: Text(relativeInfo['relativeStory'])),
                              //     ],
                              //   ),
                              // ),
                            ],
                          ),
                          
                          Positioned(
                            top: -8,
                            right: -5,
                            child: IconButton(
                              icon: Icon(
                                Icons.edit,
                                size: 18,
                                weight: 32,
                                color: AppColor.Purple,
                              ),
                              onPressed: () {}
                            ),
                          ),
                          Positioned(
                            top: -8,
                            right: 92,
                            child: IconButton(
                              icon: const Icon(
                                Icons.delete,
                                size: 18,
                                weight: 32,
                                color: Color.fromARGB(255, 163, 24, 14),
                              ),
                              onPressed: () {
                                setState(() {
                                  graph.removeNode(node);
                                });
                              },
                            ),
                          ), 
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),

            ElevatedButton(
              onPressed: () {
                final newNode = Node.Id(graph.nodeCount() + 1);
                graph.addEdge(node, newNode);
                setState(() {});
              },
              child: Text('Add child'),
            ),
          ],
        );
      } 
      
      
      else {
        return Column(
          children: [
            GestureDetector(
              onTap: () {
                // Navigator.push(
                //   context, 
                //   MaterialPageRoute(builder: (context) => RelativeRegisterView())
                // );
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Container(
                        width: 300, // Set your desired width here
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network("https://www.pngall.com/wp-content/uploads/5/User-Profile-PNG.png"),
                            Text("Mahamdirayy", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25, color: AppColor.Purple)),
                            Text("Grand Father", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20, color: AppColor.Red)),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SmallText(text: "Date of Birth", size: 16,),
                                    SmallText(text: "22/05/1990", fontWeight: FontWeight.w700,),

                                  ],
                                ),
                                
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SmallText(text: "Status", size: 16,),
                                    SmallText(text: "Alive", fontWeight: FontWeight.w700,)
                                  ],
                                )
                              ],
                            ),
                            Divider(color: AppColor.Purple,),
                            SmallText(text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.")
                            
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              child: Card(
                elevation: 15,
                child: Container(
                  width: 115,
                  height: 147,
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(9, 20, 9, 0),
                              child: SizedBox(
                                height: 90,
                                width: 90,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Image.network(
                                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcScXyoZXpAWph9Vnu9_ZpWgNmn20W4hlBOn-5dLmFQuww8zSfnhRRNQW7B0RRuApO_PFwg&usqp=CAU',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 1),
                                Center(child: Text('Default Name')),
                              ],
                            ),
                          )
                        ]
                      ),
                      Positioned(
                        top: -8,
                        right: -8,
                        child: IconButton(
                          icon: Icon(
                            Icons.edit,
                            size: 18,
                            weight: 32,
                            color: AppColor.Purple, 
                          ),
                          onPressed: () {
                            Navigator.push(
                              context, 
                              MaterialPageRoute(builder: (context) => RelativeRegisterView())
                            );
                          }
                        ),
                      ),
                      Positioned(
                        top: -8,
                        right: 72,
                        child: IconButton(
                          icon: const Icon(
                            Icons.delete,
                            size: 18,
                            weight: 32,
                            color: Color.fromARGB(255, 163, 24, 14),
                          ),
                          onPressed: () {
                            setState(() {
                              graph.removeNode(node);
                            });
                          },
                        ),
                      ), 
                    ]
                  )
                )
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final newNode = Node.Id(graph.nodeCount() + 1);
                graph.addEdge(node, newNode);
                setState(() {});
              },
              child: Text('Add child'),
            ),
          ],
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.Purple,
        leading: IconButton( color: AppColor.White, onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back),),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          
          Expanded(
            child: InteractiveViewer(
              scaleEnabled: false,
              transformationController: TransformationController()
                ..value = Matrix4.diagonal3Values(_scale, _scale, 1),
              constrained: false,
              boundaryMargin: EdgeInsets.all(100),
              minScale: 0.01,
              maxScale: 5.6,
              child: Stack(
                children: [
                  // Positioned(
                  //   top: 450.0,
                  //   left: 100.0,
                  //   child: rectangleWidget(Node.Id(6)),
                  // ),
                  // Positioned(
                  //   top: 450.0,
                  //   left: 500.0,
                  //   child: rectangleWidget(Node.Id(7)),
                  // ),

                  
                  GraphView(
                    graph: graph,
                    algorithm: BuchheimWalkerAlgorithm(
                      builder,
                      TreeEdgeRenderer(builder),
                    ),
                    paint: Paint()
                      ..color = AppColor.Purple
                      ..strokeWidth = 1.7
                      ..style = PaintingStyle.stroke,
                    builder: (Node node) {
                      final nodeKey = node.key!.value as int?;
                      final nodeObject = Node.Id(nodeKey!);
                
                      return rectangleWidget(nodeObject);
                    },
                  ),
                ]
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _scale *= 1.2;
                    });
                  },
                  icon: Icon(Icons.add, color: AppColor.Blue,),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _scale /= 1.2;
                    });
                  },
                  icon: Icon(Icons.remove, color: AppColor.Red,),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
