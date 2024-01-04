import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {

  const  ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLoading = false;
  bool isEditPressed = false;

  showDetail(key,value){
    return  Column(
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
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w500),
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
  showEditDetail(key,value){
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
                  decoration:  InputDecoration(
                    hintText: value,
                    labelStyle:const TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  )),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Profile".toUpperCase()),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: isEditPressed ==false ?
              ClipRRect(
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
              ):const CircleAvatar(
                radius: 50,
                child: Icon(
                  Icons.add_a_photo_outlined
                ),
              )
            ),
            if(isEditPressed ==false)
              Padding(
                padding: const EdgeInsets.only(left: 15.0, top: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Mohamed Atheel".toUpperCase(),
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold),
                      textHeightBehavior: const TextHeightBehavior(
                          applyHeightToFirstAscent: false,
                          applyHeightToLastDescent: false),
                    ),
                  ],
                ),
              ),
            if(isEditPressed ==false)
              Column(
                children: [
                  showDetail("Your Email :-","atheelofficial@gmail.com"),
                  showDetail("Contact Number :-","+9475 075 5684"),
                  showDetail("Residential Address :-","Puttalam,Sri Lanka"),
        
                ],
              ),
            if(isEditPressed ==true)
              Column(
                children: [
                  showEditDetail("Your Name :-","Mohamed Atheel"),
                  showEditDetail("Your Email :-","atheelofficial@gmail.com"),
                  showEditDetail("Contact Number :-","+9475 075 5684"),
                  showEditDetail("Residential Address :-","Puttalam,Sri Lanka"),
                ],
              ),
        
        
            GestureDetector(
              onTap: (){
                setState(() {
                  isEditPressed = true;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15,top: 30),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(10)),
                  width:  MediaQuery.of(context).size.width
                  ,
                  child: Center(
                      child: isLoading==false ? Text(
                        isEditPressed == false ?'Edit':"Update",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20
                        ),
                      ):const CircularProgressIndicator()),
                ),
              ),
            ),
            if(isEditPressed ==true)
              GestureDetector(
                onTap: (){
                  setState(() {
                    isEditPressed = false;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15,top: 10),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.orange,width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    width:  MediaQuery.of(context).size.width,
                    child: Center(
                        child: isLoading==false ? const Text(
                          "Cancel",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
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
