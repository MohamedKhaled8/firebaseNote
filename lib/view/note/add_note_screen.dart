import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfire/view/note/view_note_screen.dart';
import 'package:flutterfire/view/auth/widgets/custombuttonauth.dart';
import 'package:flutterfire/view/categories/widgets/customtextfieldadd.dart';
// ignore_for_file: public_member_api_docs, sort_constructors_first

class AddNoteScreen extends StatefulWidget {
  final String docId;
  const AddNoteScreen({
    Key? key,
    required this.docId,
  }) : super(key: key);

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  TextEditingController note = TextEditingController();
  bool isLoading = false;

  addNote() async {
    CollectionReference collectionnote = FirebaseFirestore.instance
        .collection("categories")
        .doc(widget.docId)
        .collection("note");
    if (formState.currentState!.validate()) {
      try {
        isLoading = true;
        setState(() {});
        DocumentReference response =
            await collectionnote.add({"note": note.text});

        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ViewNoteScreen(categoryid: widget.docId)));
      } catch (e) {
        isLoading = false;
        setState(() {});
        print("Error $e ");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Note")),
      body: Form(
        key: formState,
        child: isLoading
            ? Center(child: const CircularProgressIndicator())
            : Column(children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                  child: CustomTextFormAdd(
                      hinttext: "Enter Your Note",
                      mycontroller: note,
                      validator: (val) {
                        if (val == "") {
                          return "Can't To be Empty";
                        }
                      }),
                ),
                CustomButtonAuth(
                  title: "Add",
                  onPressed: () {
                    addNote();
                  },
                )
              ]),
      ),
    );
  }
}
