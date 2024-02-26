import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfire/view/note/add_note_screen.dart';
import 'package:flutterfire/view/note/edit_note_screen.dart';
import '../../../core/firebase/instanse/firebase_insatnse.dart';
// ignore_for_file: public_member_api_docs, sort_constructors_first

// ignore_for_file: prefer_const_literals_to_create_immutables

class ViewNoteScreen extends StatefulWidget {
  final String categoryid;
  const ViewNoteScreen({
    Key? key,
    required this.categoryid,
  }) : super(key: key);

  @override
  State<ViewNoteScreen> createState() => _ViewNoteScreenState();
}

class _ViewNoteScreenState extends State<ViewNoteScreen> {
  List<QueryDocumentSnapshot> data = [];

  bool isLoading = true;
  getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("categories")
        .doc(widget.categoryid)
        .collection("note")
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
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AddNoteScreen(
                      docId: widget.categoryid,
                    )));
          },
          child: const Icon(Icons.add),
        ),
        appBar: AppBar(
          title: const Text('Note'),
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
        body: WillPopScope(
            child: isLoading == true
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : GridView.builder(
                    itemCount: data.length, // 3
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, mainAxisExtent: 160),
                    itemBuilder: (context, i) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => EditNoteScreen(
                                  noteDocId: data[i].id,
                                  noteCategoryId: widget.categoryid,
                                  value: data[i]['note'])));
                        },
                        onLongPress: () {
                          AwesomeDialog(
                              context: context,
                              dialogType: DialogType.warning,
                              animType: AnimType.rightSlide,
                              title: 'Error',
                              desc: "are sure of the deleting process",
                              btnCancelOnPress: () async {},
                              btnOkOnPress: () async {
                                await FirebaseFirestore.instance
                                    .collection("categories")
                                    .doc(widget.categoryid)
                                    .collection("note")
                                    .doc(data[i].id)
                                    .delete();
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ViewNoteScreen(
                                        categoryid: widget.categoryid)));
                              }).show();
                        },
                        child: Card(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Column(children: [
                              // Image.asset(
                              //   "assets/images/logo.png",
                              //   height: 100,
                              // ),
                              Text("${data[i]['note']}"),
                            ]),
                          ),
                        ),
                      );
                    },
                  ),
            onWillPop: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil("homePageScreen", (route) => false);
              return Future.value(false);
            }));
  }
}
