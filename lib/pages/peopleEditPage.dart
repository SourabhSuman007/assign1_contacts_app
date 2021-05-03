import 'package:assign1_contacts_app/model/people.dart';
import 'package:assign1_contacts_app/peopleData.dart';
import 'package:assign1_contacts_app/res/colors.dart';
import 'package:assign1_contacts_app/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PeopleEditPage extends StatefulWidget {
  final People currentPeople;

  const PeopleEditPage({@required this.currentPeople});

  @override
  _PeopleEditPageState createState() => _PeopleEditPageState();
}

class _PeopleEditPageState extends State<PeopleEditPage> {
  String newFName;
  String newLName;
  int newPhone;
  int newAge;

  void _editPerson(context) {
    if (newFName == null) {
      toastWidget("Give entry a name.");
      return;
    }
    if (newPhone == null) {
      toastWidget("Entry can't be null.");
      return;
    }
    Provider.of<PeopleData>(context, listen: false).editPerson(
        person: People(
            fName: newFName,
            lName: newLName,
            phone: newPhone,
            age: newAge ?? 0),
        personKey: widget.currentPeople.key);
    Navigator.pop(context);
  }

  final TextEditingController _fNameController = TextEditingController();
  final TextEditingController _lNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  //passing current value to the editable text-space
  @override
  void initState() {
    //for fname
    _fNameController.text = widget.currentPeople.fName;
    newFName = widget.currentPeople.fName;

    //for lname
    _lNameController.text = widget.currentPeople.lName;
    newLName = widget.currentPeople.lName;

    //for phone
    _phoneController.text = widget.currentPeople.phone.toString();
    newPhone = widget.currentPeople.phone;

    //for age
    _ageController.text = widget.currentPeople.age.toString();
    newAge = widget.currentPeople.age;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors[0],
        elevation: 16.0,
        title: Center(
          child: Text(
            "Edit ${widget.currentPeople.fName} ${widget.currentPeople.lName}",
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.save),
              iconSize: 40.0,
              color: Colors.greenAccent,
              tooltip: "Save",
              onPressed: () {
                _editPerson(context);
              }),
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
                controller: _fNameController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: "First Name",
                ),
                onChanged: (fName) {
                  setState(() {
                    newFName = fName;
                  });
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              TextField(
                autofocus: true,
                controller: _lNameController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: "Last Name",
                ),
                onChanged: (lName) {
                  setState(() {
                    newLName = lName;
                  });
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              TextField(
                autofocus: true,
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: "Phone Number",
                ),
                onChanged: (phone) {
                  setState(() {
                    newPhone = int.parse(phone);
                  });
                },
              ),
              TextField(
                autofocus: true,
                controller: _ageController,
                keyboardType: TextInputType.numberWithOptions(decimal: false),
                decoration: InputDecoration(
                  hintText: "Age",
                ),
                onChanged: (age) {
                  setState(() {
                    newAge = int.parse(age);
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
