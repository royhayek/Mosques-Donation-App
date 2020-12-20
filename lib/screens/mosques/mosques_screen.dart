import 'package:flutter/material.dart';

import '../mosques/widgets/mosque_list_item.dart';

class MosquesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mosques'.toUpperCase()),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          MosqueListItem(),
          MosqueListItem(),
          MosqueListItem(),
          MosqueListItem(),
          MosqueListItem(),
        ],
      ),
    );
  }
}
