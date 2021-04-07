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
  List<String> audiofolders = ["audio3", "audio", "audio1"];
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
            child: ListView.builder(
              itemCount: audiofolders.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: Icon(Icons.folder),
                    title: Text(audiofolders[index]),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AudioList(
                            isAdmin: widget.isAdmin,
                            foldername: audiofolders[index],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            )),
      ),
    );
  }
}
