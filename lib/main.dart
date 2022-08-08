import 'dart:async';
import 'dart:convert';
// import 'package:path/path.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:musicme/LyricData.dart';
import 'package:musicme/MData';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late StreamSubscription subscription;
  var isdeviceconn = false;
  bool isalert = false;

  @override
  void initState() {
    getConnectivity();
    super.initState();
  }

  getConnectivity() => subscription = Connectivity()
          .onConnectivityChanged
          .listen((ConnectivityResult result) async {
        isdeviceconn = await InternetConnectionChecker().hasConnection;
        if (!isdeviceconn && isalert == false) {
          showDialogBox();
          setState(() => isalert = true);
        }
      });
  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  Future getMusicData() async {
    var url =
        'https://api.musixmatch.com/ws/1.1/chart.tracks.get?apikey=2d782bc7a52a41ba2fc1ef05b9cf40d7&page_size=50';
    var response = await http.get(Uri.parse(url));
    var jsondata = jsonDecode(response.body);

    List<MusicDat> arraylist = [];
    if (jsondata == null) {
      //  print('nulla');
    } else {
      // var mss = ;
      // var bdy = mss;
      List<dynamic> ls = jsondata['message']['body']['track_list'];
      for (var v in ls) {
        var x = v['track'];
        MusicDat musicData = MusicDat(
            x['track_id'],
            x['track_name'],
            x['album_name'],
            x['artist_name'],
            x['explicit'],
            x['track_rating']);
        //  print(x['artist_name']);
        arraylist.add(musicData);
      }
      //  print(arraylist.length);
    }
    return arraylist;
  }

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
            future: getMusicData(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.data != null) {
                return ListView.separated(
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, i) {
                    return ListTile(
                      title: Text(snapshot.data[i].trackname),
                      subtitle: Text(snapshot.data[i].albumname),
                      trailing: Text(snapshot.data[i].atristname),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                LyricData(mus: snapshot.data[i])));
                      },
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
        ));
  }

  showDialogBox() => showCupertinoDialog<String>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text('No Connection'),
          content: const Text('Please check your internet connection'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.pop(context, 'Cancel');
                setState(() {
                  isalert = false;
                });
                isdeviceconn = await InternetConnectionChecker().hasConnection;
                if (!isdeviceconn) {
                  showDialogBox();
                  setState(() {
                    isalert = true;
                  });
                }
              },
              child: const Text('Ok'),
            )
          ],
        ),
      );
}
