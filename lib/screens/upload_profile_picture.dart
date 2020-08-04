import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
//import 'signup.dart';

//Selector Class
class UploadProfilePicture extends StatefulWidget {
  @override
  _UploadProfilePictureState createState() => _UploadProfilePictureState();
}

class _UploadProfilePictureState extends State<UploadProfilePicture> {
  File _imageFile;

  final imagePicker = ImagePicker();

  _pickImage(ImageSource source) async {
    final pickedFile = await imagePicker.getImage(source: source);

    setState(() {
      _imageFile = File(pickedFile.path);
    });
  }

  _cropImage() async {
    File cropped = await ImageCropper.cropImage(
      sourcePath: _imageFile.path,
      // ratioX: 1.0,
      // ratioY: 1.0,
      // maxWidth: 512,
      // maxHeight: 512,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      androidUiSettings: AndroidUiSettings(
        toolbarColor: Colors.deepOrangeAccent,
        toolbarWidgetColor: Colors.white,
        toolbarTitle: 'Cropper',
      ),
    );

    setState(() {
      _imageFile = cropped ?? _imageFile;
    });
  }

  _clear() {
    setState(() => _imageFile = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          (_imageFile != null)
              ? Padding(
                  padding: EdgeInsets.only(top: 30.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height * 0.7,
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Image.file(_imageFile),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          FlatButton(
                            color: Colors.black,
                            child: Icon(
                              Icons.crop,
                              color: Colors.white,
                            ),
                            onPressed: _cropImage,
                          ),
                          FlatButton(
                            color: Colors.black,
                            child: Icon(
                              Icons.refresh,
                              color: Colors.white,
                            ),
                            onPressed: _clear,
                          ),
                        ],
                      ),
                      FlatButton(
                        color: Colors.green,
                        child: Text(
                          'Done',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () => Navigator.pop(context, _imageFile),
                      ),
                    ],
                  ),
                )
              : Container()
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: <Widget>[
            Expanded(
              child: IconButton(
                icon: Icon(Icons.photo_camera),
                onPressed: () => _pickImage(ImageSource.camera),
              ),
            ),
            Container(
              width: 1,
              height: 30,
              color: Colors.grey,
            ),
            Expanded(
              child: IconButton(
                icon: Icon(Icons.photo_library),
                onPressed: () => _pickImage(ImageSource.gallery),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
