import 'package:assign1_contacts_app/widgets/personTile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../peopleData.dart';

class PeopleList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: AlwaysScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return PersonTile(
          titleIndex: index,
        );
      },
      itemCount: Provider.of<PeopleData>(context).personCount,
      padding: EdgeInsets.fromLTRB(8.0, 6.0, 8.0, 4.0),
    );
  }
}
