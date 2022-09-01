  //   'https://www.w3schools.com/howto/img_forest.jpg',
  //   'https://cdn.pixabay.com/photo/2015/12/01/20/28/road-1072823__480.jpg',
  //   'https://cdn.pixabay.com/photo/2014/02/27/16/10/flowers-276014__480.jpg',
  //   'https://cdn.pixabay.com/photo/2014/04/14/20/11/pink-324175__480.jpg',
  // ];
import 'dart:io';
import 'package:android_path_provider/android_path_provider.dart';
import 'package:dio/dio.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'offline_downloads.dart';

class OnlineList extends StatefulWidget with WidgetsBindingObserver {
  @override
  _OnlineListState createState() => _OnlineListState();
}

class _OnlineListState extends State<OnlineList> {
  final _urls = [
    'https://www.w3schools.com/howto/img_forest.jpg',
    'https://cdn.pixabay.com/photo/2015/12/01/20/28/road-1072823__480.jpg',
    'https://cdn.pixabay.com/photo/2014/02/27/16/10/flowers-276014__480.jpg',
    'https://cdn.pixabay.com/photo/2014/04/14/20/11/pink-324175__480.jpg',
  ];
   TargetPlatform? platform;

   @override
  void initState() {
    // TODO: implement initState
    super.initState();
        if (Platform.isAndroid) {
      platform = TargetPlatform.android;
    } else {
      platform = TargetPlatform.iOS;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Online links'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OfflineDownloads(),
          ),
        ),
        label: Text('Downloads'),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: _urls.length,
          itemBuilder: (BuildContext context, int i) {
            String _fileName = 'File ${i + 1}';
            return Card(
              elevation: 10,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(_fileName),
                      ),
                      RawMaterialButton(
                        textStyle: TextStyle(color: Colors.blueGrey),
                        onPressed: () => requestDownload(_urls[i], _fileName),
                        child: Icon(Icons.file_download),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> requestDownload(String _url, String _name) async {
    
  PermissionStatus status = await Permission.storage.request();
    // var status=await Permission;
//     Future getStoragePermission() async {
//   //PermissionStatus status1 = await Permission.accessMediaLocation.request();
//   PermissionStatus status2 = await Permission.manageExternalStorage.request();
//   print('status $status   -> $status2');
//   if (status.isGranted && status2.isGranted) {
//     return true;
//   } else if (status.isPermanentlyDenied || status2.isPermanentlyDenied) {
//     await openAppSettings();
//   } else if (status.isDenied) {
//     print('Permission Denied');
//   }
// }
// var per=await getStoragePermission();


    if(status.isGranted){
      final baseStorage=await getExternalStorageDirectories(type: StorageDirectory.downloads);
      //  Directory? tempDir = await  DownloadsPathProvider.downloadsDirectory;
          //  final String? _downloadPath = await FileUtils.getDownloadPath;

// final _ = getExternalStorageDirectories(type: StorageDirectory.downloads);

    // final dir =
    //       await getApplicationDocumentsDirectory(); //From path_provider package
    // String _temp=await _findLocalPath();
    String path=baseStorage[0].path;
    var _localPath = _temp + _name;
    String tempPath = tempDir!.path;
    var filePath = baseStorage["_path"] + _name;
    final savedDir = Directory(filePath);
    await Dio().download(_url,
                  filePath +".jpg");
              print("Download Completed.");
    await savedDir.create(recursive: true).then((value) async {
      String? _taskid = await FlutterDownloader.enqueue(
        url: _url,
        fileName: _name,
        savedDir: _downloadPath!,
        showNotification: true,
        openFileFromNotification: true,
      );  
      print(_taskid);
    });
    }
  
  }
   Future<String> _findLocalPath() async {
    if (platform == TargetPlatform.android) {
      return "/storage/emulated/0/Downloads";
    } else {
      var directory = await getApplicationDocumentsDirectory();
      return directory.path + Platform.pathSeparator + 'Download';
    }
  }
}}




// class FileUtils {
//   static Future<String?> get getDownloadPath async {
//     String? externalStorageDirPath;
//     if (Platform.isAndroid) {
//       try {
//         externalStorageDirPath = await AndroidPathProvider.downloadsPath;
//       } catch (e) {
//         final directory = await getExternalStorageDirectory();
//         externalStorageDirPath = directory?.path;
//       }
//     } else if (Platform.isIOS) {
//       externalStorageDirPath =
//           (await getApplicationDocumentsDirectory()).absolute.path;
//     }
//     if (externalStorageDirPath != null) {
//       final savedDir = Directory(externalStorageDirPath);
//       final hasExisted = savedDir.existsSync();
//       if (!hasExisted) {
//         await savedDir.create();
//       }
//     }
//     return externalStorageDirPath;
//   }
// }