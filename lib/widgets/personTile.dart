import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../peopleData.dart';
import '../model/people.dart';
import 'package:assign1_contacts_app/model/people.dart';
import 'package:assign1_contacts_app/pages/peopleViewDetails.dart';
import 'package:assign1_contacts_app/res/colors.dart';

import '../utils.dart';

class PersonTile extends StatelessWidget {
  final int titleIndex;

  PersonTile({Key key, this.titleIndex});

  @override
  Widget build(BuildContext context) {
    void _deleteConfirmation(currentPeople) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: colors[5],
            title: Text(
              'Are you sure?',
              style: TextStyle(
                color: colors[6],
              ),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text(
                      'Your are about to delete ${currentPeople.fName + " " + currentPeople.lName}'),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text('This action can\'t be undone!!'),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text(
                  "DELETE",
                  style: TextStyle(
                    color: colors[7],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  Log.d(
                      "Deleting ${currentPeople.fName + " " + currentPeople.lName}");
                  Provider.of<PeopleData>(context, listen: false)
                      .deletePerson(currentPeople.key);
                  Navigator.popUntil(
                    context,
                    ModalRoute.withName(Navigator.defaultRouteName),
                  );
                },
              ),
              TextButton(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: colors[0],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  Log.d("Cancelling");
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        },
      );
    }

    return Consumer<PeopleData>(
      builder: (context, peopleData, child) {
        People currentPerson = peopleData.getPerson(titleIndex);
        if(currentPerson==null){
          return Container();
        }
        //returns the list with some styles
        return Container(
          decoration: BoxDecoration(
            //color: titleIndex % 2 == 0 ? Colors.blue[100] : Colors.white,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Card(
            elevation: 3,
            child: ListTile(
              dense: true,
              contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              leading: CircleAvatar(
                backgroundColor: colors[titleIndex % colors.length],
                radius: 25.0,
                child: Text(
                  currentPerson.lName == ''
                      ? currentPerson.fName.substring(0, 1)
                      : currentPerson.fName.substring(0, 1) +
                          currentPerson.lName.substring(0, 1),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                currentPerson.fName == null
                    ? ""
                    : currentPerson.fName + " " + currentPerson.lName,
                style: TextStyle(
                  color: Colors.lightBlue,
                  fontSize: 19.0,
                  //fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                currentPerson.phone == null
                    ? ""
                    : currentPerson.phone.toString(),
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16.0,
                  //fontWeight: FontWeight.bold,
                ),
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                iconSize: 24.0,
                color: Colors.grey[500],
                tooltip: "Delete",
                onPressed: () {
                  Log.d("Select to delete");
                  _deleteConfirmation(currentPerson);
                },
              ),
              onTap: () {
                Provider.of<PeopleData>(context, listen: false)
                    .setActivePerson(currentPerson.key);
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return PeopleViewDetails();
                }));
              },
            ),
          ),
        );
      },
    );
  }
}
