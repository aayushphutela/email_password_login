import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

enum ImageSourceType { gallery, camera }

class ImageFromGalleryEx extends StatefulWidget {
  final type;
  final Function(XFile image,String imgUrl) func;
  ImageFromGalleryEx(this.type, this.func);

  @override
  ImageFromGalleryExState createState() => ImageFromGalleryExState();
}

class ImageFromGalleryExState extends State<ImageFromGalleryEx> {
  File? _image;
  var imagePicker;

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    imagePicker = new ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 20),
        Center(
          child: GestureDetector(
            onTap: () async {
              var source = widget.type == ImageSourceType.camera
                  ? ImageSource.camera
                  : ImageSource.gallery;
              XFile image = await imagePicker.pickImage(
                  source: source,
                  imageQuality: 50,
                  preferredCameraDevice: CameraDevice.front);
              setState(() {
                _image = File(image.path);
                uploadImage();
              });
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(color: Colors.red[200]),
                  child: Container(
                    decoration: BoxDecoration(color: Colors.red[200]),
                    width: 200,
                    height: 200,
                    child: Icon(
                      widget.type == ImageSourceType.camera
                          ? Icons.camera_alt
                          : Icons.browse_gallery,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
                Text(
                  widget.type == ImageSourceType.camera ? 'Camera' : 'Gallery',
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  uploadImage() async {
    try {
      firebase_storage.UploadTask task =
      await uploadImageToTheFirebase(_image!);
      if (task != null) {
        // if (mounted) {
        //   setState(() {
        //     _uploadTasks = [..._uploadTasks, task];
        //   });
        // }

        uploadImageToTheFirebase(_image!);

        task.whenComplete(() async {
          String finalUrl = await getUrl(task.snapshot.ref);
          widget.func(XFile(_image!.path),finalUrl);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<firebase_storage.UploadTask> uploadImageToTheFirebase(
      File file) async {
    if (file == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No file was selected'),
      ));
    }

    firebase_storage.UploadTask uploadTask;
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('images')
        .child('/' + file.path.split('/').last);

    final metadata = firebase_storage.SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': file.path});

    uploadTask = ref.putFile(file, metadata);

    return Future.value(uploadTask);
  }

  Future<String> getUrl(firebase_storage.Reference ref) async {
    try {
      final link = await ref.getDownloadURL();
      return link;
    } catch (e) {
      getUrl(ref);
    }
    return '';
  }
}
