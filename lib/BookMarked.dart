import 'package:flutter/material.dart';
import 'package:musicme/UserSimplePreference.dart';

class BookMark extends StatelessWidget {
  const BookMark({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: const Text(
          'MusicMe',
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
        centerTitle: true,
      ),
      body: Card(
        child: FutureBuilder(
          future: getval(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.data != null) {
              return ListView.separated(
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (context, i) {
                  return ListTile(
                    title: Text(snapshot.data[i]),
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider();
                },
              );
            } else {
              return const Center(
                child: Text('Loading...'),
              );
            }
          },
        ),
      ),
    );
  }
}

Future getval() async {
  await UserSimplePreference.init();

  return UserSimplePreference.getTracks();
}
