import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pet_booking/components/pet_post.dart';

import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchText = '';
  bool isSearching = false;

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      appBar: AppBar(
        title: Text("Pet Booking App".toUpperCase()),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, top: 10, right: 15,bottom: 10),
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
                          onChanged: (value) {
                            setState(() {
                              isSearching = value.isNotEmpty;
                              searchText = value.toLowerCase();
                            });
                          },
                          decoration: const InputDecoration(
                            hintText: "search",
                            labelStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                            suffixIcon: Icon(FontAwesomeIcons.magnifyingGlass,color: Colors.orange,size: 20,)
                          )),
                    ),
                  ),
                ),
                StreamBuilder(
                  stream: isSearching
                      ? FirebaseFirestore.instance
                      .collection('posts')
                      .where('category', isGreaterThanOrEqualTo: searchText)
                      .where('category', isLessThan: searchText + 'z')
                      .orderBy('category', descending: true)  // Use dogorderBy on the same field
                      .snapshots()
                      : FirebaseFirestore.instance
                      .collection('posts')
                      .orderBy('createdAt', descending: true)
                      .snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Center(child: Text('Something went wrong'));
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
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
                              return  GestureDetector(
                                onTap: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) =>  DetailScreen(
                                      image:orders[index]['image'] ,
                                      description:orders[index]['description'] ,
                                      name:orders[index]['name'] ,
                                      age:orders[index]['age'] ,
                                      breed:orders[index]['breed'] ,
                                      sex:orders[index]['sex'] ,
                                      price:orders[index]['price'] ,
                                      category:orders[index]['category'] ,
                                    )),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: const Color(0xff0E1041)),
                                      borderRadius: BorderRadius.circular(10)),
                                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                                  child: Column(
                                    children: [
                                      ListTile(
                                        title:Text(userData['name']),
                                        subtitle: Text(orders[index]['createdAt'].toDate().toString().substring(0,10)),
                                        leading: ClipRRect(
                                          borderRadius: BorderRadius.circular(22), // Image border
                                          child: SizedBox.fromSize(
                                            size: const Size.fromRadius(22), // Image radius
                                            child: CachedNetworkImage(
                                              imageUrl: "https://firebasestorage.googleapis.com/v0/b/blogee-2f337.appspot.com/o/userImages%2Fthalapathy_vijay_makes_his_insta_debut-three_four.jpg?alt=media&token=4fe2de28-1323-4705-99a1-c2435af63d69",
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
                                      GestureDetector(
                                        onTap: (){
                                          print("Requested");
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                          child: Container(
                                            height: 40,
                                            width: MediaQuery.of(context).size.width,
                                            decoration: BoxDecoration(
                                                color: Colors.orange,
                                                borderRadius: BorderRadius.circular(5)
                                            ),
                                            child: const Center(
                                              child: Text("Request",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    fontSize: 15
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 15,),
                                    ],
                                  ),


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
        ),
    );
  }
}
