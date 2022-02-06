import 'dart:convert';
import 'dart:io';
import 'package:crypt/crypt.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mailing/Login_Mailing.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mailing/Validate.dart';
import 'package:photo_view/photo_view.dart';

import 'Constant.dart';


class get_photo {
  File path = File("");
  Future<String> Upload(File imageFile) async {
    if (Validation.isValidnull(imageFile.path)) {
      var secret = Crypt.sha256("put_photo");
      Uri url = Uri(
          host: host,
          path: 'Mailing_API/put_image.php',
          scheme: scheme);
      var response = await http.post(url, body: {
        'image': base64Encode(imageFile.readAsBytesSync()),
        'name': imageFile.path
            .split("/")
            .last,
        'secret': '$secret'
      });
      int status = response.statusCode;
      switch (status) {
        case 200:
          {
            showtoast("Image Uploaded Successfully.");
            return scheme + '://' + host + '/' + 'Mailing_API/Image_File/' +
                imageFile.path
                    .split("/")
                    .last;
          }
        case 403:
          {
            showtoast("Image Uploaded Not Successfully.");
            return "";
          }
        case 101:
          {
            showtoast("Image Uploaded Is Exist in server");
            return "";
          }
        default:
          {
            showtoast(response.reasonPhrase!);
            return "";
          }
      }
    }
    return "";
  }

  /// Get from gallery
  Future<File> _getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    } else {
      return File("");
    }
  }


  /// Get from camera
  Future<File> _getFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera);
    if (pickedFile != null) {
      return File(pickedFile.path);
    } else {
      return File("");
    }
  }

  showSelectionDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("From where do you want to take the photo?"),
              content: SingleChildScrollView(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    GestureDetector(
                      child: Icon(
                        Icons.photo, color: Colors.lightBlueAccent, size: 70,),
                      onTap: () async {
                        path = await _getFromGallery();
                        Navigator.maybePop(context, 'Ok');
                      },
                    ),
                    Padding(padding: EdgeInsets.all(8.0)),
                    GestureDetector(
                      child: Icon(
                        Icons.camera_alt_rounded, color: Colors.redAccent,
                        size: 70,),
                      onTap: () async {
                        path = await _getFromCamera();
                        Navigator.pop(context, 'Ok');
                      },
                    )
                  ],
                ),
              ));
        });
  }
}

class show_photo extends StatefulWidget {
  final String path, type;

  show_photo({required this.path, required this.type});

  @override
  show_photo_state createState() => show_photo_state();

}

class show_photo_state extends State<show_photo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.transparent,
        body: Container(
            child: (widget.type == "N") ?
            PhotoView(imageProvider: NetworkImage(widget.path)) :
                (widget.type == "D") ?
            PhotoView(imageProvider: FileImage(File(widget.path))) :
            PhotoView(imageProvider: AssetImage("images/Untitled.png")
    )
    ,
    )
    ,
    );
  }
}