import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Request extends StatefulWidget {
  const Request({super.key});

  @override
  State<Request> createState() => _RequestState();
}

class _RequestState extends State<Request> {
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
            title:const  Text("Mohamed Atheel"),
            subtitle: const Text("+9475 075 5684"),
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

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: (){
                  print("Accepted");
                },
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width/2.5,
                  decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(5)
                  ),
                  child: const Center(
                    child: Text("Accept",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 15
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  print("Canceled");
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(),
                  child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width/2.5,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.orange)
                    ),
                    child: const Center(
                      child: Text("Cancel",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                            fontSize: 15
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15,),
        ],
      ),


    );
  }
}
