import 'package:flutter/material.dart';

class TodoCard extends StatelessWidget {
  const TodoCard(
      {Key? key,
      required this.title,
      required this.iconData,
      required this.iconcolor,
      required this.time,
      required this.iconBgColor,
      required this.ischecked})
      : super(key: key);



  final String title;
  final IconData iconData;
  final Color iconcolor;
  final String time;
  final Color iconBgColor;
  final bool ischecked;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 75,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: ischecked?Colors.green:Colors.transparent,width: 2)
                ),
                color: const Color(0xff2a2e3d),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 15,
                    ),
                    Container(
                      height: 33,
                      width: 36,
                      decoration: BoxDecoration(
                        color: iconBgColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        iconData,
                        color: iconcolor,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      time,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
