import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:assignment/view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DataFromJsonFile(),
    );
  }
}

class DataFromJsonFile extends StatefulWidget {
  @override
  _DataFromJsonFileState createState() => _DataFromJsonFileState();
}

class _DataFromJsonFileState extends State<DataFromJsonFile> {
  Future getUserData() async {
    var response = await http.get(
        Uri.parse("https://my-json-server.typicode.com/easygautam/data/users"));
    var jsonData = jsonDecode(response.body);
    List<User> users = [];
    for (var u in jsonData) {
      User user = User(
        u["name"],
        u["subjects"],
        u["qualification"],
        u["profileImage"],
      );
      users.add(user);
    }
    return users;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Data From JsonFile"),
        ),
        body: Container(
          child: Center(
            child: Card(
              child: FutureBuilder(
                future: getUserData(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
                    return Container(
                      child: Text("Loding..."),
                    );
                  } else
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, i) {
                          return Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25)),
                              color: Colors.white,
                              elevation: 10,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 14, horizontal: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            // user Name display
                                            snapshot.data[i].name,
                                            style: TextStyle(
                                                color: Colors.purple,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Text(
                                                // Subjects Display
                                                snapshot.data[i].subjects[0]
                                                    .toString(),
                                                style: TextStyle(fontSize: 12),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Icon(
                                                // icon added to make a gap between subjects and qualifications
                                                Icons.circle,
                                                size: 8,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                //qualification display
                                                snapshot
                                                    .data[i].qualification[0]
                                                    .toString(),
                                                style: TextStyle(fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: FlatButton(
                                            // view More button added
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ViewMore()));
                                            },
                                            child: Text(
                                              " view more ",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            color: Colors.purple,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Colors.grey,
                                          ),
                                          child: Image.network(
                                            // image Display
                                            snapshot.data[i].profileImage,
                                            width: 100,
                                            height: 100,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ));
                        });
                },
              ),
            ),
          ),
        ));
  }
}

class User {
  final String name;
  final List subjects;
  final List qualification;
  final String profileImage;

  User(this.name, this.subjects, this.qualification, this.profileImage);
}
