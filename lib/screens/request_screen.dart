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
        stream: FirebaseFirestore.instance.collection('requests').where('postUserID', isEqualTo:FirebaseAuth.instance.currentUser!.uid).snapshots(),
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
                SizedBox(
                  height: MediaQuery.of(context).size.height/3,
                ),
                Image.asset('assets/images/logo.png',
                  height: 50,
                ),
                const Center(child: Text('Not Found')),
              ],
            );
          }

          // Check if the data is not null before casting
          final orders = snapshot.data!.docs;

          return  ListView.builder(
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

                    return Request(
                        name: userData['name'],
                        contact: userData['contact'],
                        image: userData['image'],
                        status: orders[index]['request'],
                        docId: orders[index].id,
                        postUserID:orders[index]['postUserID'] ,
                    ) ;
                  },
                );
              }
          ) ;
        },
      )

      ],
        ),
      ),
    );
  }
}
