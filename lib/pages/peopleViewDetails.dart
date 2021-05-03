import 'package:assign1_contacts_app/model/people.dart';
import 'package:assign1_contacts_app/pages/peopleEditPage.dart';
import 'package:assign1_contacts_app/peopleData.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils.dart';

class PeopleViewDetails extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Consumer<PeopleData>(
      builder: (context, peopleData, child) {
        People currentPeople = peopleData.getActivePerson();
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.lightBlue,
            elevation: 20.0,
            title: Center(
              child: Text(
                currentPeople.fName == null
                    ? ""
                    : currentPeople.fName + " " + currentPeople.lName,
                style: TextStyle(
                  fontSize: 23.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.create),
                iconSize: 40.0,
                color: Colors.grey[600],
                tooltip: "Edit",
                onPressed: () {
                  Log.d("Select to edit");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return PeopleEditPage(currentPeople: currentPeople);
                      },
                    ),
                  );
                },
              ),
              //delete
            ],
          ),
          body: Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Card(
                    elevation: 10,
                    child: Container(
                      height: 36.0,
                      color: Colors.lightBlue[300],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "Phone",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                          Text(
                            currentPeople.phone.toString(),
                            style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Card(
                    elevation: 10,
                    child: Container(
                      //padding: EdgeInsets.all(10),
                      height: 36.0,
                      color: Colors.lightBlue[300],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "Age",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                          Text(
                            currentPeople.age.toString(),
                            style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
