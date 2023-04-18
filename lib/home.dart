import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:my_first_app/main.dart';
import 'package:tflite/tflite.dart';
// import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image_picker/image_picker.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List? _outputs;
  File? _image;
  bool _loading = false;
  @override
  void initState() {
    super.initState();
    _loading = false;
    loadModel().then((value) {
      setState(() {
        _loading = false;
      });
    });
  }

  _loadimage_gallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) {
      return null;
    } else {
      setState(() {
        _loading = false;
      });
      _image = File(image.path);
      classifyImage(_image!);
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
      classifyImage(_image!);
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
      body: _loading
          ? Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
          : Container(
              height: h,
              width: w,
              color: Colors.black,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
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
                    _image != null
                        ? Container(
                            height: 200,
                            width: 200,
                            child: Image.file(_image!),
                          )
                        : Container(),
                    SizedBox(
                      height: 8,
                    ),
                    _image != null
                        ? Container(
                            child: Text("Result"),
                          )
                        : Container(),
                    _outputs != null
                        ? Text(
                            "${_outputs![0]["label"]}",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                              background: Paint()..color = Colors.white,
                            ),
                          )
                        : Container(),
                  ]),
            ),
    );
  }

  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _loading = false;
      _outputs = output;
    });
  }

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/model.tflite",
      labels: "assets/labels.txt",
    );
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }
}
