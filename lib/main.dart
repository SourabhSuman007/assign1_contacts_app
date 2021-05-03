import 'package:assign1_contacts_app/pages/addPeoplePage.dart';
import 'package:assign1_contacts_app/pages/peopleListPage.dart';
import 'package:assign1_contacts_app/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'model/people.dart';
import 'peopleData.dart';

void main() {
  Hive.registerAdapter(PeopleAdapter());
  runApp(ContactsApp());
}

Future _initHive() async {
  var dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
}

class ContactsApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PeopleData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Contacts",
        theme: ThemeData(
          primaryColor: colors[0],
        ),
        initialRoute: "/",
        routes: {
          "/": (context) => FutureBuilder(
                future: _initHive(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.error != null) {
                      print(snapshot.error);
                      return Scaffold(
                        body: Center(
                          child: Text(
                            "Error Establishing connection to hive.",
                          ),
                        ),
                      );
                    } else {
                      return PeopleListPage();
                    }
                  } else {
                    return Scaffold();
                  }
                },
              ),
          "/AddPeoplePage": (context) => AddPeoplePage(),
        },
      ),
    );
  }
}
