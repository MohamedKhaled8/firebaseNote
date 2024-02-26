import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfire/view/note/view_note_screen.dart';
import 'package:flutterfire/view/auth/widgets/custombuttonauth.dart';
import 'package:flutterfire/view/categories/widgets/customtextfieldadd.dart';
// ignore_for_file: public_member_api_docs, sort_constructors_first

class EditNoteScreen extends StatefulWidget {
  final String noteDocId;
  final String noteCategoryId;
  final String value;
  const EditNoteScreen({
    Key? key,
    required this.noteDocId,
    required this.noteCategoryId,
    required this.value,
  }) : super(key: key);

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  TextEditingController note = TextEditingController();
  bool isLoading = false;

  editNote() async {
    CollectionReference collectionnote = FirebaseFirestore.instance
        .collection("categories")
        // بحط ال id الخاص بالنوته نفسها مانا هعدل النوتة بس
        .doc(widget.noteCategoryId)
        .collection("note");
    if (formState.currentState!.validate()) {
      try {
        isLoading = true;
        setState(() {});
        // مبحطش متغير لان ال update مبترجعش حاجه
        await collectionnote.doc(widget.noteDocId).update({"note": note.text});

        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                ViewNoteScreen(categoryid: widget.noteCategoryId)));
      } catch (e) {
        isLoading = false;
        setState(() {});
        print("Error $e ");
      }
    }
  }

  @override
  void initState() {
    //وهو داخل لازم يشوف القيمة الابتدائية الي كانت موجوده عليها
    note.text = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Note")),
      body: Form(
        key: formState,
        child: isLoading
            ? Center(child: const CircularProgressIndicator())
            : Column(children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                  child: CustomTextFormAdd(
                      hinttext: "Edit Your Note",
                      mycontroller: note,
                      validator: (val) {
                        if (val == "") {
                          return "Can't To be Empty";
                        }
                        return null;
                      }),
                ),
                CustomButtonAuth(
                  title: "Edit",
                  onPressed: () {
                    editNote();
                  },
                )
              ]),
      ),
    );
  }
}
