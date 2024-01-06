import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLoading = false;
  bool isEditPressed = false;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late String name = '';
  late String email= '';
  late String contact= '';
  late String address= '';

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final contactController = TextEditingController();
  final addressController = TextEditingController();

  Future<void> updateUser() async {
    setState(() {
      isLoading =true;
    });
    await firestore.collection("users")
        .doc( FirebaseAuth.instance.currentUser!.uid)
        .update({
      'name':nameController.text,
      'email':emailController.text,
      'address':addressController.text,
      'contact':contactController.text,
    }).then((value) {
      setState(() {
        isLoading =false;
        isEditPressed = false;
      });
    });
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
                  enabled: key == 'Your Email :-'?false:true,
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



  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Profile".toUpperCase()),
        centerTitle: true,
        automaticallyImplyLeading: false,
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
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(70),
                                child: SizedBox.fromSize(
                                  size: const Size.fromRadius(70),
                                  child: Image.network(
                                    'https://firebasestorage.googleapis.com/v0/b/blogee-2f337.appspot.com/o/userImages%2Fthalapathy_vijay_makes_his_insta_debut-three_four.jpg?alt=media&token=4fe2de28-1323-4705-99a1-c2435af63d69',
                                    width: 30,
                                    height: 30,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              )
                            : const CircleAvatar(
                                radius: 50,
                                child: Icon(Icons.add_a_photo_outlined),
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
                          showEditDetail(
                              "Your Name :-", name,nameController),
                          showEditDetail(
                              "Your Email :-", email,emailController),
                          showEditDetail(
                              "Contact Number :-", contact,contactController),
                          showEditDetail("Residential Address :-",
                              address,addressController),
                        ],
                      ),
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
                                child:Text(
                                        "Cancel",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.orange,
                                            fontSize: 20),
                                      )
                                    ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
