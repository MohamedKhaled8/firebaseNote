import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfire/view/auth/widgets/custombuttonauth.dart';
import 'package:flutterfire/core/firebase/instanse/firebase_insatnse.dart';
import 'package:flutterfire/view/categories/widgets/customtextfieldadd.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  TextEditingController name = TextEditingController();

  CollectionReference categories =
      FirebaseFirestore.instance.collection("categories");

  addCategory() async {
    if (formState.currentState!.validate()) {
      try {
        DocumentReference response = await categories.add({
          "name": name.text,
          "id": FireBaseInstance.instanse.currentUser!.uid,
        });
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacementNamed("homePageScreen");
        print("================AAAAAAAAAAAAAAAADDDDDDDDDDDDD ");
      } catch (e) {
        print("Error $e ");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Category")),
      body: Form(
        key: formState,
        child: Column(children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
            child: CustomTextFormAdd(
                hinttext: "Enter Name",
                mycontroller: name,
                validator: (val) {
                  if (val == "") {
                    return "Can't To be Empty";
                  }
                }),
          ),
          CustomButtonAuth(
            title: "Add",
            onPressed: () {
              addCategory();
            },
          )
        ]),
      ),
    );
  }
}
