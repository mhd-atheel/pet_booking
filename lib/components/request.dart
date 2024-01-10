import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Request extends StatefulWidget {
  final String name;
  final String contact;
  final String image;
  final String status;
  final String docId;

  const Request(
      {super.key,
      required this.name,
      required this.contact,
      required this.image,
      required this.status,
      required this.docId

      });

  @override
  State<Request> createState() => _RequestState();
}

class _RequestState extends State<Request> {

  bool isAcceptLoading = false;
  bool isCancelLoading = false;


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
          ),
          widget.status == 'pending'
              ? Row(
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
                )
              : Padding(
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
            height: 15,
          ),
        ],
      ),
    );
  }
}
