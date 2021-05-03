import 'package:assign1_contacts_app/widgets/toast.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'model/people.dart';
import 'peopleData.dart';

class ContactsUtil extends StatefulWidget {
  ContactsUtil({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ContactsUtilState createState() => _ContactsUtilState();
}

class _ContactsUtilState extends State<ContactsUtil> {
  List<Contact> contacts = [];
  List<Contact> contactsFiltered = [];
  Map<String, Color> contactsColorMap = new Map();
  TextEditingController searchController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    getPermissions();
  }

  getPermissions() async {
    if (await Permission.contacts.request().isGranted) {
      getAllContacts();
      searchController.addListener(() {
        filterContacts();
      });
    }
  }

  String flattenPhoneNumber(String phoneStr) {
    return phoneStr.replaceAllMapped(RegExp(r'^(\+)|\D'), (Match m) {
      return m[0] == "+" ? "+" : "";
    });
  }

  filterContacts() {
    List<Contact> _contacts = [];
    _contacts.addAll(contacts);
    if (searchController.text.isNotEmpty) {
      _contacts.retainWhere((contact) {
        String searchTerm = searchController.text.toLowerCase();
        String searchTermFlatten = flattenPhoneNumber(searchTerm);
        String contactName = contact.displayName.toLowerCase();
        bool nameMatches = contactName.contains(searchTerm);
        if (nameMatches == true) {
          return true;
        }

        if (searchTermFlatten.isEmpty) {
          return false;
        }

        var phone = contact.phones.firstWhere((phn) {
          String phnFlattened = flattenPhoneNumber(phn.value);
          return phnFlattened.contains(searchTermFlatten);
        }, orElse: () => null);

        return phone != null;
      });
    }
    setState(() {
      contactsFiltered = _contacts;
    });
  }

  String FName;
  String LName;
  int Phone;
  int Age;

  void _addPersonHiveInit(context) {
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
    // Future.delayed(const Duration(seconds: 2), (){});
    // Navigator.of(context).pop();
  }

  getAllContacts() async {
    List colors = [Colors.green, Colors.indigo, Colors.yellow, Colors.orange];
    int colorIndex = 0;
    List<Contact> _contacts = (await ContactsService.getContacts()).toList();
    _contacts.forEach((contact) {
      //Color baseColor = colors[colorIndex];
      //contactsColorMap[contact.displayName] = baseColor;
      //colorIndex++;
      // if (colorIndex == colors.length) {
      //   colorIndex = 0;
      // }
    });
    setState(() {
      contacts = _contacts;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold();
    // bool isSearching = searchController.text.isNotEmpty;
    // bool listItemsExist = (contactsFiltered.length > 0 || contacts.length > 0);
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text(widget.title),
    //   ),
    //   body: Container(
    //     padding: EdgeInsets.all(20),
    //     child: Column(
    //       children: <Widget>[
    //         Container(
    //           child: TextField(
    //             controller: searchController,
    //             decoration: InputDecoration(
    //                 labelText: 'Search',
    //                 border: new OutlineInputBorder(
    //                     borderSide: new BorderSide(
    //                         color: Theme.of(context).primaryColor)),
    //                 prefixIcon: Icon(Icons.search,
    //                     color: Theme.of(context).primaryColor)),
    //           ),
    //         ),
    //         listItemsExist == true
    //             ? Expanded(
    //                 child: ListView.builder(
    //                   shrinkWrap: true,
    //                   itemCount: isSearching == true
    //                       ? contactsFiltered.length
    //                       : contacts.length,
    //                   itemBuilder: (context, index) {
    //                     Contact contact = isSearching == true
    //                         ? contactsFiltered[index]
    //                         : contacts[index];
    //
    //                     var baseColor =
    //                         contactsColorMap[contact.displayName] as dynamic;
    //
    //                     Color color1 = baseColor[800];
    //                     Color color2 = baseColor[400];
    //                     return ListTile(
    //                         title: Text(contact.displayName),
    //                         subtitle: Text(contact.phones.length > 0
    //                             ? contact.phones.elementAt(0).value
    //                             : ''),
    //                         leading: (contact.avatar != null &&
    //                                 contact.avatar.length > 0)
    //                             ? CircleAvatar(
    //                                 backgroundImage:
    //                                     MemoryImage(contact.avatar),
    //                               )
    //                             : Container(
    //                                 decoration: BoxDecoration(
    //                                     shape: BoxShape.circle,
    //                                     gradient: LinearGradient(
    //                                         colors: [
    //                                           color1,
    //                                           color2,
    //                                         ],
    //                                         begin: Alignment.bottomLeft,
    //                                         end: Alignment.topRight)),
    //                                 child: CircleAvatar(
    //                                     child: Text(contact.initials(),
    //                                         style:
    //                                             TextStyle(color: Colors.white)),
    //                                     backgroundColor: Colors.transparent)));
    //                   },
    //                 ),
    //               )
    //             : Expanded(
    //                 child: Center(
    //                   child: CircularProgressIndicator(),
    //                 ),
    //               ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
