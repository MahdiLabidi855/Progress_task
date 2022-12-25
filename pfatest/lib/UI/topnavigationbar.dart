import 'package:flutter/material.dart';
import 'package:pfatest/ui/login.dart';
import 'package:pfatest/ui/signup.dart';

class Topnavigationbar extends StatelessWidget {
  const Topnavigationbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: DefaultTabController(
      length: choices.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Image.asset(
            "assets/images/app.png",
            width: 100,
            height: 50,
          ),
          bottom: TabBar(labelPadding: const EdgeInsets.symmetric(horizontal: 90),
            indicatorColor:const Color(0xffd28700),
            labelColor:const Color(0xec2264c7),
            unselectedLabelColor: const Color(0xffd28700),
            isScrollable: true,
            tabs: choices.map<Widget>((Choice choice) {
              return Tab(
                height: 70,
                text: choice.title,
                icon: Icon(choice.icon),
              );
            }).toList(),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TabBarView(
            children: choices.map((Choice choice) {
              return choice.title == 'Login' ? const login() : const signup();
            }).toList(),
          ),
        ),
      ),
    ));
  }
}

class Choice {
  final String title;
  final IconData icon;

  const Choice({
    required this.title,
    required this.icon,
  });
}

const List<Choice> choices = <Choice>[
  Choice(title: 'Login', icon: Icons.login_outlined),
  Choice(
    title: 'Sign up',
    icon: Icons.person_add_alt,
  ),
];

class ChoicePage extends StatelessWidget {
  const ChoicePage({Key? key, required this.choice}) : super(key: key);
  final Choice choice;

  @override
  Widget build(BuildContext context) {
    final TextStyle? textStyle = Theme.of(context).textTheme.displayLarge;

    return Card(
      color: const Color(0xffd28700),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              choice.icon,
            ),
            Text(
              choice.title,
              style: textStyle,
            )
          ],
        ),
      ),
    );
  }
}
