import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ViewData extends StatefulWidget {
  const ViewData({Key? key, required this.document, required this.id, required this.wid})
      : super(key: key);
  final Map<String, dynamic> document;
  final String id;
  final String wid;

  @override
  State<ViewData> createState() => _ViewDataState();
}

class _ViewDataState extends State<ViewData> {
  final user = FirebaseAuth.instance.currentUser!;

  late final TextEditingController _taskController;

  late TextEditingController _descriptionController;

  late String _type;
  late String _category;

  bool edit = false;

  @override
  void initState() {
    super.initState();
    String title = widget.document["title"]==null
        ? "Hey there"
        : widget.document["title"];
    String description = widget.document["description"] ==null
        ? "Hey there"
        : widget.document["description"];
    _taskController = TextEditingController(text: title);
    _descriptionController = TextEditingController(text: description);
    String task = widget.document["task"] ==null
        ? "Planned"
        : widget.document["task"];
    _type = task;
    String category = widget.document["Category"] ==null
        ? "Planned"
        : widget.document["Category"];
    _category = category;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          Color(0xff1d1e26),
          Color(0xff252041),
        ])),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      CupertinoIcons.arrow_left,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            edit = !edit;
                          });
                        },
                        icon: Icon(
                          Icons.edit,
                          color: edit ? Colors.lightBlue : Colors.white,
                          size: 28,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection("Todo")
                              .doc(widget.document["email"])
                              .collection("Task")
                              .doc(widget.id)
                              .delete().then((value) => Navigator.pop(context));


                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                          size: 28,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      edit ? "Editing" : "View",
                      style: const TextStyle(
                          fontSize: 33,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Text(
                      "Your Todo",
                      style: TextStyle(
                          fontSize: 33,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2),
                    ),

                    const SizedBox(
                      height: 25,
                    ),
                    label("Task Title"),
                    const SizedBox(
                      height: 12,
                    ),
                    title(),
                    const SizedBox(
                      height: 30,
                    ),
                    label("Task Type"),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        taskSelect("Important", 0xff2664fa),
                        const SizedBox(
                          width: 20,
                        ),
                        taskSelect("Planned", 0xff2bc8d9),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    label("Descreption"),
                    const SizedBox(
                      height: 12,
                    ),
                    descreption(),
                    const SizedBox(
                      height: 30,
                    ),
                    label("Category"),
                    const SizedBox(
                      height: 12,
                    ),
                    Wrap(
                      runSpacing: 10,
                      children: [
                        categorySelect("Meeting", 0xfffc0000),
                        const SizedBox(
                          width: 20,
                        ),
                        categorySelect("Files", 0xff009688),
                        const SizedBox(
                          width: 20,
                        ),
                        categorySelect("Call", 0xff002afc),
                        const SizedBox(
                          width: 20,
                        ),
                        categorySelect("Task", 0xff4caf50),
                        const SizedBox(
                          width: 20,
                        ),
                        categorySelect("Confirmation", 0xffffab40),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    edit ? button() : Container(),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget button() {
    return InkWell(
      onTap: () {
        FirebaseFirestore.instance
            .collection("Todo").doc(widget.document["email"]).collection("Task")
            .doc(widget.id)
            .update({
          "title": _taskController.text,
          "task": _type,
          "Category": _category,
          "description": _descriptionController.text
        });
        FirebaseFirestore.instance
            .collection("list")
            .doc(user.uid)
            .collection("users")
            .doc(widget.wid)
            .update({
          "title": _taskController.text,
          "task": _type,
          "Category": _category,
          "description": _descriptionController.text
        });
        Navigator.pop(context);
      },
      child: Container(
        height: 56,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [
              Color(0xff8a32f1),
              Color(0xffad32f9),
            ],
          ),
        ),
        child: const Center(
          child: Text(
            "Update Todo",
            style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2),
          ),
        ),
      ),
    );
  }

  Widget descreption() {
    return Container(
      height: 150,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: const Color(0xff2a2e3d),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: _descriptionController,
        enabled: edit,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 17,
        ),
        maxLines: null,
        decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: "Task Title",
            hintStyle: TextStyle(
              color: Colors.grey,
              fontSize: 17,
            ),
            contentPadding: EdgeInsets.only(
              left: 20,
              right: 20,
            )),
      ),
    );
  }


  Widget categorySelect(String label, int color) {
    return InkWell(
      onTap: edit
          ? () {
        setState(() {
          _category = label;
        });
      }
          : null,
      child: Chip(
        backgroundColor: Color(color),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              10,
            ),
            side: BorderSide(
              width: 3,
              color: _category == label ? Colors.white : Color(color),
            )),
        label: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        labelPadding: const EdgeInsets.symmetric(
          horizontal: 17,
          vertical: 3.8,
        ),
      ),
    );
  }
  Widget taskSelect(String label, int color) {
    return InkWell(
      onTap: edit
          ? () {
        setState(() {
          _type = label;
        });
      }
          : null,
      child: Chip(
        backgroundColor: Color(color),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              10,
            ),
            side: BorderSide(
              width: 3,
              color: _type == label ? Colors.white : Color(color),
            )),
        label: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        labelPadding: const EdgeInsets.symmetric(
          horizontal: 17,
          vertical: 3.8,
        ),
      ),
    );
  }

  Widget title() {
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: const Color(0xff2a2e3d),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: TextFormField(
          controller: _taskController,
          enabled: edit,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 17,
          ),
          decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: "Task Title",
              hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: 17,
              ),
              contentPadding: EdgeInsets.only(
                left: 20,
                right: 20,
              )),
        ),
      ),
    );
  }

  Widget label(String label) {
    return Text(
      label,
      style: const TextStyle(
          fontSize: 16.5,
          color: Colors.white,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2),
    );
  }
}
