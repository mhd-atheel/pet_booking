import 'dart:io';
import 'dart:io';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pet_booking/screens/auth_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // instances
  bool isLoading = false;
  int  tabIndex = 0;
  bool isEditPressed = false;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late String name = '';
  late String email = '';
  late String contact = '';
  late String address = '';

  // image picking and uploading variables
  final imagePicker = ImagePicker();
  File? _image;
  String? downloadURL;

  //TextEditingController
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final contactController = TextEditingController();
  final addressController = TextEditingController();



  // update user
  Future<void> updateUser() async {
    setState(() {
      isLoading = true;
    });
    if (_image == null) {
      await firestore
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'name': nameController.text,
        'email': emailController.text,
        'address': addressController.text,
        'contact': contactController.text,
      }).then((value) {
        setState(() {
          isLoading = false;
          isEditPressed = false;
        });
      });
    } else {
      uploadImage().then((value) async {
        await firestore
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          'name': nameController.text,
          'email': emailController.text,
          'address': addressController.text,
          'contact': contactController.text,
          'image': downloadURL,
        }).then((value) {
          setState(() {
            isLoading = false;
            isEditPressed = false;
          });
        });
      });
    }
  }

  showDetail(key, value) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 20, right: 15),
          child: Row(
            children: [
              Text(key),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 5, right: 15),
          child: Row(
            children: [
              Text(
                value,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                textHeightBehavior: const TextHeightBehavior(
                    applyHeightToFirstAscent: false,
                    applyHeightToLastDescent: false),
              ),
            ],
          ),
        ),
      ],
    );
  }

  showEditDetail(key, value, controller) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 10, right: 15),
          child: Row(
            children: [
              Text(key),
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
                  controller: controller,
                  enabled: key == 'Your Email :-' ? false : true,
                  decoration: InputDecoration(
                    hintText: value,
                    labelStyle: const TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  )),
            ),
          ),
        ),
      ],
    );
  }

  Future imagePickerMethod() async {
    final pick = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pick != null) {
        _image = File(pick.path);
        print(_image);
      } else {
        AnimatedSnackBar.material(
          "Image Not Selected",
          type: AnimatedSnackBarType.error,
        ).show(context);
      }
    });
  }

  Future uploadImage() async {
    final posttime = DateTime.now().millisecondsSinceEpoch.toString();
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('users')
        .child(FirebaseAuth.instance.currentUser!.uid);
    await ref.putFile(_image!).whenComplete(() => print("complete"));
    downloadURL = await ref.getDownloadURL();
    print(downloadURL);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Profile".toUpperCase()),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          if (isEditPressed == false)
            GestureDetector(
              onTap: (){
                if (isEditPressed == false) {
                  print("Edit Button Mode");
                  setState(() {
                    isEditPressed = true;
                  });
                } else {
                  print("Update Button Mode");
                  print(nameController.text);
                  print(emailController.text);
                  print(contactController.text);
                  print(addressController.text);
                  updateUser();
                }
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                child: Icon(
                  FontAwesomeIcons.penToSquare,
                  color: Colors.green,
                ),
              ),
            ),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text("Are you sure?"),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: const Text("Cancel",
                          style: TextStyle(color: Colors.black)),
                    ),
                    TextButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut().then((value) {
                          Get.offAll(const AuthScreen());
                          AnimatedSnackBar.material(
                            "Logout SuccessFully",
                            type: AnimatedSnackBarType.success,
                          ).show(context);
                        });
                      },
                      child: const Text(
                        "Logout",
                        style: TextStyle(color: Colors.orange),
                      ),
                    )
                  ],
                ),
              );
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Icon(
                FontAwesomeIcons.arrowRightFromBracket,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                name = snapshot.data!['name'];
                email = snapshot.data!['email'];
                contact = snapshot.data!['contact'];
                address = snapshot.data!['address'];

                nameController.text = name;
                emailController.text = email;
                contactController.text = contact;
                addressController.text = address;

                return Column(
                  children: [
                    Center(
                        child: isEditPressed == false
                            ? snapshot.data!['image'] == ""
                                ? CircleAvatar(
                                    radius: 50,
                                    backgroundColor: Colors.orange,
                                    child: Text(
                                      snapshot.data!['name']
                                          .toString()
                                          .substring(0, 1)
                                          .toUpperCase(),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold),
                                    ))
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        70), // Image border
                                    child: SizedBox.fromSize(
                                      size: const Size.fromRadius(
                                          70), // Image radius
                                      child: CachedNetworkImage(
                                        imageUrl: snapshot.data!['image'],
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          height: 30,
                                          width: 30,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        placeholder: (context, url) =>
                                            const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: SizedBox(
                                            height: 30.0,
                                            width: 30.0,
                                            child: CircularProgressIndicator(
                                              color: Colors.orange,
                                            ),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    ),
                                  )
                            : GestureDetector(
                                onTap: () {
                                  imagePickerMethod();
                                },
                                child: _image == null
                                    ? const CircleAvatar(
                                        radius: 50,
                                        child: Icon(Icons.add_a_photo_outlined),
                                      )
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(70),
                                        child: SizedBox.fromSize(
                                          size: const Size.fromRadius(70),
                                          child: Image.file(
                                            _image!,
                                            width: 30,
                                            height: 30,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                              )),
                    if (isEditPressed == false)
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, top: 15, right: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              name.toUpperCase(),
                              style: const TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                              textHeightBehavior: const TextHeightBehavior(
                                  applyHeightToFirstAscent: false,
                                  applyHeightToLastDescent: false),
                            ),
                          ],
                        ),
                      ),
                    if (isEditPressed == false)
                      Column(
                        children: [
                          showDetail("Your Email :-", snapshot.data!['email']),
                          showDetail(
                              "Contact Number :-", snapshot.data!['contact']),
                          showDetail("Residential Address :-",
                              snapshot.data!['address']),
                        ],
                      ),
                    if (isEditPressed == true)
                      Column(
                        children: [
                          showEditDetail("Your Name :-", name, nameController),
                          showEditDetail(
                              "Your Email :-", email, emailController),
                          showEditDetail(
                              "Contact Number :-", contact, contactController),
                          showEditDetail("Residential Address :-", address,
                              addressController),
                        ],
                      ),
                    if (isEditPressed == true)
                      GestureDetector(
                        onTap: () {
                          if (isEditPressed == false) {
                            print("Edit Button Mode");
                            setState(() {
                              isEditPressed = true;
                            });
                          } else {
                            print("Update Button Mode");
                            print(nameController.text);
                            print(emailController.text);
                            print(contactController.text);
                            print(addressController.text);
                            updateUser();
                          }
                        },
                        child: Padding(
                          padding:
                          const EdgeInsets.only(left: 15, right: 15, top: 30),
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(10)),
                            width: MediaQuery.of(context).size.width,
                            child: Center(
                                child: isLoading == false
                                    ? Text(
                                  isEditPressed == false
                                      ? 'Edit'
                                      : "Update",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 20),
                                )
                                    : const SizedBox(
                                  height: 30.0,
                                  width: 30.0,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )),
                          ),
                        ),
                      ),

                    if (isEditPressed == true)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isEditPressed = false;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, top: 10),
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border:
                                    Border.all(color: Colors.orange, width: 1),
                                borderRadius: BorderRadius.circular(10)),
                            width: MediaQuery.of(context).size.width,
                            child: const Center(
                                child: Text(
                              "Cancel",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                  fontSize: 20),
                            )),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(
              height: 20,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: (){
                    setState(() {
                      tabIndex = 0;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 15),
                    decoration: BoxDecoration(
                      color: tabIndex ==0 ? Colors.orange:Colors.white,
                      borderRadius: BorderRadius.circular(15)
                    ),
                    child: Text(
                      "Your Posts",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: tabIndex ==0 ? Colors.white :Colors.orange
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    setState(() {
                      tabIndex = 1;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 15),
                    decoration: BoxDecoration(
                        color: tabIndex ==1 ? Colors.orange:Colors.white,
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: Text(
                      "Feedbacks",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: tabIndex ==1 ? Colors.white :Colors.orange
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width/11
              ),
              child: const Divider(
                color: Colors.grey,
              ),
            ),
            tabIndex == 0? StreamBuilder(
              stream:
                   FirebaseFirestore.instance
                  .collection('posts').where('userId', isEqualTo:FirebaseAuth.instance.currentUser!.uid).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if(snapshot.data!.docs.isEmpty){
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20,),
                      Image.asset('assets/images/logo.png',
                        height: 50,
                      ),
                      const Center(child: Text('Not Found')),
                    ],
                  );
                }
                final orders = snapshot.data!.docs;

                return ListView.builder(
                    itemCount: orders.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context,index){
                      return StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance.collection('users').doc(orders[index]['userId']).snapshots(),
                        builder: (context, userSnapshot) {
                          if (userSnapshot.connectionState == ConnectionState.waiting) {
                            return Container();
                          }

                          final userData = userSnapshot.data!.data() as Map<String, dynamic>;

                          return  Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: const Color(0xff0E1041)),
                                borderRadius: BorderRadius.circular(10)),
                            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                            child: Column(
                              children: [
                                ListTile(
                                  title:Text(userData['name']),
                                  subtitle: Text(orders[index]['createdAt'].toDate().toString().substring(0,10)),
                                  leading: userData['image'] == ''?CircleAvatar(
                                      radius: 22,
                                      backgroundColor: Colors.orange,
                                      child: Text(
                                        userData['name'].toString().substring(0,1).toUpperCase(),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ))
                                      :  ClipRRect(
                                    borderRadius: BorderRadius.circular(22), // Image border
                                    child: SizedBox.fromSize(
                                      size: const Size.fromRadius(22), // Image radius
                                      child: CachedNetworkImage(
                                        imageUrl:userData['image'],
                                        imageBuilder: (context, imageProvider) => Container(
                                          height: 80,
                                          width: 110,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        placeholder: (context, url) => const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: CircularProgressIndicator(),
                                        ),
                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                  trailing:  GestureDetector(
                                    onTap: (){

                                        showDialog(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            content: const Text("Are you sure to Delete?"),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(ctx).pop();
                                                },
                                                child: const Text("Cancel",
                                                    style: TextStyle(color: Colors.black)),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  FirebaseFirestore.instance.collection("posts").doc(orders[index].id).delete().then((value){
                                                    setState(() {
                                                      AnimatedSnackBar.material(
                                                        "Your Post Deleted SuccessFully",
                                                        type: AnimatedSnackBarType.success,
                                                      ).show(context);
                                                    });
                                                    navigator!.pop(context);
                                                  });
                                                },
                                                child: const Text(
                                                  "Delete",
                                                  style: TextStyle(color: Colors.red),
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      },

                                    child: const Icon(
                                      Icons.delete_outline,
                                      color: Colors.red,
                                      size: 25,
                                    ),
                                  ),

                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 5),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(orders[index]['description'],style: const TextStyle(
                                            fontWeight: FontWeight.normal,color: Colors.black38,fontFamily: 'Prompt'
                                        ),),
                                      ),

                                    ],
                                  ),
                                ),
                                CachedNetworkImage(
                                  imageUrl:orders[index]['image'],
                                  imageBuilder: (context, imageProvider) => Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                    child: Image.network(orders[index]['image'],
                                      width: MediaQuery.of(context).size.width,
                                      fit: BoxFit.fill,),
                                  ),
                                  placeholder: (context, url) => const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                ),
                                const SizedBox(height: 15,),

                                const SizedBox(height: 15,),
                              ],
                            ),


                          );
                        },
                      );
                    }
                );


              },
            ):
            StreamBuilder(
              stream:
              FirebaseFirestore.instance
                  .collection('feedbacks').where('userId', isEqualTo:FirebaseAuth.instance.currentUser!.uid).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if(snapshot.data!.docs.isEmpty){
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20,),
                      Image.asset('assets/images/logo.png',
                        height: 50,
                      ),
                      const Center(child: Text('Not Found')),
                    ],
                  );
                }
                final orders = snapshot.data!.docs;

                return ListView.builder(
                    itemCount: orders.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context,index){
                      return StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance.collection('users').doc(orders[index]['postUserID']).snapshots(),
                        builder: (context, userSnapshot) {
                          if (userSnapshot.connectionState == ConnectionState.waiting) {
                            return Container();
                          }

                          final userData = userSnapshot.data!.data() as Map<String, dynamic>;

                          return  Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: const Color(0xff0E1041)),
                                borderRadius: BorderRadius.circular(10)),
                            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                            child: Column(
                              children: [
                                ListTile(
                                  title:Text(userData['name']),
                                  subtitle: Text(orders[index]['createdAt'].toDate().toString().substring(0,10)),
                                  leading: userData['image'] == ''?CircleAvatar(
                                      radius: 22,
                                      backgroundColor: Colors.orange,
                                      child: Text(
                                        userData['name'].toString().substring(0,1).toUpperCase(),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ))
                                      :  ClipRRect(
                                    borderRadius: BorderRadius.circular(22), // Image border
                                    child: SizedBox.fromSize(
                                      size: const Size.fromRadius(22), // Image radius
                                      child: CachedNetworkImage(
                                        imageUrl:userData['image'],
                                        imageBuilder: (context, imageProvider) => Container(
                                          height: 80,
                                          width: 110,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        placeholder: (context, url) => const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: CircularProgressIndicator(),
                                        ),
                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                      ),
                                    ),
                                  ),

                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 5),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(orders[index]['feedback'],style: const TextStyle(
                                            fontWeight: FontWeight.w400,color: Colors.black,fontFamily: 'Prompt'
                                        ),),
                                      ),

                                    ],
                                  ),
                                ),

                                const SizedBox(height: 15,),

                              ],
                            ),


                          );
                        },
                      );
                    }
                );


              },
            ),
          ],
        ),
      ),
    );
  }
}
