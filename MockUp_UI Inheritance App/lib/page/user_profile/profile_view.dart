import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inheritance_app/page/family_chart/family_tree_view.dart';
import 'package:inheritance_app/page/family_chart/test.dart';
import 'package:inheritance_app/page/relative_registration/relative_register_view.dart';
import 'package:inheritance_app/page/user_profile/local_widget/profile_menu_widget.dart';
import 'package:inheritance_app/utils/text/medium_size.dart';
import 'package:inheritance_app/utils/text/small_size.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4C0082),
        title: const Center(
          child: MediumText(text: "Profile", color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              /// -- IMAGE
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.network(
                            "https://www.shareicon.net/data/512x512/2016/09/15/829452_user_512x512.png")),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Color.fromARGB(255, 194, 194, 194)),
                      child: const Icon(
                        LineAwesomeIcons.alternate_pencil,
                        color: Color.fromARGB(255, 84, 8, 128),
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const MediumText(text: "Linlin"),
              const SmallText(text: "sreylinchey@gmail.com"),
              const SizedBox(height: 20),

              /// -- BUTTON
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  //onPressed: () => Get.to(() => const UpdateProfileScreen()),
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4C0082),
                      side: BorderSide.none,
                      shape: const StadiumBorder()),
                  child: const Text("Edit Profile",
                      style:
                          TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
                ),
              ),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 10),

              /// -- MENU
              ProfileMenuWidget(
                title: "Favourite",
                icon: Icons.favorite_border,
                onPress: () {}),
            
              ProfileMenuWidget(
                title: "Direct Sale",
                icon: LineAwesomeIcons.wallet,
                onPress: () {}),
              
              const Divider(),
              const SizedBox(height: 10),
              ProfileMenuWidget(
                title: "Family Registration",
                icon: LineAwesomeIcons.user_1,
                onPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                        const RelativeRegisterView()
                        )
                      );
                }),
              ProfileMenuWidget(
                title: "Family Card",
                icon: LineAwesomeIcons.people_carry,
                onPress: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FamilyTreeView()));
                }),
              ProfileMenuWidget(
                title: "Family Chart",
                icon: LineAwesomeIcons.user_friends,
                onPress: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TreeViewPage()));
                }),
              const Divider(),
              const SizedBox(height: 10),
              ProfileMenuWidget(
                title: "Language",
                icon: LineAwesomeIcons.language,
                onPress: () {}),
              ProfileMenuWidget(
                title: "Logout",
                icon: LineAwesomeIcons.alternate_sign_out,
                textColor: Colors.red,
                endIcon: false,
                onPress: () {
                  Get.defaultDialog(
                    title: "LOGOUT",
                    titleStyle: const TextStyle(fontSize: 20),
                    content: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      child: Text("Are you sure, you want to Logout?"),
                    ),
                    confirm: Expanded(
                      child: ElevatedButton(
                        // onPressed: () => AuthenticationRepository.instance.logout(),
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            side: BorderSide.none),
                        child: const Text("Yes"),
                      ),
                    ),
                    cancel: OutlinedButton(
                        onPressed: () => Get.back(), child: const Text("No")),
                  );
                }),
              ProfileMenuWidget(
                title: "Settings",
                icon: LineAwesomeIcons.cog,
                onPress: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
