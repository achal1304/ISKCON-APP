import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:font_awesome_flutter/fa_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:login/audiolist.dart';

class AudioFoldersList extends StatefulWidget {
  final bool isAdmin;

  const AudioFoldersList({Key key, @required this.isAdmin}) : super(key: key);
  @override
  _AudioFoldersListState createState() => _AudioFoldersListState();
}

class _AudioFoldersListState extends State<AudioFoldersList> {
  getData() async {
    final QuerySnapshot result =
        await Firestore.instance.collection('myCollection').getDocuments();
    audiofolders = result.documents;
  }

  List<DocumentSnapshot> audiofolders;
  @override
  void initState() {
    getData();
    super.initState();
  }

  // List<String> audiofolders = ["audio3", "audio", "audio1"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Audio Streams',
          style: TextStyle(color: Colors.black),
          textScaleFactor: 1.2,
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: FaIcon(Icons.arrow_back_ios),
          color: Colors.black,
          iconSize: 35,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(5.0),
          child: FutureBuilder<QuerySnapshot>(
            future: Firestore.instance.collection("FolderNames").getDocuments(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              // if (snapshot.hasData){
              //   QuerySnapshot documents = snapshot.data;
              //   List<DocumentSnapshot> docs = documents.documents;
              // }
              if (snapshot.hasError) return Text('Error: ${snapshot.error}');
              if (snapshot.data.documents.length == 0) return Text("No Data");
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Text('Loading...');
                default:
                  return ListView(
                    children: snapshot.data.documents
                        .map((DocumentSnapshot document) {
                      return Card(
                          child: ListTile(
                        leading: Icon(Icons.folder),
                        title: Text(document["Name"]),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AudioList(
                                isAdmin: widget.isAdmin,
                                foldername: document["Name"],
                              ),
                            ),
                          );
                        },
                      ));
                    }).toList(),
                  );
              }
            },
          ),
          //  ListView.builder(
          //   itemCount: audiofolders.length,
          //   itemBuilder: (context, index) {
          //     return Card(
          //       child: ListTile(
          //         leading: Icon(Icons.folder),
          //         title: Text(audiofolders[index]),
          //         onTap: () {
          //           Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //               builder: (context) => AudioList(
          //                 isAdmin: widget.isAdmin,
          //                 foldername: audiofolders[index],
          //               ),
          //             ),
          //           );
          //         },
          //       ),
          //     );
          //   },
          // )
        ),
      ),
    );
  }
}
