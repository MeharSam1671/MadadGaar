import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:madadgaar/Home/showdialog.dart';
import 'package:madadgaar/Maps/maps.dart';
import 'package:madadgaar/Maps/simplemaps.dart';

class Newhome extends StatefulWidget {

  const Newhome({super.key});

  @override
  State<Newhome> createState() => _NewhomeState();
}

class _NewhomeState extends State<Newhome> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final city = args['City'];
    final country = args['Country'];

    return Scaffold(
      backgroundColor: Color(0xFFEFF3F9),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SafeArea(
                      child: Row(
                        children: [
                          Icon(Icons.location_on_sharp),
                          SizedBox(
                            width: 6,
                          ),
                          Text("$city, $country")
                        ],
                      ),
                    ),
                    SafeArea(child: Icon(Icons.person)),
                  ]),
            ),
            Positioned(
                top: MediaQuery.of(context).size.height * 0.17,
                left: MediaQuery.of(context).size.width / 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Need\nEmergency Help",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Colors.black87,
                        letterSpacing: 1.2,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text("Click the button for ambulance"),
                    const SizedBox(height: 10),

                    // Outer silver ring
                    Container(
                      padding: const EdgeInsets.all(6), // Ring thickness
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFFF4F6F8), Color(0xFFB1BAC8)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.6),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),

                      // Inner red button
                      child: Container(
                        height: MediaQuery.of(context).size.width * 0.5,
                        width: MediaQuery.of(context).size.width * 0.5,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Colors.red, Color(0xFFD32F2F)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.redAccent.withOpacity(0.5),
                              blurRadius: 30,
                              spreadRadius: 6,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.sos,
                              size: 50, color: Colors.white),
                          onPressed: () {
                              showScaleDialog(context);

                          },
                        ),
                      ),
                    ),
                  ],
                )),
            SizedBox(
              height: 40,
            ),
            Positioned(
                top: 460,
                left: MediaQuery.of(context).size.width/5,
                child: Text(
                  "Not Sure What to do?",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Colors.black87,
                    letterSpacing: 1.2,
                    height: 1.3,
                  ),
                )),
            Positioned(
                top: 490,
                left: MediaQuery.of(context).size.width/3,
                child: Text(
                  "Pick a Subject to call",

                )),
            Positioned(
              bottom: 60,
              left: -70,
              right: 0,
              child: SizedBox(
                height: 150,
                child: PageView.builder(
                  controller: PageController(viewportFraction: 0.55),
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    // Sample emergency queries
                    final List<String> queries = [
                      "I had an \naccident",
                      "I need \nmedical help",
                      "I feel \nunsafe"
                    ];

                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        elevation: 4,
                        color: Color(0xFFF4F6F8), // Light silver background
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                queries[index],
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(Icons.arrow_forward,
                                      color: Colors.red),
                                  SizedBox(width: 8),
                                  Icon(
                                    Icons.text_fields,
                                    color: Colors.grey[500],
                                  ),
                                  SizedBox(
                                    width: 2,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.redAccent,// Optional, but recommended
        onTap: (index) {
          if(index==1){
            Navigator.push(context, MaterialPageRoute(builder: (context) => Simplemaps(),));
          }
          /*if(index==2){
            Navigator.push(context, History());

          }*/
          if(index==0){

          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
      ),

    );
  }
}
