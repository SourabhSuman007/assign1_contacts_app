import 'package:assign1_contacts_app/utils.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:assign1_contacts_app/model/people.dart';

class PeopleData extends ChangeNotifier {
  static const String _boxName = "peopleBox";
  List<Contact> contacts = [];

  List<People> _people = [];
  People _activePerson; //enables when user click the tile

  //to get list of people
  Future<List<People>> getPeoples() async {
    //open the box in hive
    var box = await Hive.openBox<People>(_boxName);
    //put box into list of people
    _people = box.values.toList();
    notifyListeners();
    return (_people);
  }

  Future<List<People>> searchPeople(String fname, String lname) async {
    var box = await Hive.openBox<People>(_boxName);
    _people = box.values.where((People person) {
      return person.fName == fname && person.lName == lname;
    }).toList();
    notifyListeners();
    return (_people);
  }

  Future<List<People>> searchPeopleWithPhone(int phone) async {
    var box = await Hive.openBox<People>(_boxName);
    _people = box.values.where((People person) {
      return person.phone == phone;
    }).toList();
    notifyListeners();
    return (_people);
  }

  //delete all records
  void deleteAll() async{
    var box = await Hive.openBox<People>(_boxName);
    box.deleteAll(box.keys);
    notifyListeners();
  }

  //to get a particular person
  People getPerson(index) {
    //print(_people);
    return _people[index];
  }

  //to add a person
  void addPerson(People person) async {
    //open the box
    var box = await Hive.openBox<People>(_boxName);
    //add person
    await box.add(person);
    //add to list
    _people = box.values.toList();
    notifyListeners();
  }

  //initialize hive
  void iniHive(People person) async {
    var box = await Hive.openBox<People>(_boxName);
    await box.add(person);
    _people = box.values.toList();
    Log.i("Added a member with key" + person.key.toString());
    notifyListeners();
  }

  //to delete a person
  void deletePerson(key) async {
    //open the box
    var box = await Hive.openBox<People>(_boxName);
    //delete from list
    await box.delete(key);
    //now modify the list
    _people = box.values.toList();
    //adding logs
    Log.i("Deleted member with key" + key.toString());
    notifyListeners();
  }

  //to edit a person info
  void editPerson({People person, int personKey}) async {
    //open the box
    var box = await Hive.openBox<People>(_boxName);
    //find that person with key
    await box.put(personKey, person);
    //modify list
    _people = box.values.toList();
    //activating the person
    _activePerson = box.get(personKey);
    //logs stuff
    Log.i("Edited " + person.fName + " " + person.lName);
    notifyListeners();
  }

  //set active person
  void setActivePerson(key) async {
    var box = await Hive.openBox<People>(_boxName);
    _activePerson = box.get(key);
    notifyListeners();
  }

  //get active person
  People getActivePerson() {
    return _activePerson;
  }

  //get total no. of people....a get-method implementation
  int get personCount {
    return _people.length;
  }
}
