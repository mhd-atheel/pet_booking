import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pet_booking/screens/detail_screen.dart';

class PetPost extends StatelessWidget {
  const PetPost({super.key});

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: (){

      },
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: const Color(0xff0E1041)),
            borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        child: Column(
          children: [
            ListTile(
              title:const  Text("Mohamed Atheel"),
              subtitle: const Text("2024.January.15"),
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
            CachedNetworkImage(
              imageUrl:"https://firebasestorage.googleapis.com/v0/b/pet-booking-36c3a.appspot.com/o/posts%2F1704570086968.png?alt=media&token=7492c9b9-cc6a-40d4-98b2-b61466143f51",
              imageBuilder: (context, imageProvider) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Image.network("https://firebasestorage.googleapis.com/v0/b/pet-booking-36c3a.appspot.com/o/posts%2F1704570086968.png?alt=media&token=7492c9b9-cc6a-40d4-98b2-b61466143f51",
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
  }
}
