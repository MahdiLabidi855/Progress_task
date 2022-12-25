import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pfatest/UI/view_todo.dart';
import 'package:pfatest/widget/TodoCard.dart';
class Adminlc extends StatefulWidget {
  const Adminlc({Key? key}) : super(key: key);

  @override
  State<Adminlc> createState() => _AdminlcState();
}

class _AdminlcState extends State<Adminlc> {
  late final Map<String, dynamic> document;
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _stream =
    FirebaseFirestore.instance.collection("list").doc(user.email).collection(
        "users").snapshots();
    return Container(
      height: MediaQuery
          .of(context)
          .size
          .height,
      width: MediaQuery
          .of(context)
          .size
          .width,
      decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
            Color(0xffd9d9d9),
            Color(0xffafacac),
          ])),
      child: StreamBuilder<QuerySnapshot>(
          stream: _stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Padding(
              padding: const EdgeInsets.only(top: 20.0 ,left: 10,right: 10),
              child: ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context, index) {
                    IconData iconData = Icons.error;
                    Color iconColor = Colors.white;
                    Map<String, dynamic> document =
                    snapshot.data?.docs[index].data() as Map<String, dynamic>;

                    switch (document["Category"]) {
                      case "Meeting":
                        iconData = Icons.people_alt_outlined;
                          iconColor= const Color(0xfffc0000);

                        break;
                      case "Files":
                        iconData = Icons.filter_none_rounded;
                          iconColor= Colors.teal;
                        break;
                      case "Call":
                        iconData = Icons.phone_iphone;
                        iconColor= const Color(0xff002afc);
                        break;
                      case "Task":
                        iconData = Icons.design_services;
                        iconColor = Colors.green;
                        break;
                      default:
                        iconData = Icons.check;
                        iconColor = Colors.orangeAccent;
                    }
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (builder) =>
                                viewTodo(
                                  document: document,
                                  id: snapshot.data!.docs[index].id,
                                ),


                          ),
                        );
                      },
                      child: TodoCard(
                        title: document["email"] ==null
                            ? "Hey There"
                            : document["email"],
                        iconBgColor: Colors.white,
                        iconcolor: iconColor,
                        iconData: iconData,
                        time: document["Time"], ischecked: false,
                      ),
                    );
                  }),
            );
          }),
    );
  }
}
