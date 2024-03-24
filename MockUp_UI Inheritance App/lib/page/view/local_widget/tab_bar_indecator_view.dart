import 'package:flutter/material.dart';
import 'package:inheritance_app/page/view/close_community/close_community_view.dart';
import 'package:inheritance_app/page/view/private_view.dart';
import 'package:inheritance_app/utils/text/medium_size.dart';
import 'package:inheritance_app/utils/theme/theme.dart';

class TabBarIndecatorView extends StatefulWidget {
  const TabBarIndecatorView({Key? key}) : super(key: key);

  @override
  TabBarIndecatorViewState createState() => TabBarIndecatorViewState();
}

class TabBarIndecatorViewState extends State<TabBarIndecatorView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Color(0xFF4C0082),
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
                hintStyle: TextStyle(color: Color.fromARGB(255, 238, 238, 238))),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.notifications,
                  color: Color.fromARGB(255, 238, 238, 238),
                )),
          )
        ],
      ),
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(55),
            child: TabBar(
              controller: _tabController,
              labelColor: AppColor.LightBrown,
              unselectedLabelColor: AppColor.Purple,
              indicatorWeight: 4,
              labelPadding: const EdgeInsets.only(left: 0, right: 0),
              indicator: ShapeDecoration(
                shape: const UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Color.fromARGB(0, 0, 0, 0),
                      width: 0,
                      style: BorderStyle.solid),
                ),
                gradient: LinearGradient(colors: [AppColor.Purple, AppColor.Red]),
              ),
              tabs: [
                Container(
                  height: 50,
                  alignment: Alignment.center,
                  color: AppColor.White,
                  child: const MediumText(text: "Private"),
                ),
                Container(
                  height: 50,
                  alignment: Alignment.center,
                  color: AppColor.White,
                  child: const MediumText(text: "Close Community"),
                )
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: const [
              PrivateView(),
              CloseCommunityView(),
            ],
          ),
        ),
      ),
    );
  }
}
