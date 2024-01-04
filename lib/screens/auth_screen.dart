import 'package:flutter/material.dart';
import 'package:pet_booking/screens/home_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isRegisterPage = false;
  bool isLoading = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isRegisterPage == true)
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 15.0, top: 10, right: 15),
                    child: Row(
                      children: [
                        Text("Name"),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.only(left: 15.0, top: 5, right: 15),
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
            GestureDetector(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
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
                      child: isLoading==false ?Text(
                        isRegisterPage == true ? 'Register' : 'Login',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20
                        ),
                      ):const CircularProgressIndicator()),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 20, right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(isRegisterPage == true
                      ? 'Already have and account? '
                      : 'Don\'t have and account? '),
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          isRegisterPage =!isRegisterPage;
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
    );
  }
}
