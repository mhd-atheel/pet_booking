import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
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
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("Details".toUpperCase()),
        centerTitle: true,
      ),
      body: Column(
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
                imageUrl:  "https://firebasestorage.googleapis.com/v0/b/blogee-2f337.appspot.com/o/postImages%2Fimages.jpeg?alt=media&token=e5d63ca9-20c3-4056-994b-f396c493d96d",
                imageBuilder: (context, imageProvider) => Container(
                  height: MediaQuery.of(context).size.height/3.5,
                  width:  MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                placeholder: (context, url) => const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 16.0,top: 3.0,right: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: Text("It is a long established fact that a reader will be distra by t"
                      "he readable  will be distracted by thunge is state controller established fact life",style: TextStyle(
                      fontWeight: FontWeight.normal,color: Colors.black38,fontFamily: 'Prompt'
                  ),),
                ),

              ],
            ),
          ),
          showDetail("Pet Name :-","Candy Puppy"),
          showDetail("Pet Age :-","02 Years"),
          showDetail("Pet Breed :-","Royal Canin Aroma"),
          showDetail("sex :-","Female"),
          const SizedBox(height: 20,),
          GestureDetector(
            onTap: (){
              print("Requested");
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
    );
  }
}
