import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfire/view/auth/widgets/custombuttonauth.dart';
import 'package:flutterfire/view/categories/widgets/customtextfieldadd.dart';

class EditCategoryScreen extends StatefulWidget {
  final String docid;
  final String oldname;
  const EditCategoryScreen(
      {super.key, required this.docid, required this.oldname});

  @override
  State<EditCategoryScreen> createState() => _EditCategoryScreenState();
}

class _EditCategoryScreenState extends State<EditCategoryScreen> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  TextEditingController name = TextEditingController();

  CollectionReference categories =
      FirebaseFirestore.instance.collection("categories");

  bool isLoading = false;

/// ده لو عندي حساب موجود 
  editCategory() async {
    if (formState.currentState!.validate()) {
      try {
        isLoading = true;
        setState(() {});
        await categories.doc(widget.docid).set({"name": name.text} , 
        //وظيفه السطر ده ان مع اي تحديث ميمسمحش ال id
        SetOptions(merge: true),
        );

        Navigator.of(context)
            .pushNamedAndRemoveUntil("homePageScreen", (route) => false);
      } catch (e) {
        isLoading = false;
        setState(() {});
        print("Error $e ");
      }
    }
  }

  //لو مش موجود 
  //بنستخدم set تعمل وظيفتين الاول => update لو ال doc موجود
// ثانيا تعمل ك Add لو ال Doc مش موجود
  @override
  void dispose() {
    super.dispose();
    name.dispose();
  }

  @override
  void initState() {
    super.initState();
    name.text = widget.oldname;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Category")),
      body: Form(
        key: formState,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
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
                  title: "Save",
                  onPressed: () {
                    editCategory();
                  },
                )
              ]),
      ),
    );
  }
}
 

//  Set = Add  ============> Set Docid 
//  Set = Update  {
//  Merge = FALSE => Field Delete 
//  Merge = True  =>  Update Normal
// 
// }