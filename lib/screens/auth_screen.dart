import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pet_booking/components/bottom_navbar.dart';
import 'package:pet_booking/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // instances
  bool isRegisterPage = false;
  bool isLoading = false;
  ScrollController scrollController = ScrollController();

  //fire-store
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  //  textEditingControllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final contactController = TextEditingController();
  final addressController = TextEditingController();


  showNotification (notification){
    return AnimatedSnackBar.material(
      notification,
      type: AnimatedSnackBarType.success,
    ).show(context);
  }



  Future<void> createAccount() async {
    setState(() {
      isLoading = true;
    });
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      )
          .then((value) {

        print('create email account success');
        users.doc(FirebaseAuth.instance.currentUser!.uid).set({
          'name': nameController.text,
          'email': emailController.text,
          'password': passwordController.text,
          'contact': contactController.text,
          'address': addressController.text,
        }).then((value) {
          print('account information updated');
          setState(() {
            isLoading = false;
          });
          showNotification("Account Created Successfully");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const BottomNavbar()),
          );
        }).catchError((error) => print("Failed to add user: $error"));
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        setState(() {
          isLoading = false;
        });
        showNotification('The password provided is too weak.');

        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        setState(() {
          isLoading = false;
        });
        print('The account already exists for that email.');
        showNotification('The account already exists');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e);
    }
  }
  Future <void> loginAccount ()async {
    setState(() {
      isLoading = true;
    });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text
      ).then((value) {
        setState(() {
          isLoading = false;
        });
        showNotification('Login Successfully');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const BottomNavbar()),
        );

      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() {
          isLoading = false;
        });
        showNotification('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        setState(() {
          isLoading = false;
        });
        showNotification("Wrong password provided for that user.");
        print('Wrong password provided for that user.');
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: SingleChildScrollView(
          controller: scrollController,
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isRegisterPage == true)
                  Column(
                    children: [
                      const Padding(
                        padding:
                            EdgeInsets.only(left: 15.0, top: 10, right: 15),
                        child: Row(
                          children: [
                            Text("Name"),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, top: 5, right: 15),
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
                                controller: nameController,
                                decoration: const InputDecoration(
                                  hintText: 'Name',
                                  labelStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none,
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                const Padding(
                  padding: EdgeInsets.only(left: 15.0, top: 10, right: 15),
                  child: Row(
                    children: [
                      Text("Email"),
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
                          controller: emailController,
                          decoration: const InputDecoration(
                            hintText: 'Email',
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
                      Text("Password"),
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
                          controller: passwordController,
                          decoration: const InputDecoration(
                            hintText: 'Password',
                            labelStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                          )),
                    ),
                  ),
                ),
                if (isRegisterPage == true)
                  Column(
                    children: [
                      const Padding(
                        padding:
                            EdgeInsets.only(left: 15.0, top: 10, right: 15),
                        child: Row(
                          children: [
                            Text("Contact Number"),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, top: 5, right: 15),
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
                                controller: contactController,
                                decoration: const InputDecoration(
                                  hintText: 'contact number',
                                  labelStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none,
                                )),
                          ),
                        ),
                      ),
                      const Padding(
                        padding:
                            EdgeInsets.only(left: 15.0, top: 10, right: 15),
                        child: Row(
                          children: [
                            Text("Residential Address"),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, top: 5, right: 15),
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
                                controller: addressController,
                                decoration: const InputDecoration(
                                  hintText: 'residential address',
                                  labelStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none,
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                GestureDetector(
                  onTap: () {
                    if(isRegisterPage ==true){
                      createAccount();
                    }else{
                      loginAccount();
                    }

                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => const HomeScreen()),
                    // );
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 15, right: 15, top: 15),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(10)),
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: isLoading == false
                            ? Text(
                                isRegisterPage == true ? 'Register' : 'Login',
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
                              ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 15.0, top: 20, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(isRegisterPage == true
                          ? 'Already have and account? '
                          : 'Don\'t have and account? '),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              isRegisterPage = !isRegisterPage;
                            });
                          },
                          child: Text(
                            isRegisterPage == true ? 'Login' : 'Register',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
