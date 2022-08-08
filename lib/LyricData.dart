import 'package:flutter/material.dart';
import 'package:musicme/BookMarked.dart';
import 'dart:convert';
import 'package:musicme/MData';
import 'package:http/http.dart' as http;
import 'package:musicme/UserSimplePreference.dart';

class LyricData extends StatelessWidget {
  final MusicDat mus;
  LyricData({Key? key, required this.mus}) : super(key: key) {
    getval(mus.trackid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.bookmark,
              color: Colors.white,
            ),
            onPressed: () async {
              await UserSimplePreference.init();
              // do something
              List<String> ls = [];
              ls.add(mus.trackname);
              await UserSimplePreference.setTrack(ls);
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const BookMark()));
            },
          )
        ],
        backgroundColor: Colors.grey,
        title: const Text(
          "MusicMe",
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
            child: Container(
          margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10, 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Name',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 5, 0, 8),
                child: Text(mus.trackname),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Artist',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 5, 0, 8),
                child: Text(mus.atristname),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Album Name',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 5, 0, 8),
                child: Text(mus.albumname),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Explicit',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 5, 0, 8),
                child: Text(mus.explicit == 0 ? "false" : "true"),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Rating',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 5, 0, 8),
                child: Text(mus.rating.toString()),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Lyrics',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ),
              FutureBuilder(
                future: getval(mus.trackid),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.data != null) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, i) {
                        return SingleChildScrollView(
                            child: Text(snapshot.data[0]));
                      },
                    );
                  } else {
                    return const Center(
                      child: Text('Lyrics Not Available'),
                    );
                  }
                },
              ),
            ],
          ),
        )),
      ),
    );
  }
}

Future getval(trackid) async {
  List<dynamic> ar = [];
  var url = 'https://api.musixmatch.com/ws/1.1/track.lyrics.get?track_id=' +
      (trackid).toString() +
      '&apikey=2d782bc7a52a41ba2fc1ef05b9cf40d7';
  var response = await http.get(Uri.parse(url));
  var jsondata = jsonDecode(response.body);
  // List<LdData> ls = [];
  if (jsondata == null) {
    //  print('nulla');
  } else {
    // var mss = ;
    // var bdy = mss;
    var ls = jsondata['message']['body']['lyrics']['lyrics_body'];
    //  print(ls);
    ar.add(ls);
  }
  return ar;
}
