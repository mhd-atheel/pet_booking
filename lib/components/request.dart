import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Request extends StatefulWidget {
  final String name;
  final String contact;
  final String image;
  final String status;

  const Request(
      {super.key,
      required this.name,
      required this.contact,
      required this.image,
      required this.status});

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
            title: Text(widget.name),
            subtitle: Text(widget.contact),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(22), // Image border
              child: SizedBox.fromSize(
                size: const Size.fromRadius(22), // Image radius
                child: CachedNetworkImage(
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
                      },
                      child: Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width / 2.5,
                        decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(5)),
                        child: const Center(
                          child: Text(
                            "Accept",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 15),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        print("Canceled");
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
                          child: const Center(
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                  fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 15),
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
                            child: Icon(Icons.done,
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
