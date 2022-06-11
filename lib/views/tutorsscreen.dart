import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mytutor/views/coursesscreen.dart';
import 'package:mytutor/views/loginscreen.dart';
import 'package:mytutor/views/mainscreen.dart';
import 'package:mytutor/views/tutorsscreen.dart';
import 'package:http/http.dart' as http;

import '../models/tutors.dart';
import '../models/user.dart';
import '../models/courses.dart';

class TutorsScreen extends StatefulWidget {
  final User user;
  const TutorsScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<TutorsScreen> createState() => _TutorsScreenState();
}

class _TutorsScreenState extends State<TutorsScreen> {
  List<Tutors>? tutorsList = <Tutors>[];
  String titlecenter = 'No Tutors Available';

  @override
  void initState() {
    super.initState();
    _loadTutors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Tutors'),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(widget.user.name.toString()),
                accountEmail: Text(widget.user.email.toString()),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(
                    "https://static.wikia.nocookie.net/line/images/b/bb/2015-brown.png/revision/latest?cb=20150808131630")),
                ),
              _createDrawerItem(
                icon: Icons.person,
                text: 'My Profile',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (content) => MainScreen(
                              user: widget.user,
                            )));
                },
              ),
              _createDrawerItem(
                icon: Icons.folder,
                text: 'My Subjects',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (content) => CoursesScreen(
                          user: widget.user,
                            )));
                },
              ),
              _createDrawerItem(
                icon: Icons.book,
                text: 'My Tutor Class',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (content) => TutorsScreen(
                          user: widget.user,
                            )));
                },
              ),
              _createDrawerItem(
                icon: Icons.save,
                text: 'My Subscribe',
                onTap: () {},
              ),
              _createDrawerItem(
                icon: Icons.favorite,
                text: 'My Favourite',
                onTap: () {},
              ),
              _createDrawerItem(
                icon: Icons.settings,
                text: 'Setting',
                onTap: () {},
              ),
              _createDrawerItem(
                icon: Icons.settings,
                text: 'Log Out',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (content) => LoginScreen(
                            )));},
              ),
            ],
            ),
        ),
        body: tutorsList!.isEmpty
        ? Center(
          child: Text(titlecenter,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)))
        : Column(
          children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Text("Tutors Available",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                      children: List.generate(tutorsList!.length, (index) {
                        return Card(
                          child: Column(
                            children: [
                              Flexible(flex: 6,
                                child: CachedNetworkImage(
                                  imageUrl: "http://10.143.159.53/mytutor2/assets/tutors/" + 
                                  tutorsList![index]
                                  .tutorId
                                  .toString() +
                                  '.jpg',
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      const LinearProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                                Flexible(
                                  flex: 4,
                                  child: Column(
                                    children: [
                                      Text(
                                        tutorsList![index]
                                            .tutorName
                                            .toString(),
                                            style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),),
                                      Text(tutorsList![index]
                                                  .tutorEmail
                                                  .toString()),
                                      Text(tutorsList![index]
                                              .tutorPhone
                                              .toString()),
                                      Text(tutorsList![index]
                                          .tutorDesc
                                          .toString()),
                                  ],
                              ))
                            ],
                          ));
                        })
                        )
                        )
                        ],
        ),
    );
  }
  Widget _createDrawerItem(
      {
      required IconData icon,
      required String text,
      required GestureTapCallback onTap
      }) 
      
      {
      return ListTile(
        title: Row
        (children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
            )
    ],
    ),
    onTap: onTap,
  );
  
}      void _loadTutors() {
        http.post(Uri.parse("http://10.143.159.53/mytutor2/php/loadcourses.php"),
            body: {}).then((response) {
          var jsondata = jsonDecode(response.body);
          if (response.statusCode == 200 && jsondata['status'] == 'success') {
          var extractdata = jsondata['data'];
          if (extractdata['subjects'] != null) {
          tutorsList = <Tutors>[];
          extractdata['subjects'].forEach((v) {
            tutorsList!.add(Tutors.fromJson(v));
          });
          }
          }
        });
  }
}