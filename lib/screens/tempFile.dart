import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class TempFile extends StatefulWidget {
  const TempFile({Key? key}) : super(key: key);

  @override
  State<TempFile> createState() => _TempFileState();
}

class _TempFileState extends State<TempFile> {
  File? imgFile;
  final imgPicker = ImagePicker();
  var uploadImageResult;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(
        child: InkWell(
          onTap: () {
            showOptionsDialog(context);
          },
          child: Text(
            "Add Picture",),
          ),
        ),
      );
  }
  Future<void> showOptionsDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Choose your option",
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  GestureDetector(
                    onTap: () {
                      openCamera().then((value) {
                        setState(() {
                          print("UPload image");
                        });
                      });
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.camera_alt_rounded,
                          size: 22,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Capture Image From Camera",
                        ),
                      ],
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(10)),
                  GestureDetector(
                    onTap: () {
                      openGallery().then((value) {
                        setState(() {
                          debugPrint("UPload iMaghe==");
                        });
                      });
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.image,
                          size: 23,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text("Take Image From Gallery"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future openCamera() async {
    var imgCamera = await imgPicker.getImage(source: ImageSource.camera);
    setState(() {
      imgFile = File(imgCamera!.path);
    });
    Navigator.of(context).pop();
  }

  Future openGallery() async {
    var imgGallery = await imgPicker.getImage(source: ImageSource.gallery);
    setState(() {
      imgFile = File(imgGallery!.path);
    });
    Navigator.of(context).pop();
  }

  Widget displayImage() {
    if (imgFile == null) {
      return const CircleAvatar(
        radius: 50,
        child: CircleAvatar(
          backgroundImage: AssetImage("assets/images/profileImage.png"),
          radius: 50,
        ),
      );
    } else {
      return CircleAvatar(
        radius: 50,
        child: CircleAvatar(
          backgroundImage: FileImage(imgFile!),
          radius: 50,
        ),
      );
    }
  }
}
