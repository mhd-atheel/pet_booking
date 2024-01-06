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
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 10,
                itemBuilder: (context,index){
                  return const Request();
                }
            )
          ],
        ),
      ),
    );
  }
}
