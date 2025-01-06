import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Home/Home.dart';
import '../Home/fulltext.dart';

class BlogsScreen extends StatefulWidget {
  const BlogsScreen({super.key});

  @override
  State<BlogsScreen> createState() => _BlogsScreenState();
}

class _BlogsScreenState extends State<BlogsScreen> {
  int _currentIndex = 0;

  // Initialize the variables directly in the declaration
  Alignment beginAlignment = Alignment.topCenter;
  Alignment endAlignment = Alignment.bottomCenter;

  @override
  void initState() {
    super.initState();
    beginAlignment = Alignment.topCenter;
    endAlignment = Alignment.bottomCenter;
    _startAnimation();
  }

  void checkBottomNavigationBar() {
    if (_currentIndex == 0)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
  }

  void _startAnimation() {
    // Toggle gradient direction every 2 seconds
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        beginAlignment = beginAlignment == Alignment.topCenter
            ? Alignment.topCenter
            : Alignment.bottomCenter;
        endAlignment = endAlignment == Alignment.bottomCenter
            ? Alignment.topCenter
            : Alignment.bottomCenter;
      });
      _startAnimation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: const [Colors.red, Colors.blue],
            begin: beginAlignment,
            end: endAlignment,
          ),
        ),
        duration: Duration(seconds: 2),
        child: Column(
          children: [
            SizedBox(height: 50),
            ListTile(
              leading: Text(
                "Blogs",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              trailing: IconButton(
                icon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
            ),

            // Row with expanded children
            Expanded(
              child: SingleChildScrollView(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15), // Rounded corners
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Image.asset(
                                  "assets/amb1.jpg",
                                  height: 130,  // Set only height
                                  width: double.infinity,  // Set width to fill available space
                                  fit: BoxFit.cover,  // Ensure the aspect ratio is maintained
                                ),
                                Text(
                                  "New Ambulance will be Introduced in future",
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "Our goal is to revolutionize ambulance services by integrating AI-powered systems, smart vehicle tracking,...", // Truncated text
                                  style: TextStyle(fontSize: 12),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => FullTextScreen(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "Show More",
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15), // Rounded corners
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Image.asset(
                                  "assets/amb1.jpg",
                                  height: 130,  // Set only height
                                  width: double.infinity,  // Set width to fill available space
                                  fit: BoxFit.cover,  // Ensure the aspect ratio is maintained
                                ),
                                Text(
                                  "New Ambulance will be Introduced in future",
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "Our goal is to revolutionize ambulance services by integrating AI-powered systems, smart vehicle tracking,...", // Truncated text
                                  style: TextStyle(fontSize: 12),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => FullTextScreen(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "Show More",
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),

        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey, // Optional, to make unselected items gray
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.article),
              label: "Blogs",
            ),
          ],
          currentIndex: _currentIndex, // Bind currentIndex to _currentIndex
          onTap: (int index) {
            setState(() {
              _currentIndex = index; // Update _currentIndex on tap
              checkBottomNavigationBar(); // Your additional logic if needed
            });
          },
        )
    );
  }
}
