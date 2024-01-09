import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pet_booking/components/request.dart';

class RequestScreen extends StatelessWidget {
  const RequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Requests".toUpperCase()),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body:  SingleChildScrollView(
        child: Column(
          children: [
        StreamBuilder(
        stream: FirebaseFirestore.instance.collection('requests').doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Check if the data is not null before casting
          final requestData = snapshot.data?.data() as Map<String, dynamic>?;

          if (requestData == null) {
            // Handle the case where data is null
            return const Center(child: Text('Document is null'));
          }

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('requests').doc(FirebaseAuth.instance.currentUser!.uid).collection(snapshot.data!.id).snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snap) {

              if (snapshot.hasError) {
                return const Center(child: Text('Something went wrong'));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              // Check if user data is not null before casting
              //final userData = userSnapshot.data?.data() as Map<String, dynamic>?;
              Map<String, dynamic> myData = snap.data! as Map<String, dynamic>;
              // if (userData == null) {
              //   // Handle the case where user data is null
              //   return Container();
              // }

              // return Request(
              //   name: myData['postId'],
              //   contact: myData['contact'],
              //   image: myData['image'],
              //   status: requestData['request'],
              //   docId: snapshot.data!.id,
              // );

              return SizedBox(
                height: 370,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  children: snap.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> myData = document.data()! as Map<String, dynamic>;
                    return Text(myData['postID']);
                  }).toList(),
                ),
              );
            },
          );
        },
      )

      ],
        ),
      ),
    );
  }
}
