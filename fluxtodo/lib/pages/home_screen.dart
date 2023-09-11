import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluxtodo/custom/todocard.dart';
import 'package:fluxtodo/pages/add_todo_screen.dart';
import 'package:fluxtodo/pages/profile_secreen.dart';
import 'package:fluxtodo/pages/view_data.dart';
import 'package:fluxtodo/services/auth_Service.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthClass authClass = AuthClass();
  final Stream<QuerySnapshot> _stream =
      FirebaseFirestore.instance.collection('Todo').snapshots();

  List<Select> selected = [];

  @override
  Widget build(BuildContext context) {
    final String currentDate = DateFormat('MMMM d').format(DateTime.now());
    return Scaffold(
      backgroundColor: const Color(0xFF5665b1),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF5665b1),
        title: Text(
          'Today\'s Schedule',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          CircleAvatar(
            backgroundColor: Colors.transparent,
            backgroundImage: AssetImage('assets/user.png'),
          ),
          SizedBox(
            width: 18,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(35),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 28),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    currentDate,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Colors.orangeAccent,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      for (int i = 0; i < selected.length; i++) {
                        if (selected[i].checkValue) {
                          var instance =
                              FirebaseFirestore.instance.collection('Todo');
                          instance.doc(selected[i].id).delete();
                        }
                      }
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                      size: 26,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        backgroundColor: const Color(0xFF5665b1),
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_filled,
              size: 32,
              color: Colors.white,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (builder) => AddToDoPage(),
                  ),
                );
              },
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFF78469b), Color(0xFF3684c4)],
                    )),
                child: Icon(
                  Icons.add_outlined,
                  size: 32,
                  color: Colors.white,
                ),
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (builder) => Profile(),
                  ),
                );
              },
              child: Icon(
                Icons.settings_outlined,
                size: 32,
                color: Colors.white,
              ),
            ),
            label: '',
          ),
        ],
      ),
      body: StreamBuilder(
          stream: _stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            return ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  IconData iconData;
                  Color iconColor;
                  Map<String, dynamic> document =
                      snapshot.data?.docs[index].data() as Map<String, dynamic>;
                  switch (document['category']) {
                    case 'Work':
                      iconData = Icons.run_circle_outlined;
                      iconColor = const Color(0xFF000000);
                      break;
                    case 'Technology':
                      iconData = Icons.computer_outlined;
                      iconColor = const Color(0xFFC0C0C0);
                      break;
                    case 'Food':
                      iconData = Icons.fastfood_outlined;
                      iconColor = const Color(0xFF4876FF);
                      break;
                    case 'Design':
                      iconData = Icons.design_services_outlined;
                      iconColor = const Color(0xFFFFFF00);
                      break;
                    case 'Sport':
                      iconData = Icons.sports_outlined;
                      iconColor = const Color(0xFFFF7F50);
                      break;
                    case 'Science':
                      iconData = Icons.science_outlined;
                      iconColor = const Color(0xFF6A5ACD);
                      break;
                    default:
                      iconData = Icons.add_alarm_outlined;
                      iconColor = Colors.redAccent;
                  }
                  selected.add(Select(
                      id: snapshot.data!.docs[index].id, checkValue: false));
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (builder) => ViewData(
                              document: document,
                              id: snapshot.data!.docs[index].id),
                        ),
                      );
                    },
                    child: TodoCard(
                      title: document['title'] ?? 'Hey There',
                      iconData: iconData,
                      iconColor: iconColor,
                      time: '10 AM',
                      check: selected[index].checkValue,
                      iconBgColor: Colors.white,
                      index: index,
                      onChange: onChange,
                    ),
                  );
                });
          }),
    );
  }

  void onChange(int index) {
    setState(() {
      selected[index].checkValue = !selected[index].checkValue;
    });
  }
}

class Select {
  String id;
  bool checkValue = false;

  Select({required this.id, required this.checkValue});
}

//
// IconButton(onPressed: () async {
// await authClass.signOut(context: context);
// Navigator.pushAndRemoveUntil(
// context,
// MaterialPageRoute(
// builder: (builder) => SignUpPage(),
// ),
// (route) => false);
// }, icon: Icon(Icons.logout_outlined,),),
