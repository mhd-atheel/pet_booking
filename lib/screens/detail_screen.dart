import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  final String image;
  final String description;
  final String name;
  final String age;
  final String breed;
  final String sex;
  final String price;
  final String category;
  const DetailScreen({
    super.key,
    required this.image,
    required this.description,
    required this.name,
    required this.age,
    required this.breed,
    required this.sex,
    required this.price,
    required this.category,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {

  CollectionReference posts = FirebaseFirestore.instance.collection('requests');



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

  Future <void>createRequest () async{
    posts.add({

      'createdAt':Timestamp.now().toDate(),
      'userId':FirebaseAuth.instance.currentUser!.uid,
    }).then((value) => {
      print("Request Created Successfully")
    });
  }




  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("Details".toUpperCase()),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: RefreshIndicator(
          onRefresh: ()async{
            return Future<void>.delayed(const Duration(seconds: 3));
          },
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Container(
                  height: MediaQuery.of(context).size.height/4.0,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: widget.image,
                    imageBuilder: (context, imageProvider) => Container(
                      height: MediaQuery.of(context).size.height/3.5,
                      width:  MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0,top: 3.0,right: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(widget.description,style: const TextStyle(
                          fontWeight: FontWeight.normal,color: Colors.black38,fontFamily: 'Prompt'
                      ),),
                    ),

                  ],
                ),
              ),
              showDetail("Pet Name :-",widget.name),
              showDetail("Pet Age :-","${widget.age} Years"),
              showDetail("Pet Breed :-",widget.breed),
              showDetail("Pet Price :-",'${widget.price} Rupees'),
              showDetail("sex :-",widget.sex),
              showDetail("category :-",widget.category),
              const SizedBox(height: 20,),
              GestureDetector(
                onTap: (){
                  print("Requested");
                  createRequest();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Container(
                    height: 50,
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
                            fontSize: 20
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
      ),
    );
  }
}
