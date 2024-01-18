import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Request extends StatefulWidget {
  final String name;
  final String contact;
  final String image;
  final String status;
  final String docId;
  final String postUserID;
  const Request(
      {super.key,
      required this.name,
      required this.contact,
      required this.image,
      required this.status,
      required this.docId,
        required this.postUserID
      });

  @override
  State<Request> createState() => _RequestState();
}

class _RequestState extends State<Request> {

  bool isAcceptLoading = false;
  bool isCancelLoading = false;
  bool isFeedLoading = false;
  bool isOpen = false;
  final feedController = TextEditingController();
  CollectionReference feedback = FirebaseFirestore.instance.collection('feedbacks');

  Future<void> updateAcceptRequest() async {
    setState(() {
      isAcceptLoading = true;
    });
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection("requests").doc(widget.docId).update({
      "request":"accepted"
    }).then((value) {
      setState(() {
        isAcceptLoading = false;
      });
    });
  }


  Future<void> deleteAcceptRequest() async {
    setState(() {
      isCancelLoading = true;
    });
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection("requests").doc(widget.docId).delete().then((value) {
      setState(() {
        isCancelLoading = false;
      });
    });
  }

  Future<void> createFeedback(postUserID) async {
    setState(() {
      isFeedLoading = true;
    });
    await feedback.add({
      'createdAt': Timestamp.now().toDate(),
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'postUserID': postUserID,
      'feedback': feedController.text,
    }).then((value) => {
      setState(() {
        isFeedLoading = false;
        isOpen =false;
      }),
      AnimatedSnackBar.material(
        "Feedback Send SuccessFully",
        type: AnimatedSnackBarType.success,
      ).show(context),
      print("Request Created Successfully")
    });
  }



  @override
  Widget build(BuildContext context) {
    return Container(

      decoration: BoxDecoration(
          border: Border.all(color: const Color(0xff0E1041)),
          borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: Column(
        children: [
          ListTile(
            title: Text(widget.name),
            subtitle: Text(widget.contact),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(22), // Image border
              child: SizedBox.fromSize(
                size: const Size.fromRadius(22), // Image radius
                child: widget.image ==''?CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.orange,
                    child: Text(
                      widget.name.toString().substring(0,1).toUpperCase(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold
                      ),
                    )) : CachedNetworkImage(
                  imageUrl: widget.image,
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
            trailing: widget.status != 'pending'? IconButton(
              onPressed: () {
                setState(() {
                  isOpen = !isOpen;
                });
              },
              icon: Icon(
                isOpen == false ?
                Icons.keyboard_arrow_down_outlined :
                Icons.keyboard_arrow_up_outlined
                ,
                size: 30,
              ),

            ):IconButton(onPressed: (){}, icon:Icon( Icons.add,color: Colors.transparent,)),

          ),
          widget.status == 'pending'
              ? Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            print("Accepted");
                            updateAcceptRequest();
                          },
                          child: Container(
                            height: 40,
                            width: MediaQuery.of(context).size.width / 2.5,
                            decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(5)),
                            child: Center(
                              child: isAcceptLoading ==false ? const Text(
                                "Accept",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 15),
                              ):const SizedBox(
                                height: 15.0,
                                width: 15.0,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            deleteAcceptRequest();
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(),
                            child: Container(
                              height: 40,
                              width: MediaQuery.of(context).size.width / 2.5,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: Colors.orange)),
                              child:  Center(
                                child: isCancelLoading ==false ? const Text(
                                  "Cancel",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                      fontSize: 15),
                                ):const SizedBox(
                                  height: 15.0,
                                  width: 15.0,
                                  child: CircularProgressIndicator(
                                    color: Colors.orange,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 15,)
                ],

              )
              : Column(
                children: [
                  if(isOpen ==true)
                    Column(
                      children: [
                        const Padding(
                          padding:
                          EdgeInsets.only(left: 15.0, top: 10, right: 15),
                          child: Row(
                            children: [
                              Text("Add Your Feedback"),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 5,
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
                                  controller: feedController,
                                  decoration: const InputDecoration(
                                    hintText: '...',
                                    labelStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                  )),
                            ),
                          ),
                        ),
                      ],
                    ),

                  SizedBox(
                    height: isOpen ==false ?0: 10,
                  ),
                  if(isOpen ==false)
                    Padding(
                      padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
                      child: Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(5)),
                        child: const Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Accepted",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 15),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Icon(
                                  Icons.done,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                  if(isOpen ==true)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: (){
                            if(feedController.text.isNotEmpty){
                              createFeedback(
                                  widget.postUserID
                              );
                            }else {
                              setState(() {
                                AnimatedSnackBar.material(
                                  "Please Add Feedback",
                                  type: AnimatedSnackBarType.error,
                                ).show(context);
                              });
                            }
                          },
                          child: Container(
                            height: 40,
                            width: MediaQuery.of(context).size.width/2.8,
                            decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(5)),
                            child:  Center(
                              child: isFeedLoading ==false ? const Text(
                                "Send",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 15),
                              ):const SizedBox(
                                height: 15.0,
                                width: 15.0,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              isOpen = false;
                            });
                          },
                          child: Container(
                            height: 40,
                            width: MediaQuery.of(context).size.width/2.8,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.orange)
                            ),
                            child: const Center(
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange,
                                    fontSize: 15),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )

                ],
              ),
           SizedBox(
            height:  isOpen ==false ?0:15,
          ),
        ],
      ),
    );
  }
}
