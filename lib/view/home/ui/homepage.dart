import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfire/view/note/view_note_screen.dart';
import 'package:flutterfire/view/categories/edit_screen.dart';
import '../../../core/firebase/instanse/firebase_insatnse.dart';
import 'package:flutterfire/view/categories/categories_add.dart';

// ignore_for_file: prefer_const_literals_to_create_immutables

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  List<QueryDocumentSnapshot> data = [];

  bool isLoading = true;
  getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("categories")
        .where(
          "id",
          isEqualTo: FirebaseAuth.instance.currentUser!.uid,
        )
        .get();
    data.addAll(querySnapshot.docs);
    isLoading = false;
    setState(() {});
  }

  deleateData({required int i}) async {
    await FirebaseFirestore.instance
        .collection("categories")
        .doc(data[i].id)
        .delete();
    Navigator.of(context).pushReplacementNamed("homePageScreen");
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AddCategory()));
          },
          child: const Icon(Icons.add),
        ),
        appBar: AppBar(
          title: const Text('Firebase Install'),
          actions: [
            IconButton(
              onPressed: () async {
                await FireBaseInstance.instanse.signOut();
                // ignore: use_build_context_synchronously
                Navigator.pushNamedAndRemoveUntil(
                    context, 'login', (route) => false);
              },
              icon: const Icon(Icons.exit_to_app),
            )
          ],
        ),
        body: isLoading == true
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : GridView.builder(
                itemCount: data.length, // 3
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, mainAxisExtent: 160),
                itemBuilder: (context, i) {
                  return InkWell(
                    onTap: () {
                       Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              ViewNoteScreen(categoryid: data[i].id)));
                    },
                    onLongPress: () {
                      AwesomeDialog(
                          context: context,
                          dialogType: DialogType.warning,
                          animType: AnimType.rightSlide,
                          title: 'Error',
                          desc: "Choose what you want",
                          btnCancelText: "Deleate",
                          btnOkText: "edite",
                          btnCancelOnPress: () {
                            deleateData(i: i);
                            print("Cancel");
                          },
                          btnOkOnPress: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => EditCategoryScreen(
                                    docid: data[i].id,
                                    oldname: data[i]['name'])));
                          }).show();
                    },
                    child: Card(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Column(children: [
                          Image.asset(
                            "assets/images/logo.png",
                            height: 100,
                          ),
                          Text("${data[i]['name']}")
                        ]),
                      ),
                    ),
                  );
                },
              ));
  }
}
