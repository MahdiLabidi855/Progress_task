import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:pfatest/UI/admin.dart';

class info extends StatefulWidget {
  const info({Key? key}) : super(key: key);

  @override
  State<info> createState() => _infoState();
}

class _infoState extends State<info> {
  final user = FirebaseAuth.instance.currentUser!;

  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String type = "";
  String category = "";
  DateTime date=DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          Color(0xffd9d9d9),
          Color(0xffafacac),
        ])),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Create",
                      style: TextStyle(
                          fontSize: 33,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4),
                    ),
                    const SizedBox(
                      height:8,
                    ),
                    const Text(
                      "New Todo",
                      style: TextStyle(
                          fontSize: 33,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2),
                    ),const SizedBox(
                      height:18,
                    ),
                    const Text(
                      "Email",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16.5,
                          letterSpacing: 2),
                    ),
                    email(),
                    const SizedBox(
                      height: 25,
                    ),
                    label("End task Date"),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                            onPressed: () async {
                              DateTime? newDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2100)
                              );
                              setState(() {
                                date =newDate!;
                              });
                            },
                            child: const Text('Select Date')),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(
                          DateFormat('yyyy/MM/dd').format(date),
                          style:
                          const TextStyle(fontSize: 20, color: Color(0xffffffff)),
                        ),
                      ],
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
                    button(),
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
            .collection("Todo")
            .doc(_emailController.text)
            .collection("Task")
            .add({
          "title": _taskController.text,
          "email": _emailController.text,
          "emailadmin": user.email,
          "task": type,
          "Category": category,
          "ischecked": false,
          "description": _descriptionController.text,
          "endtime":DateFormat('yyyy/MM/dd').format(date),
          "Time": DateFormat('yyyy/MM/dd').format(DateTime.now())
        });
        FirebaseFirestore.instance
            .collection("list")
            .doc(user.email)
            .collection("users")
            .add({
          "email": _emailController.text,
          "emailadmin": user.email,
          "Category": category,
          "endtasks": 0,
          "Time": DateFormat('yyyy/MM/dd').format(DateTime.now()),
        });
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const todoadmin()),
                (route) => false);
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
            "Send Task",
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

  Widget taskSelect(String label, int color) {
    return InkWell(
      onTap: () {
        setState(() {
          type = label;
        });
      },
      child: Chip(
        backgroundColor: Color(color),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              10,
            ),
            side: BorderSide(
              width: 3,
              color: type == label ? Colors.white : Color(color),
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

  Widget categorySelect(String label, int color) {
    return InkWell(
      onTap: () {
        setState(() {
          category = label;
        });
      },
      child: Chip(
        backgroundColor: Color(color),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              10,
            ),
            side: BorderSide(
              width: 3,
              color: category == label ? Colors.white : Color(color),
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

  Widget email() {
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: const Color(0xff2a2e3d),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: TextFormField(
          keyboardType: TextInputType.emailAddress,
          controller: _emailController,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 17,
          ),
          decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: "Email",
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
