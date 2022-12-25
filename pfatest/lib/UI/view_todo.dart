import 'dart:core';
import 'package:flutter/material.dart';
import 'package:pfatest/Moudel/google_sign_in.dart';
import 'package:pfatest/UI/topnavigationbar.dart';
import 'package:pfatest/UI/view_data.dart';
import 'package:pfatest/widget/TodoCard.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class viewTodo extends StatefulWidget {
  const viewTodo({Key? key, required this.document, required this.id})
      : super(key: key);
  final Map<String, dynamic> document;
  final String id;

  @override
  State<viewTodo> createState() => _viewTodoState();
}

class _viewTodoState extends State<viewTodo> {
  late final Map<String, dynamic> document;
  final user = FirebaseAuth.instance.currentUser!;

  @override

  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _stream = FirebaseFirestore.instance
        .collection("Todo")
        .doc(widget.document["email"])
        .collection("Task")
        .snapshots();
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              Color(0xffd9d9d9),
              Color(0xffafacac),
            ]),
          ),
        ),
        title: Text(
          widget.document["email"],
          style: const TextStyle(
            fontSize: 34,
            color: Color(0xfffe9000),
          ),
        ),
        actions: [
          CircleAvatar(
            backgroundColor: const Color(0xfffefe),
            backgroundImage:
                NetworkImage(user.photoURL == null ? "" : user.photoURL!),
          ),
          const SizedBox(
            width: 25,
          ),
          InkWell(
            onTap: () {
              final provider =
                  Provider.of<GoogleSignInProvider>(context, listen: false);
              provider.logout();
              FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (builder) => const Topnavigationbar()),
                  (route) => false);
            },
            child: const Icon(
              Icons.logout,
              size: 32,
              color: Colors.black,
            ),
          ),
        ],
      ),

      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              Color(0xffd9d9d9),
              Color(0xffafacac),
            ])),
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 10, right: 10),
          child: StreamBuilder<QuerySnapshot>(
              stream: _stream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                      IconData iconData = Icons.error;
                      Color iconColor = Colors.white;
                      Map<String, dynamic> document =
                      snapshot.data?.docs[index].data()
                      as Map<String, dynamic>;
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
                              builder: (builder) => ViewData(
                                document: document,
                                id: snapshot.data!.docs[index].id,
                                wid: widget.id,
                              ),
                            ),
                          );
                        },
                        child: TodoCard(
                          title: document["title"] ==null
                              ? "Hey There"
                              : document["title"],
                          iconBgColor: Colors.white,
                          iconcolor: iconColor,
                          iconData: iconData,
                          time: document["Time"],
                          ischecked: document["ischecked"],
                        ),
                      );
                    });
              }),
        ),
      ),
    );
  }
}
