import 'package:flutter/material.dart';
import 'package:pet_booking/components/pet_post.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      appBar: AppBar(
        title: Text("Pet Booking App".toUpperCase()),
        centerTitle: true,
      ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
            
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 5,
                    itemBuilder: (context,index){
                      return const PetPost();
                    }
                )
              ],
            ),
          ),
        ),
    );
  }
}
