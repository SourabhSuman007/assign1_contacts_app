import 'package:assign1_contacts_app/model/people.dart';
import 'package:assign1_contacts_app/res/colors.dart';
import 'package:assign1_contacts_app/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../peopleData.dart';

class AddPeoplePage extends StatefulWidget {
  @override
  _AddPeoplePageState createState() => _AddPeoplePageState();
}

class _AddPeoplePageState extends State<AddPeoplePage> {
  String FName;
  String LName;
  int Phone;
  int Age;

  void _addPerson(context) {
    if (FName == null) {
      toastWidget("Give entry a name.");
      return;
    }
    if (Phone == null) {
      toastWidget("Entry can't be null.");
      return;
    }
    Provider.of<PeopleData>(context, listen: false).addPerson(
      People(
        fName: FName,
        lName: LName,
        phone: Phone,
        age: Age ?? 0,
      ),
    );
    //Future.delayed(const Duration(seconds: 2), (){});
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors[0],
        elevation: 16.0,
        title: Center(
          child: Text(
            "Add Person",
            style: TextStyle(
              fontSize: 23.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            iconSize: 40.0,
            color: Colors.lightGreenAccent,
            tooltip: "Save",
            onPressed: () {
              _addPerson(context);
              //Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextField(
                autofocus: true,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: "First Name",
                ),
                onChanged: (fName) {
                  setState(() {
                    FName = fName;
                  });
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              TextField(
                autofocus: true,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: "Last Name",
                ),
                onChanged: (lName) {
                  setState(() {
                    LName = lName;
                  });
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              TextField(
                autofocus: true,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: "Phone Number",
                ),
                onChanged: (phone) {
                  setState(() {
                    Phone = int.parse(phone);
                  });
                },
              ),
              TextField(
                autofocus: true,
                keyboardType: TextInputType.numberWithOptions(decimal: false),
                decoration: InputDecoration(
                  hintText: "Age",
                ),
                onChanged: (age) {
                  setState(() {
                    Age = int.parse(age);
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
