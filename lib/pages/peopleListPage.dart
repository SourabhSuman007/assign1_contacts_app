import 'package:assign1_contacts_app/model/people.dart';
import 'package:assign1_contacts_app/peopleData.dart';
import 'package:assign1_contacts_app/res/colors.dart';
import 'package:assign1_contacts_app/widgets/peopleList.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class PeopleListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PeopleListPageState();
  }
}

class _PeopleListPageState extends State<PeopleListPage> {
  //List<Contacts> contacts = [];
  String name;
  String n1, n2;
  String fname;
  String lname;
  String ph;
  int phnum;
  int Age;
  Iterable<Item> phone;
  List<People> _contacts = [];
  List<People> contactsFiltered = [];
  TextEditingController searchController = new TextEditingController();

  String flatternPhNo(String ph) {
    return ph.replaceAllMapped(RegExp(r'^(\+)|\D'), (Match m) {
      return m[0] == '+' ? '+' : '';
    });
  }

  void _inihive(context) async {
    List<Contact> _contacts = (await ContactsService.getContacts()).toList();
    //print(_contacts);
    _contacts.forEach((element) {
      //print("name: "+element.displayName);
      var parts = element.displayName.split(' ');
      n1 = parts[0].trim();
      n2 = parts.sublist(1).join(' ').trim();
      if (element.phones.toString() == '()') {
        ph = '1234567890';
      } else {
        ph = element.phones.elementAt(0).value;
      }
      ph = flatternPhNo(ph);
      phnum = int.parse(ph);
      Provider.of<PeopleData>(context, listen: false).addPerson(
        //Contact(displayName: name, phones: phone),
        People(
          fName: n1,
          lName: n2,
          phone: phnum ?? 0,
          age: Age ?? 0,
        ),
      );
    });
  }

  getPermission(context) async {
    if (await Permission.contacts.request().isGranted) {
      _inihive(context);
    }
    searchController.addListener(() {
      filteredContact();
    });
  }

  deleteAllContacts() {
    Provider.of<PeopleData>(context, listen: false).deleteAll();
  }

  filteredContact() async{
    List<People> contacts = _contacts;
    _contacts = await Provider.of<PeopleData>(context, listen: false).getPeoples();
    if (searchController.text.isNotEmpty) {
      _contacts.retainWhere((contact) {
        String searchTerm = searchController.text.toLowerCase();
        String searchtermFlattern = flatternPhNo(searchTerm);
        // String contactFName =  contact.fName.toLowerCase();
        // String contactLName = contact.lName.toLowerCase();
        bool namematch;
        var parts = searchController.text.split(' ');
        //print("Search cont:" + searchController.text);
        n1 = parts[0].trim();
        n2 = parts.sublist(1).join(' ').trim();
        contacts = Provider.of<PeopleData>(context, listen: false)
            .searchPeople(n1, n2) as List<People>;
        if (contacts.isEmpty) {
          namematch = false;
          return namematch;
        } else {
          //add to list-box
          contacts.forEach((element) {
            Provider.of<PeopleData>(context, listen: false).addPerson(
              //Contact(displayName: name, phones: phone),
              People(
                fName: element.fName,
                lName: element.lName,
                phone: element.phone ?? 1234567890,
                age: element.age ?? 0,
              ),
            );
          });
          namematch = true;
        }
        if (searchtermFlattern.isEmpty) {
          return false;
        }
        //for search by numbers
        String flatternPhone;
        Pattern pattern = r'/^\(?(\d{3})\)?[- ]?(\d{3})[- ]?(\d{4})$/';
        RegExp regex = new RegExp(pattern);
        if (regex.hasMatch(searchController.text)) {
          flatternPhone = flatternPhNo(searchController.text);
          int flatPhone = int.parse(flatternPhone);
          var phone = Provider.of<PeopleData>(context, listen: false)
              .searchPeopleWithPhone(flatPhone) as List<People>;

          //add to list-box
          contacts.forEach((element) {
            Provider.of<PeopleData>(context, listen: false).addPerson(
              //Contact(displayName: name, phones: phone),
              People(
                fName: element.fName,
                lName: element.lName,
                phone: element.phone ?? 0123456789,
                age: element.age ?? 0,
              ),
            );
          });

          return phone != null;
        }
        return phone == null;
      });
    }
    contactsFiltered = contacts;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Provider.of<PeopleData>(context, listen: false).getPeoples();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors[0],
        elevation: 20.0,
        centerTitle: true,
        title: Text(
          'Peoples',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 23.0,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.import_contacts),
            iconSize: 25.0,
            color: Colors.lightGreenAccent,
            tooltip: "Import Contacts",
            onPressed: () {
              getPermission(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.delete_forever_outlined),
            iconSize: 25.0,
            color: Colors.yellow[600],
            tooltip: "Empty Hive",
            onPressed: deleteAllContacts,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: Container(
                alignment: Alignment.topRight,
                child: TextButton(
                  autofocus: true,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                    child: Text(
                      '+ ADD',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/AddPeoplePage');
                  },
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    labelText: 'Search',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: PeopleList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
