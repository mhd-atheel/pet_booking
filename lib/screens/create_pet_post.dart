import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class CreatePetPost extends StatefulWidget {
  const CreatePetPost({super.key});

  @override
  State<CreatePetPost> createState() => _CreatePetPostState();
}

class _CreatePetPostState extends State<CreatePetPost> {

  // instances
  final imagePicker = ImagePicker();
  bool isLoading = false;
  File? _image;
  String? downloadURL;
  List<String> list = ['Male', 'Female',];
  String dropdownValue = "Male";

  //  TextEditingController
  final descriptionController = TextEditingController();
  final nameController = TextEditingController();



  Future imagePickerMethod(source) async {
    final pick = await imagePicker.pickImage(source: source);
    setState(() {
      if (pick != null) {
        _image = File(pick.path);
        print(_image);
      }
      // else{
      //   showSnackBars("No File Selected", Duration(milliseconds: 400));
      // }
    });
  }

  createPost (){

  }
  Future uploadImage() async {
    final  posttime = DateTime.now().millisecondsSinceEpoch.toString();
    Reference ref = FirebaseStorage.instance.ref().child('posts').child(posttime);
    await ref.putFile(_image!).whenComplete(() => print("complete"));
    downloadURL = await ref.getDownloadURL();
    print(downloadURL);
  }



  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 150,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(
                        left: 15.0, top: 10, right: 15, bottom: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Select Image From"),
                      ],
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          Navigator.pop(context);
                          imagePickerMethod(ImageSource.camera);
                        },
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.camera,
                              size: 50,
                            ),
                            Text(
                              "Camera",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          imagePickerMethod(ImageSource.gallery);
                        },
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.image,
                              size: 50,
                            ),
                            Text(
                              "Gallery",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create post".toUpperCase()),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 15.0, top: 10, right: 15),
              child: Row(
                children: [
                  Text("Name"),
                ],
              ),
            ),
            Image.asset('assets/images/image1.png'),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 5, right: 15),
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    // 0xfff2f2f2  - like a gray
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.black54)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, top: 0),
                  child: TextFormField(
                      decoration: const InputDecoration(
                    hintText: 'your pet name',
                    labelStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  )),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15.0, top: 10, right: 15),
              child: Row(
                children: [
                  Text("Age"),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 5, right: 15),
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    // 0xfff2f2f2  - like a gray
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.black54)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, top: 0),
                  child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'your pet age',
                        labelStyle: TextStyle(color: Colors.grey.shade50),
                        border: InputBorder.none,
                      )),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15.0, top: 10, right: 15),
              child: Row(
                children: [
                  Text("Breed"),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 5, right: 15),
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    // 0xfff2f2f2  - like a gray
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.black54)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, top: 0),
                  child: TextFormField(
                      decoration: InputDecoration(
                    hintText: 'your pet breed',
                    labelStyle: TextStyle(color: Colors.grey.shade50),
                    border: InputBorder.none,
                  )),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15.0, top: 10, right: 15),
              child: Row(
                children: [
                  Text("Color"),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 5, right: 15),
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  // 0xfff2f2f2  - like a gray
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.black54)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, top: 0),
                  child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'your pet color',
                        labelStyle: TextStyle(color: Colors.grey.shade50),
                        border: InputBorder.none,
                      )),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15.0, top: 10, right: 15),
              child: Row(
                children: [
                  Text("Description"),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 5, right: 15),
              child: Container(
                height: 100,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    // 0xfff2f2f2  - like a gray
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.black54)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, top: 0),
                  child: TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      hintText: 'write..',
                      labelStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                    minLines: 1,
                    maxLines: 5,
                  ),
                ),
              ),
            ),
        
            const Padding(
              padding: EdgeInsets.only(left: 15.0, top: 10, right: 15),
              child: Row(
                children: [
                  Text("Sex"),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 5, right: 15),
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  // 0xfff2f2f2  - like a gray
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.black54)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: dropdownValue,
                    icon: const Icon(Icons.keyboard_arrow_down_outlined),
                    elevation: 16,
                    style:  TextStyle(color: Colors.grey.shade900),
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        dropdownValue = value!;
                      });
                    },
                    items: list.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15.0, top: 10, right: 15),
              child: Row(
                children: [
                  Text("Select Image"),
                ],
              ),
            ),
        
            GestureDetector(
              onTap: () {
                _settingModalBottomSheet(context);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        // 0xfff2f2f2  - like a gray
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.black54)),
                    child: _image == null
                        ? const SizedBox(
                            height: 150,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.image,
                                    size: 50,
                                  ),
                                  Text("Select Image")
                                ],
                              ),
                            ),
                          )
                        : Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Image.file(_image!),
                              ),
                              const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.image,
                                      size: 50,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      "Select Image",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                              Positioned(
                                  top: 10,
                                  right: 5,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _image = null;
                                      });
                                    },
                                    child: const CircleAvatar(
                                        backgroundColor: Colors.white,
                                        child: Icon(Icons.close)),
                                  ))
                            ],
                          )),
              ),
            ),
            GestureDetector(
              onTap: (){
                uploadImage();
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15,top: 15),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(10)),
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                      child: isLoading==false ?const Text(
                         'Create',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20
                        ),
                      ):const CircularProgressIndicator()),
                ),
              ),
            ),
            const SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }
}
