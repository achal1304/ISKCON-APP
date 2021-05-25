import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';

//import 'package:font_awesome_flutter/fa_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:login/crud.dart';
import 'package:random_color/random_color.dart';

class AddAudio extends StatefulWidget {
  AddAudio() : super();

  final String title = 'Upload Audio';

  @override
  AddAudioState createState() => AddAudioState();
}

class AddAudioState extends State<AddAudio> {
  String fileUrl = "";
  String name = "";
  TextEditingController _chosenValue = TextEditingController();
  TextEditingController controller = TextEditingController();
  String _path;
  String existingfolder;
  Map<String, String> _paths;
  String _extension;
  FileType _pickType = FileType.audio;
  bool _multiPick = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  List<StorageUploadTask> _tasks = <StorageUploadTask>[];
  bool isEditable = false;

  void openFileExplorer() async {
    name = controller.text;
    _path = null;

    _path = await FilePicker.getFilePath(type: _pickType);

    uploadToFirebase(name);
  }

  uploadToFirebase(String name) {
    String fileName = _path.split('/').last;
    String filePath = _path;
    List<String> arr = [];
    String finalfolder;
    if (isEditable == true && _chosenValue.text.isNotEmpty) {
      finalfolder = _chosenValue.text;
    } else if (isEditable == false) {
      finalfolder = existingfolder;
    }
    for (int i = 0; i < name.length; i++) {
      arr.insert(i, name.substring(0, name.length - i));
    }

    upload(fileName, filePath).then((v) {
      setState(() {
        fileUrl = v;
        Crud().addAudioUrl(name, fileUrl, finalfolder, arr);
        Crud().addFolderList(finalfolder);
      });
    });
  }

  Future<String> upload(fileName, filePath) async {
    String foldern = _chosenValue.text;
    String uploadPath = '/$foldern/$fileName';
    _extension = fileName.toString().split('.').last;
    StorageReference storageRef =
        FirebaseStorage.instance.ref().child(uploadPath);
    final StorageUploadTask uploadTask = storageRef.putFile(File(filePath));
    setState(() {
      _tasks.add(uploadTask);
    });
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());

    return url;
  }

  String _bytesTransferred(StorageTaskSnapshot snapshot) {
    return '${snapshot.bytesTransferred}/${snapshot.totalByteCount}';
  }

  // String _chosenValue = "audio";

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[];
    _tasks.forEach((StorageUploadTask task) {
      final Widget tile = UploadTaskListTile(
        task: task,
        onDismissed: () => setState(() => _tasks.remove(task)),
        onDownload: () => downloadFile(task.lastSnapshot.ref),
      );
      children.add(tile);
    });

    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.black),
          //textScaleFactor: 1.2,
        ),
        centerTitle: true,
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
      body: Container(
        padding: EdgeInsets.fromLTRB(
            20, MediaQuery.of(context).size.width * 0.7, 20, 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // DropdownButton<String>(
            //   value: _chosenValue,
            //   items: <String>['audio', 'audio1', 'audio3']
            //       .map<DropdownMenuItem<String>>((String value) {
            //     return DropdownMenuItem<String>(
            //       value: value,
            //       child: Text(value),
            //     );
            //   }).toList(),
            //   onChanged: (String value) {
            //     setState(() {
            //       _chosenValue = value;
            //     });
            //   },
            // ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: TextFormField(
                      autofocus: true,
                      controller: _chosenValue,
                      cursorColor: Colors.blue,
                      enabled: isEditable,
                      decoration: InputDecoration(
                        hintText: 'Create New Folder',
                        labelStyle: TextStyle(color: Colors.orangeAccent),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 8),
                  child: IconButton(
                    icon: Icon(
                      isEditable ? Icons.check : Icons.edit,
                    ),
                    onPressed: () {
                      setState(() {
                        isEditable = !isEditable;
                      });
                    },
                  ),
                )
              ],
            ),

            SizedBox(
              height: 15,
            ),
            StreamBuilder<QuerySnapshot>(
                stream:
                    Firestore.instance.collection('FolderNames').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(
                      child: CupertinoActivityIndicator(),
                    );

                  return Container(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            flex: 2,
                            child: Container(
                              padding:
                                  EdgeInsets.fromLTRB(12.0, 10.0, 10.0, 10.0),
                              child: Text(
                                "Existing Folders",
                              ),
                            )),
                        new Expanded(
                          flex: 4,
                          child: DropdownButton(
                            value: existingfolder,
                            isDense: true,
                            onChanged: (valueSelectedByUser) {
                              _onShopDropItemSelected(valueSelectedByUser);
                            },
                            hint: Text('Choose existing folder'),
                            items: snapshot.data.documents
                                .map((DocumentSnapshot document) {
                              return DropdownMenuItem<String>(
                                value: document.documentID.toString(),
                                child: Text(document.documentID.toString()),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
            SizedBox(
              height: 15,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: TextFormField(
                  autofocus: true,
                  controller: controller,
                  cursorColor: Colors.blue,
                  decoration: InputDecoration(
                    hintText: 'File Name',
                    labelStyle: TextStyle(color: Colors.orangeAccent),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ButtonTheme(
                  minWidth: 250,
                  padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                  child: RaisedButton(
                    shape: StadiumBorder(),
                    //borderSide: BorderSide(color: Colors.black),
                    color: Colors.blue,
                    onPressed: () {
                      if (controller.text.isEmpty) {
                        _scaffoldKey.currentState.showSnackBar(
                          SnackBar(
                            content: Text('Name cannot be Empty!'),
                            duration: Duration(seconds: 3),
                          ),
                        );
                      } else {
                        openFileExplorer();
                      }
                    },
                    child: Text(
                      'Select Audio File',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            Flexible(
              child: ListView(
                children: children,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onShopDropItemSelected(String newValueSelected) {
    setState(() {
      this.existingfolder = newValueSelected;
    });
  }

  Future<void> downloadFile(StorageReference ref) async {
    final String url = await ref.getDownloadURL();
    final http.Response downloadData = await http.get(url);
    final Directory systemTempDir = Directory.systemTemp;
    final File tempFile = File('${systemTempDir.path}/tmp.jpg');
    if (tempFile.existsSync()) {
      await tempFile.delete();
    }
    await tempFile.create();
    final StorageFileDownloadTask task = ref.writeToFile(tempFile);
    final int byteCount = (await task.future).totalByteCount;
    var bodyBytes = downloadData.bodyBytes;
    final String name = await ref.getName();
    final String path = await ref.getPath();
    print(
      'Success!\nDownloaded $name \nUrl: $url'
      '\npath: $path \nBytes Count :: $byteCount',
    );
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        backgroundColor: Colors.white,
        content: Image.memory(
          bodyBytes,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}

class UploadTaskListTile extends StatelessWidget {
  const UploadTaskListTile(
      {Key key, this.task, this.onDismissed, this.onDownload})
      : super(key: key);

  final StorageUploadTask task;
  final VoidCallback onDismissed;
  final VoidCallback onDownload;

  String get status {
    String result;
    if (task.isComplete) {
      if (task.isSuccessful) {
        result = 'Complete';
      } else if (task.isCanceled) {
        result = 'Canceled';
      } else {
        result = 'Failed ERROR: ${task.lastSnapshot.error}';
      }
    } else if (task.isInProgress) {
      result = 'Uploading';
    } else if (task.isPaused) {
      result = 'Paused';
    }
    return result;
  }

  String _bytesTransferred(StorageTaskSnapshot snapshot) {
    int d = snapshot.totalByteCount;
    return ((snapshot.bytesTransferred / d) * 100).toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<StorageTaskEvent>(
      stream: task.events,
      builder: (BuildContext context,
          AsyncSnapshot<StorageTaskEvent> asyncSnapshot) {
        Widget subtitle;
        if (asyncSnapshot.hasData) {
          final StorageTaskEvent event = asyncSnapshot.data;
          final StorageTaskSnapshot snapshot = event.snapshot;
          subtitle = Text('$status: ${_bytesTransferred(snapshot)}% uploaded');
        } else {
          subtitle = const Text('Starting...');
        }
        return Dismissible(
          key: Key(task.hashCode.toString()),
          onDismissed: (_) => onDismissed(),
          child: ListTile(
            title: Text('Upload Task'),
            subtitle: subtitle,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Offstage(
                  offstage: !task.isInProgress,
                  child: IconButton(
                    icon: const Icon(Icons.pause),
                    onPressed: () => task.pause(),
                  ),
                ),
                Offstage(
                  offstage: !task.isPaused,
                  child: IconButton(
                    icon: const Icon(Icons.file_upload),
                    onPressed: () => task.resume(),
                  ),
                ),
                Offstage(
                  offstage: task.isComplete,
                  child: IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () => task.cancel(),
                  ),
                ),
                Offstage(
                  offstage: !(task.isComplete && task.isSuccessful),
                  child: IconButton(
                    icon: const Icon(Icons.check),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
