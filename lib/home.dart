// import 'dart:html';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_first_app/main.dart';
import 'package:image_picker/image_picker.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _loading = true;
  File? _image;
  final imagePicker = ImagePicker();
  _loadimage_gallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) {
      return null;
    } else {
      setState(() {
        _loading = false;
      });
      _image = File(image.path);
    }
  }

  _loadimage_camera() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) {
      return null;
    } else {
      setState(() {
        _loading = false;
      });
      _image = File(image.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black45,
        title: Center(child: Text('ML Classifier')),
      ),
      body: Container(
        height: h,
        width: w,
        color: Colors.black,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Container(
            height: 180,
            width: 180,
            padding: EdgeInsets.all(10),
            child: Image.asset('assets/ml.jpg'),
            // color: Colors.lightBlue,
          ),
          Container(
            child: Text(
              'Land Classification',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: double.infinity,
            height: 70,
            padding: EdgeInsets.all(10),
            child: FloatingActionButton(
                onPressed: () {
                  _loadimage_camera();
                },
                // color: Colors.teal,
                child: Text(
                  'Camera',
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
          ),
          Container(
            width: double.infinity,
            height: 70,
            padding: EdgeInsets.all(10),
            child: FloatingActionButton(
                onPressed: () {
                  _loadimage_gallery();
                },
                // color: Colors.teal,
                child: Text(
                  'Gallery',
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
          ),
          SizedBox(
            height: 10,
          ),
          _loading == false
              ? Container(
                  height: 250,
                  width: 250,
                  color: Colors.red,
                  child: Image.file(_image!),
                )
              : Container(
                  child: Text(""),
                )
        ]),
      ),
    );
  }
}
