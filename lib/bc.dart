import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';



_initializeFlutterDownloader()async{
    WidgetsFlutterBinding.ensureInitialized();
await FlutterDownloader.initialize();
}



class OnlineList extends StatefulWidget {

  @override
  _OnlineListState createState() => _OnlineListState();
}

class _OnlineListState extends State<OnlineList> {
  ReceivePort _port = ReceivePort();

  @override
  void initState() {
    super.initState();
    _downloadListener();
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send?.send([id, status, progress]);
  }

  _downloadListener() {
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      if (status.toString() == "DownloadTaskStatus(3)") {
        FlutterDownloader.open(taskId: id);
      }
    });
    FlutterDownloader.registerCallback(downloadCallback);
  }

  void _download() async {
    String _localPath =
        (await findLocalPath()) + Platform.pathSeparator + 'Example_Downloads';

    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
    String _url =
        "https://www.colonialkc.org/wp-content/uploads/2015/07/Placeholder.png";
    final download = await FlutterDownloader.enqueue(
      url: _url,
      savedDir: _localPath,
      showNotification: true,
      openFileFromNotification: true,
    );
  }

  Future<String> findLocalPath() async {
    final directory =
        // (MyGlobals.platform == "android")
        // ?
        await getExternalStorageDirectory();
    // : await getApplicationDocumentsDirectory();
    return directory!.path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _download,
        child: Icon(Icons.file_download),
      ),
    );
  }
}